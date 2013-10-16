# Pixfizz Example OAuth API app

This app is designed to demonstrate Pixfizz's use of OAuth to authenticate API calls.

It's written with the Ruby microframework, [Sinatra](http://www.sinatrarb.com/) and uses [oauth2](https://github.com/intridea/oauth2) for OAuth interactions. 

## Installing (after installing ruby)

    $ git clone git://github.com/pixfizz/oauth2_client_example.git

    $ cd oauth2_client_example

    $ gem install bundler

    $ bundle install

## Configuration

### Client application

First, setup an OAuth application in the Pixfizz Admin interface. This will provide you with a series of URLs.

You will have to set a few environment variables to get this app running. 

### Server variables

All the variables are stored in env.rb, in the project base directory. 

    # env.rb
    ENV['SITE']                       = "http://subdomain.pixfizz.com/v1"
    ENV['SITE_AUTHORIZE_URL']         = "http://subdomain.pixfizz.com/site/oauth_authorize" 
    ENV['SITE_TOKEN_URL']             = "http://subdomain.pixfizz.com/v1/oauth/token" 
    ENV['OAUTH2_CLIENT_ID']           = "wr6qcg..."
    ENV['OAUTH2_CLIENT_SECRET']       = "K33Ebm..."
    ENV['OAUTH2_CLIENT_REDIRECT_URI'] = "http://localhost:3004/callback"

    SITE variable must end with /v1
    
    OAUTH2_CLIENT_REDIRECT_URI should point to this application, http://localhost:$PORT/callback.
    Change the port number from 3004 if using something different.

Or set them as environment variables in your shell.

## Start the server

Fire up the server on port 3004 with:

    rackup config.ru -p 3004
