# README: Pixfizz OAuth API example app

This app is designed to demonstrate Pixfizz's use of OAuth to authenticate API calls.

It's written with the Ruby microframework, [Sinatra](http://www.sinatrarb.com/) and uses [OAuth 2.0](https://github.com/intridea/oauth2) for OAuth interactions.

If you have any issues with this app or setting it or ruby up, please [make a new issue on our tracker](https://github.com/pixfizz/oauth2_client_example/issues) and we'll help you out.

Pixfizz employs [OAuth 2.0 draft 10](http://tools.ietf.org/html/draft-ietf-oauth-v2-10) for authentication. We also support basic plain text HTTP authentication.

It is suggested that in a production environment, you communicate with us using HTTPS, but it is not a requirement.

## Installing (after installing ruby 1.9.3)

    $ git clone git://github.com/pixfizz/oauth2_client_example.git

    $ cd oauth2_client_example

    $ gem install bundler

    $ bundle install

## Configuration

This example app will work straight away with the demo.pixfizz.com subdomain.

Configuration will be needed if you want it to work with your own subdomain and application.

### Client application

First, setup an OAuth application in the Pixfizz Admin interface. This will provide you with a series of URLs.

You will have to set a few environment variables to get this app running. 

### Server variables

All the variables are stored in env.rb, in the project base directory. 

    # env.rb
    ENV['SITE']                       = "http://subdomain.pixfizz.com/v1"
    ENV['SITE_AUTHORIZE_URL']         = "http://subdomain.pixfizz.com/v1/oauth/authorize" 
    ENV['SITE_TOKEN_URL']             = "http://subdomain.pixfizz.com/v1/oauth/token" 
    ENV['OAUTH2_CLIENT_ID']           = "wr6qcg..."
    ENV['OAUTH2_CLIENT_SECRET']       = "K33Ebm..."
    ENV['OAUTH2_CLIENT_REDIRECT_URI'] = "http://localhost:3004/callback"

    SITE variable must end with /v1 so that the API is detected. 
    
    OAUTH2_CLIENT_REDIRECT_URI should point to this application, http://localhost:PORT/callback.
    Change the port number from 3004 if using something different.

Or set them as environment variables in your terminal shell.

## Start the server

Fire up the server on port 3004 with:

    rackup config.ru -p 3004
