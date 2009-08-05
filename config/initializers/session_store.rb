# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_foodrecorder_session',
  :secret      => '5a23926d63655abc7ad31c08b361de926df3c262b08361a0650cd48d8a78e058df7121c96d9f16eb07efb16ab96e873b2c4a6049c0ddb58f6de72e57acee3902'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
