# config/initializers/pony.rb

Pony.options = {

	:to => 'hello@girlsguild.com',
	:via => :smtp,
	:via_options => {
		:address => 'smtp.gmail.com',
		:port => '587',
		:enable_starttls_auto => true,
		:user_name => 'hello@girlsguild.com',
		:password => 'g1rl5bu1ld',
		:authentication => :plain, # :plain, :login, :cram_md5, no auth by default
		:domain => "girlsguild.com" # the HELO domain provided by the client to the server
	}

}