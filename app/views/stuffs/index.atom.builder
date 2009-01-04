atom_feed do |feed|
  feed.title 'Stuff uploads'
  feed.updated(@stuffs.first ? @stuffs.first.created_at : Time.new.utc)

  for stuff in @stuffs
    feed.entry(stuff, :url => stuff.public_filename) do |entry|
      entry.title "#{h stuff.filename} by #{render_nickname_plain stuff.comment.name}"
    end
  end
end

