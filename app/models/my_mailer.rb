class MyMailer < ActionMailer::Base

	def send_demo_uploaded_notification(map, player)
		recipient = 'lars@die-viper.de'

		@from = 'newdemo@1337demos.com'
		@recipients = recipient
		@subject = 'New demo uploaded'
		#@subject += ' by ' + players.demo.players.first.main_nickname_plain if demo.players.length > 0
		@subject += ' by ' + player if player
		@body[:recipient] = recipient
		@body[:map] = map
		@body[:player] = player
	end

end
