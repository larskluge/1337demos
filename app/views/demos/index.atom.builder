atom_feed do |feed|
  feed.title @feed_title
  feed.updated(@demos.first ? @demos.first.created_at : Time.new.utc)

  @demos.each do |demo|
    feed.entry(demo) do |entry|
      players = demo.players.join(', ')
      title = (demo.position.nil? ? "#{demo.title}" : "##{demo.position} ") + "#{players} on #{demo.map.name}"

      entry.title truncate(title)
      entry.content title
      entry.author do |author|
        author.name players
      end
      entry.link :rel => "enclosure", :type => "video/mpeg4", :href => video_url(demo, :format => "mp4")
    end
  end
end

