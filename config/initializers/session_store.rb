# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :session_key => '1337demos_session',
  :secret      => '201c9ca2d8956eb62c8a1e91ce124ed28a9cf1571e900a112c2f2d11ebd2acf5ff4ad81deceee166d4564fae762201eb3e48346164497d232ad444d8dda734b9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

