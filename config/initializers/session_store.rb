# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_learning_revolution_session',
  :secret      => 'fbee0d3ff3a6a2f387befbe8497ef139df475721fd10d3b44e52ce511bb1c797644d3922429b56adb79f0e97a0005f691cf70cc8f3f33331b64d682e391148a6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
