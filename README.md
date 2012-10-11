# Capistrano::Pushover

This gem adds hooks to capistrano to send push notifications using [Pushover](https://pushover.net/) service.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-pushover'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-pushover

## Usage

Add to deploy.rb:

	require 'hipchat/capistrano'
	
	set :pushover_app_token, 'Your Pushover Application Token'
	set :pusehover_user_key, 'Your Pushover User Token'
	
Now you are ready to recieve notificaion about deploys.

If a deploy fails you will also recieve notification about the failure.

### Who did it?

To determine the user that is currently running the deploy, the capistrano tasks will look for the following:

1. The $PUSHOVER_USER environment variable.
2. The git user.name var.
3. The $USER environment variable.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Shuky Dvir.

**MIT License.**

See LICENSE for details.