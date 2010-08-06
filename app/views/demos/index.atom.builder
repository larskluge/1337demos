atom_feed(:"xmlns:media" => "http://search.yahoo.com/mrss/") do |feed|
  feed.title @feed_title
  feed.updated(@demos.first ? @demos.first.created_at : Time.new.utc)

  @demos.each do |demo|
    feed.entry(demo) do |entry|
      players = demo.players.map{|player| player.main_nickname_plain}.join(', ')
      title = (demo.position.nil? ? "#{demo.title}" : "##{demo.position} ") + "#{players} on #{demo.map.name}"

      entry.title truncate(title)
      entry.content title
      entry.author do |author|
        author.name players
      end

      entry.tag!("media:content", :url => video_url(demo, :format => "mp4"), :type => "video/mp4")
      entry.tag!("media:thumbnail", :url => map_thumbnail_url(demo.map_id, "200x150"), :width => 200, :height => 150)
    end
  end
end

