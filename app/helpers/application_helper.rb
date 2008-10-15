# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper

  # generates a classname for the active page
  def classname_for_page
    ([controller.controller_name, controller.action_name].compact * '-').downcase
  end


  # this method doesnt render the root node
  #def render_mainmenu(tree, depth = 0, active = false)
  #	return '' if tree.nil?
  #	depth += 1
  #	leaf = depth < 2 && !node.children.empty? # render max 2 levels
    #
  #	ret = "\n<ul #{'class="nav"' if depth == 1} #{'style="display:block"' if active}>"
  #	tree.children.each do |node|
  #		ret += "\n\t<li>"
  #			options = { :controller => node.controller, :action => node.action }
  #			active = controller.controller_name == node.controller
  #			attr = { :class => 'active' } if active
  #			ret += link_to node.name, options, attr
  #			ret += render_mainmenu(node, depth, active) if leaf
  #		ret += "\t</li>\n"
  #	end
  #	ret += "</ul>\n"
  #end

  # this method doesnt render the root node
  #def render_mainmenu(node)
  #	return if node.nil?
    #
  #	ret = "\n<ul #{'class="nav"' if node.depth.zero?} #{'style="display:block"' if node.self_or_descendant_active?(controller.controller_name, controller.action_name)}>"
  #	node.children.each do |child|
  #		ret += "\n\t<li>"
  #			options = { :controller => child.controller, :action => child.action }
  #			attr = { :class => 'active' } if child.self_or_descendant_active?(controller.controller_name, controller.action_name)
  #			ret += link_to child.name, options, attr
  #			ret += render_mainmenu(child) unless child.leaf?
  #		ret += "\t</li>\n"
  #	end
  #	ret += "</ul>\n"
  #end

  # this method doesnt render the root node
  def render_mainmenu(node)
    return if node.nil?

    ret = "\n<ul #{'class="nav"' if node.level.zero?} #{'style="display:block"' if node.self_or_descendant_active?(controller.controller_name, controller.action_name)}>"
    node.children.each do |child|
      ret += "\n\t<li>"
        options = { :controller => child.controller, :action => child.action }
        attr = { :class => 'active' } if child.self_or_descendant_active?(controller.controller_name, controller.action_name)
        ret += link_to child.name, options, attr
        ret += render_mainmenu(child) unless child.leaf?
      ret += "\t</li>\n"
    end
    ret += "</ul>\n"
  end

  def render_linked_map(map)
    link_to(map.name, {:controller => 'maps', :action => 'show', :id => map}, {:class => "map_link map_link_#{map.id}"}) if map.kind_of? Map
  end

  def render_linked_player(player)
    link_to(render_nickname(player.main_nickname.nickname), :controller => 'players', :action => 'show', :id => player) if player.kind_of? Player
  end

  def render_linked_players(players)
    players.map{|player| render_linked_player(player)}.join(', ')
  end

  def render_time_title(demo)
    case demo.gamemode
      when 'freestyle'
        demo.title.nil? ? 'n/a' : h(demo.title)
      when 'race'
        res = demo.position.nil? ? '' : "##{demo.position} &nbsp;"
        res + self.render_race_time(demo.time)
    end
  end

  def render_position(demo)
    pos = demo.position
    return '<i>improved by player</i>' if pos.nil?
    sprintf('%s of %d',
      pos.ordinalize,
      demo.map.demos.select{|d| !d.position.nil? && d.position > 0}.length)
  end





  def color_index(color_code)
    #if color_code =~ /^([0-9])$/ && $1 > '0'
    if color_code > '0'
      return color_code.to_i
    else
      return 0
    end
  end

  def render_nickname(name)

    return nil if name.nil? || name.empty?

    html = h(name).gsub(/\^([^\^])/){"</span><span class=\"c#{self.color_index($1)}\">"}

    # remove first </span> if needed
    matchdata = /^<\/span>/.match(html)
    if matchdata
      html = matchdata.post_match
    end

    matchdata = /<span.*>/.match(html)
    if matchdata
      html += '</span>'
    end

    # if no colors used, use standard
    matchdata = /^<span.*>/.match(html)
    if !matchdata
      html = "<span class=\"c7\">#{html}</span>"
    end

    html.gsub /\^\^/, '^'
  end



  def render_race_time(msec)
    return 'n/a' if msec.nil?

    sec = msec / 1000
    msec = msec % 1000

    min = sec / 60
    sec = sec % 60

    '%02d:%02d.%03d' % [ min, sec, msec ]
  end



  def render_datetime(datetime)
    h(datetime.strftime('%Y/%m/%d %H:%M'))
  end

  def render_date(datetime)
    h(datetime.strftime('%Y/%m/%d'))
  end



  def render_rating_text(rating)

    if rating.rated?
      sprintf('%.2f (%s)', rating.average, pluralize(rating.count, 'vote'))
    else
      #r = record.rating_range
      #avg = (r.last - r.first) / 2.0 + r.first # std average
      #sprintf '%.2f', avg

      '(unrated)'
    end
  end

  def render_rating_dynamic(rating)

    if rating.rated?
      sprintf('%.2f (%s)', rating.average, pluralize(rating.count, 'vote'))
    else
      #r = record.rating_range
      #avg = (r.last - r.first) / 2.0 + r.first # std average
      #sprintf '%.2f', avg

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
end

