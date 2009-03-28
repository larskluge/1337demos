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

#
# xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
# xml.rss('version' => '2.0') do
# 	xml.channel do
# 		xml.title @feed_title
# 		xml.link root_url
# 		xml.description @feed_title
# 		xml.language 'en-us'
# 		xml.ttl '30'
# 		xml.pubDate @announcements.first.created_at.strftime('%a, %d %b %Y %H:%M:%S %Z')
# 		@announcements.each do |announcement|
#       title = truncate(announcement.message)
#       url = root_url
#       guid = announcement_url(announcement)
# 			# url = url_for(:host => WEB_DEFAULT_HOST, :controller => 'demos', :action => 'show', :id => demo, :layout => 'true')
# 			xml.item do
# 				xml.title title
# 				xml.link url
# 				xml.description announcement.message
# 				xml.guid url
# 				xml.pubDate announcement.created_at.strftime('%a, %d %b %Y %H:%M:%S %Z')
# 			end
# 		end
# 	end
# end
