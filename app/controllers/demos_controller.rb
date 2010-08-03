class DemosController < ApplicationController

  include PlayerInfo


  def index
    #gamemode = request.parameters[:action] if ['race', 'freestyle'].include?(request.parameters[:action])
    @title = "latest demos"
    @headline = 'Latest demos.'
    @feed_title = "1337demos.com - #{@title}"
    @rss = { :title => @feed_title, :url => demos_url(:format => 'atom') }

    @demos = Demo.paginate(:page => page_param,
      :per_page => 20,
      :conditions => 'data_correct' + (params[:format] == 'atom' ? ' AND status = "rendered"' : ''),
      :include => :map,
      :order => 'demos.created_at DESC')

    respond_to do |format|
      format.html
      format.atom { render :action => 'rss', :layout => false }
    end
  end

  def race
    @title = 'latest race demos'
    @headline = 'Latest race demos.'
    @feed_title = "1337demos.com - #{@title}"
    @rss = { :title => @feed_title, :url => url_for(:format => 'atom') }

    @demos = Demo.race.paginate(:page => page_param,
      :per_page => 20,
      :conditions => (params[:format] == 'atom' ? 'status = "rendered"' : ''),
      :include => :map,
      :order => 'demos.created_at DESC')

    respond_to do |format|
      format.html { render :action => 'index' }
      format.atom { render :action => 'rss', :layout => false }
    end
  end

  def freestyle
    @title = 'latest freestyle demos'
    @headline = 'Latest freestyle demos.'
    @feed_title = "1337demos.com - #{@title}"
    @rss = { :title => @feed_title, :url => url_for(:format => 'atom') }

    @demos = Demo.freestyle.paginate(:page => page_param,
      :per_page => 20,
      :conditions => (params[:format] == 'atom' ? 'status = "rendered"' : ''),
      :include => :map,
      :order => 'demos.created_at DESC')

    respond_to do |format|
      format.html { render :action => 'index' }
      format.atom { render :action => 'rss', :layout => false }
    end
  end



  def show
    @demo = Demo.find(params[:id])
    @title = "#{@demo.players.map{|player| player.main_nickname_plain}.join(', ')} on #{@demo.map.name}"
    @comment = Comment.new(:name => player_info[:name], :mail_pass => player_info[:mail_pass])
    @video_player = (['flash', 'quicktime'].include?(session[:video_player])) ? session[:video_player] : 'flash'
    @top3 = @demo.toplist

    @prev = Demo.last(:conditions => ['id < ? AND data_correct', @demo.id])
    @next = Demo.first(:conditions => ['id > ? AND data_correct', @demo.id])
  end

  def file
    @demos = [Demo.find(params[:id])]
    render :layout => false
  end

  def verify
    @demo = Demo.find params[:id]

    # prevent data being modified after upload process
    if @demo.data_correct == true
      redirect_to(:action => 'show', :id => @demo)
      return
    end

    @playernames, @fixed_nickname = nil
    dr = DemoReader.parse(@demo.demofile.full_filename)
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
        Player.transaction do
          Nickname.transaction do
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

            # notify me
            begin
              playernames = 'unknown'
              playernames = players.map{|player| player.main_nickname_plain}.join(', ') if !players.nil? && players.length > 0
              mail = MyMailer.create_send_demo_uploaded_notification(@demo, @demo.map.name, playernames)
              MyMailer.deliver(mail)
            rescue Exception => e
              logger.info '=== Mail deliverty error: ' + e.message
            end
          end
        end
      rescue Exception => e
        @demo.errors.add_to_base e.message
        params[:demo][:players] = nil
        render :action => 'verify'
      end
    end

    if @demo.update_attributes(params[:demo])
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
      persist_player_info(@comment)
      flash[:notice] = 'Comment was successfully created.'
      redirect_to :action => 'show', :id => @demo
    else
      render :action => 'show'
    end
  end

end

