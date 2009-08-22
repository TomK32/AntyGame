# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_antgame_session',
  :secret      => 'ef6fbac2ce8d1064d11161d25ac1330cbf84e266cf0b9bbf682fe6e8d818acb0e166f92c9185177db067be159b6b9b00c2eb19421b1797197048eee4c065c426'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
