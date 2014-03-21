require "sinatra/base"
require "./lib/html_renderer"

# Load custom environment variables
load 'env.rb' if File.exists?('env.rb')

class DoorkeeperClient < Sinatra::Base
  enable :logging
  enable :sessions

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    def pretty_json(json)
      JSON.pretty_generate(json)
    end

    def signed_in?
      !session[:access_token].nil?
    end

    def markdown(text)
      options  = { :autolink => true, :space_after_headers => true, :fenced_code_blocks => true }
      markdown = Redcarpet::Markdown.new(HTMLRenderer, options)
      markdown.render(text)
    end

    def markdown_readme
      markdown(File.read(File.join(File.dirname(__FILE__), "README.md")))
    end
  end

  def client(token_method = :post)
    client_id = ENV['OAUTH2_CLIENT_ID'] || "JCmF3BKia4EeMae8X4EymKQDPhP0UhQHPQwLbzgr"
    client_secret = ENV['OAUTH2_CLIENT_SECRET'] || "2g5uCp5WqwhLlftuDv9Y2k1Dk6QMkTMEItwcfB2Q"
    OAuth2::Client.new(
      client_id,
      client_secret,
      :site           => ENV['SITE'] || "http://demo.pixfizz.com/v1",
      :authorize_url  => ENV['SITE_AUTHORIZE_URL'] || "http://demo.pixfizz.com/v1/oauth/authorize",
      :token_url      => ENV['SITE_TOKEN_URL'] || "http://demo.pixfizz.com/v1/oauth/token",
      :token_method   => token_method
    )
  end

  def access_token
    OAuth2::AccessToken.new(client, session[:access_token], :refresh_token => session[:refresh_token])
  end

  def redirect_uri
    ENV['OAUTH2_CLIENT_REDIRECT_URI']
  end

  get '/' do
    erb :home
  end

  get '/sign_in' do
    scope = params[:scope] || "public"
    redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri, :scope => scope)
  end

  get '/sign_out' do
    session[:access_token] = nil
    redirect '/'
  end

  get '/callback' do
    new_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
    session[:access_token]  = new_token.token
    session[:refresh_token] = new_token.refresh_token

    # Get current user's ID
    response = access_token.get("/v1/users/me")
    json = JSON.parse(response.body)
    session[:user_id] = json['id']
    redirect '/'
  end

  get '/refresh' do
    new_token = access_token.refresh!
    session[:access_token]  = new_token.token
    session[:refresh_token] = new_token.refresh_token
    redirect '/'
  end

  get '/explore/*' do
    raise "Please call a valid endpoint" unless params[:splat]
    
    logger.info "Requesting URL #{params[:splat][0]}"

    begin
      response = access_token.get("/v1/#{params[:splat][0]}")
      @json = JSON.parse(response.body)
      erb :explore, :layout => !request.xhr?
    rescue OAuth2::Error => @error
      erb :error, :layout => !request.xhr?
    end
  end
end
