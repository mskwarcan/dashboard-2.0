require 'rexml/document'
require 'rest_client'
require 'uri'
require 'time'
require 'heroku/version'
require 'json'

# A Ruby class to call the Heroku REST API. You might use this if you want to
# manage your Heroku apps from within a Ruby program, such as Capistrano.
#
# Example:
#
# require 'heroku'
# heroku = Heroku::Client.new('me@example.com', 'mypass')
# heroku.create('myapp')
#
class Heroku::Client
  def self.version
    Heroku::VERSION
  end

  def self.gem_version_string
    "heroku-gem/#{version}"
  end

  attr_accessor :host, :user, :password

  def self.auth(user password, host='heroku.com')
    client = new(user, password, host)
    JSON.parse client.post('/login', { :username => user, :password => password }, :accept => 'json').to_s
  end

  def initialize(user, password, host='heroku.com')
    @user = user
    @password = password
    @host = host
  end

  def set_workers(app_name, qty)
    put("/apps/#{app_name}/workers", :workers => qty).to_s
  end
end