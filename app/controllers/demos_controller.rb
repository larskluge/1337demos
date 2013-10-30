class DemosController < ApplicationController

  def index
    @title = "All Demos"
    @headline = 'All Demos'
    @feed_url = 'http://feeds.feedburner.com/1337demos-latest-demos'

    render_demos(Demo.scoped)
  end



  def race
    @title = 'Race Demos'
    @headline = 'Race Demos'
    @feed_url = 'http://feeds.feedburner.com/1337demos-latest-race-demos'

    render_demos(Demo.race)
  end

  def freestyle
    @title = 'Freestyle Demos'
    @headline = 'Freestyle Demos'
    @feed_url = 'http://feeds.feedburner.com/1337demos-latest-freestyle-demos'

    render_demos(Demo.freestyle)
  end



  def show
    @demo = Demo.find(params[:id])
    @title = "#{@demo.players} on #{@demo.map}"
    @comment ||= Comment.new
    @comment.build_user unless @comment.user
    @comments = @demo.comments.approved
    @top3 = @demo.toplist

    @prev = Demo.first(:conditions => ['id < ? AND data_correct', @demo.id])
    @next = Demo.last(:conditions => ['id > ? AND data_correct', @demo.id])
  end

  def verify
    @demo = Demo.find(params[:id])

    # prevent data being modified after upload process
    #
    return redirect_to(:action => 'show', :id => @demo) if @demo.data_correct

    dr = @demo.demofile.read_demo
    @gamemode = dr.time_in_msec.to_i > 0 ? "race" : "freestyle"
    if dr.player
      @fixed_nickname = dr.player
    else
      @playernames = dr.playernames.compact.sort.uniq
    end
  end

  def update
    self.verify

    if params[:demo][:players]
      begin
        params[:demo][:players] = [params[:demo][:players]] if params[:demo][:players].class != Array
        ActiveRecord::Base.transaction do
          nicknames = params[:demo][:players].map do |nickname|
            Nickname.find_or_create_by_nickname nickname
          end
          players = nicknames.map do |nickname|
            player = nil
            unless player = nickname.player
              player = Player.create!
              player.nicknames << nickname
              player.main_nickname = nickname
              player.save!
              nickname.player = player
              nickname.save!
            end
            player
          end.uniq
          params[:demo][:players] = players
        end
      rescue Exception => e
        @demo.errors.add_to_base e.message
        params[:demo][:players] = nil
        render :action => 'verify'
      end
    end

    if @demo.update_attributes(params[:demo])
      # notify me
      DemoMailer.uploaded_info(@demo).deliver

      flash[:notice] = 'Demo was successfully uploaded.'
      redirect_to :action => 'show', :id => @demo
    else
      render :action => 'verify'
    end
  end



  # FIXME: a comment sould not be created via demo
  #
  def create_comment
    self.show

    hash = params[:comment] || {}
    hash.delete :token

    if (@comment = @demo.comments.create(hash)) && @comment.valid?
      flash[:notice] = 'Comment was successfully created.'
      redirect_to :action => 'show', :id => @demo
    else
      render :action => 'show'
    end
  end


  protected

  def render_demos(scoped_demos)
    @feed_title = "1337demos.com - #{@title}"

    # publish only rendered demos in feed
    #
    scoped_demos = scoped_demos.rendered if params[:format] == "atom"

    @demos = scoped_demos.data_correct.page(page_param)

    respond_to do |format|
      format.html { render :action => 'index' }
      format.atom { render :action => 'index', :layout => false }
    end
  end

end


