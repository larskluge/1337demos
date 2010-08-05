atom_feed do |feed|
  feed.title @feed_title
  feed.updated(@demos.first ? @demos.first.created_at : Time.new.utc)

  @demos.each do |demo|
    feed.entry(demo) do |entry|
      title = (demo.position.nil? ? "#{demo.title}" : "##{demo.position} ") + "#{demo.players.map{|player| player.main_nickname_plain}.join(', ')} on #{demo.map.name}"

      entry.title truncate(title)
      entry.content title
    end
  end
end

