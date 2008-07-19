#!/usr/bin/ruby -w

require 'net/http'
require 'uri'

# for cron entry:
# cd /home/lars/1337demos.com/1337demos_production && RAILS_ENV=production rake warsowracenet_push_demos

USER = '1337demos'
PASS = '0xbEGjZSuWcaPquHTLLQWl'
URL = "http://#{USER}:#{PASS}@1337.warsow-race.net/push_demo"

response = Net::HTTP.post_form(URI.parse(URL),
	{'from'=>'2005-01-01', 'to'=>'2005-03-31'})

case response
	when Net::HTTPSuccess then
		puts 'WS called successfully. response body:'
		puts response.body
else
	puts 'WS request failed!!!'
	puts response.body
end
