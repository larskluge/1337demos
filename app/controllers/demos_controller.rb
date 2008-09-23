require 'demo_reader'

class DemosController < ApplicationController

  # caching
  caches_action :index, :list, :rss, :cache_path => :cache_path.to_proc
  cache_sweeper :demo_sweeper, :only => [:update]
  cache_sweeper :player_sweeper, :only => [:update]
  cache_sweeper :comment_sweeper, :only => [:create_comment]



  def index
    #gamemode = request.parameters[:action] if ['race', 'freestyle'].include?(request.parameters[:action])
    @title = "latest demos"
    @headline = 'Latest demos.'
    @feed_title = "1337demos.com - #{@title}"
    @rss = { :title => @feed_title, :url => formatted_demos_url('atom') }

    @demos = Demo.paginate(:page => params[:page],
      :per_page => 20,
      :conditions => 'data_correct' + (params[:format] == 'atom' ? ' AND status = "rendered"' : ''),
      :include => %w(map),
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

    @demos = Demo.race.paginate(:page => params[:page],
      :per_page => 20,
      :conditions => (params[:format] == 'atom' ? 'status = "rendered"' : ''),
      :include => [:map, {:players => :main_nickname}],
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

    @demos = Demo.freestyle.paginate(:page => params[:page],
      :per_page => 20,
      :conditions => (params[:format] == 'atom' ? 'status = "rendered"' : ''),
      :include => [:map, {:players => :main_nickname}],
      :order => 'demos.created_at DESC')

    respond_to do |format|
      format.html { render :action => 'index' }
      format.atom { render :action => 'rss', :layout => false }
    end
  end



  def show
    @demo = Demo.find(params[:id])
    @title = "#{@demo.players.map{|player| player.main_nickname_plain}.join(', ')} on #{@demo.map.name}"
    @comment = Comment.new
    @video_player = (['flash', 'quicktime'].include?(session[:video_player])) ? session[:video_player] : 'flash'
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
    dr = DemoReader.new @demo.demofile.full_filename
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
            playernames = 'unknown'
            playernames = players.map{|player| player.main_nickname_plain}.join(', ') if !players.nil? && players.length > 0
            mail = MyMailer.create_send_demo_uploaded_notification(@demo, @demo.map.name, playernames)
            MyMailer.deliver(mail)
          end
        end
      rescue Exception => e
        @demo.errors.add_to_base e.message
        params[:demo][:players] = nil
        render :action => 'verify'
        return
      end
    end

=begin
    if params[:demo][:player]
      nickname = Nickname.find_by_nickname params[:demo][:player]
      if nickname
        params[:demo][:player] = nickname.player
      else
        begin
          Player.transaction do
            Nickname.transaction do
              player = Player.create!
              nickname = player.create_in_nicknames :nickname => params[:demo][:player], :player => player
              player.main_nickname = nickname
              player.save!
              params[:demo][:player] = nickname.player
            end
          end
        rescue Exception => e
          @demo.errors.add_to_base e.message
          params[:demo][:player] = nil
        end
      end
    end
=end

    if @demo.update_attributes(params[:demo])
      flash[:notice] = 'Demo was successfully uploaded.'
      redirect_to :action => 'show', :id => @demo
    else
      render :action => 'verify'
    end
  end



  def create_comment
    self.show

    if (@comment = @demo.comments.create(params[:comment])) && @comment.valid?
      flash[:notice] = 'Comment was successfully created.'
      redirect_to :action => 'show', :id => @demo
    else
      render :action => 'show'
    end
  end



=begin
  def resolutions
    res = []
    (4..1024).each do |w|
      (3..768).each do |h|
        if w % 16 == 0 && h % 16 == 0 && ((w.to_f / h.to_f) - 4.0/3.0).abs <= Float::EPSILON
          res << "#{w}x#{h}"
        end
      end
    end
    render :text => res.join('<br />'), :layout => true
  end
=end
end
