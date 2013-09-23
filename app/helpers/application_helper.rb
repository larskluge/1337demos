module ApplicationHelper

  # generates a classname for the active page
  def classname_for_page
    ([controller.controller_name, controller.action_name].compact * '-').downcase
  end


  def default_title
    ([controller.controller_name] << (" // " + controller.action_name if controller.action_name != 'index') << " - 1337demos.com").compact.join
  end


  def render_admin_mainmenu
    semantic_menu :class => 'nav' do |root|
      root.add 'Home', admin_root_path
      root.add 'Announcements', admin_announcements_path
      root.add 'Users', admin_users_path
      root.add 'Shouts', admin_shoutboxes_path
      root.add 'Demos', admin_demos_path
      root.add 'Players', admin_players_path
      root.add 'Comments', admin_comments_path
      root.add 'Nicknames', admin_nicknames_path
      root.add 'Stuff', admin_stuffs_path
    end
  end


  def render_linked_map(map)
    link_to(map.name, map_path(map), {:class => "map_link map_link_#{map.id}"})
  end

  def render_linked_player(player)
    link_to render_nickname(player.main_nickname.nickname), player_path(player), class: 'nickname'
  end

  def render_linked_players(players)
    players.map{|player| render_linked_player(player)}.join(', ').html_safe
  end

  def render_time_title(demo)
    return demo.title if demo.title.present?

    res = "##{demo.position} &nbsp;" if demo.position.to_i > 0
    return "#{res}#{render_race_time(demo.time)}".html_safe if demo.time.to_i > 0

    "n/a"
  end

  def render_position(demo)
    pos = demo.position
    return '<i>improved by player</i>'.html_safe if pos.nil?
    sprintf('%s of %d',
      pos.ordinalize,
      demo.map.demos.select{|d| !d.position.nil? && d.position > 0}.length)
  end

  def render_toplist(demos, active_demo = nil)
    render :partial => '/demos/toplist', :locals => { :toplist => demos, :active_demo => active_demo }
  end




  def color_index color_code
    if color_code > '0' then color_code.to_i else 0 end
  end


  def render_nickname(name)
    return nil if name.blank?

    html = name.gsub(/\^([^\^])/){"</span><span class=\"c#{self.color_index($1)}\">"}
    html = "<span class=\"c7\">#{html}</span>"

    html.gsub(/\^\^/, '^').html_safe
  end

  def render_nicknames(names)
    Array(names).map { |name|
      render_nickname(name)
    }.join(", ").html_safe
  end

  def render_nickname_plain(name)
    strip_tags(render_nickname(name))
  end



  def render_race_time(msec)
    return 'n/a' if msec.nil?

    sec = msec / 1000
    msec = msec % 1000

    min = sec / 60
    sec = sec % 60

    ('%02d:%02d.%03d' % [ min, sec, msec ]).html_safe
  end

  def render_race_time_difference(from_msec, to_msec)
    return '-' if from_msec == to_msec

    diff = from_msec - to_msec
    msec = diff.abs

    sec = msec / 1000
    msec = msec % 1000

    min = sec / 60
    sec = sec % 60

    prefix, color = if diff == 0
               ['', 'yellow']
             elsif diff > 0
               ['+', 'red']
             else
               ['-', 'green']
             end

    ('<span style="color:%s">%s %02d:%02d.%03d</span>' % [ color, prefix, min, sec, msec ]).html_safe
  end



  def render_datetime(datetime)
    datetime.strftime('%Y/%m/%d %H:%M')
  end

  def render_date(datetime)
    datetime.strftime('%Y/%m/%d')
  end



  def render_rating_text(rating)
    if rating.rated?
      sprintf('%.2f (%s)', rating.average, pluralize(rating.count, 'vote'))
    else
      '(unrated)'
    end
  end

  def render_rating_dynamic(rating)
    if rating.rated?
      sprintf('%.2f (%s)', rating.average, pluralize(rating.count, 'vote'))
    else
      '(unrated)'
    end
  end

  def render_rating_static(rating)
    if rating.rated?
      render :partial => '/ratings/stars_static', :locals => { :rating => rating }
    else
      render_rating_text(rating)
    end
  end


  def gravatar_tag(record, size = 50)
    if record.respond_to?(:has_gravatar?) && record.has_gravatar?
      url = record.gravatar_url(:size => size, :default => 'identicon')
      image_tag url, :class => 'gravatar', :alt => '', :size => [size,size].join('x')
    end
  end


  def format_game_with_mode(demo)
    gameversion = case demo.version
                  when 10 then "0.4"
                  when 11 then "0.5"
                  when 12 then "0.6"
                  end

    [demo.game, gameversion, demo.gamemode].join(" ")
  end


  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end

  def error_messages_for(*records)
    messages = records.map { |rec| rec.errors.full_messages }.flatten
    content_tag :ul, messages.map { |msg|
      content_tag :li, msg, class: 'error'
    }.join.html_safe
  end

  def approve_check_box_tag_for user
    check_box_tag 'approved', '1', user.approved, :'data-toggle-approve-for-user' => user.id
  end

end

