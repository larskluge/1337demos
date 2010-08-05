atom_feed do |feed|
  feed.title '1337demos.com - news'
  feed.updated(@announcements.first ? @announcements.first.created_at : Time.new.utc)

  for ann in @announcements
    feed.entry(ann) do |entry|
      msg = strip_tags(render(:inline => ann.message))
      entry.title truncate(msg)
      entry.content msg
    end
  end
end

