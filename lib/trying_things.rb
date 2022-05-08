require 'rack'
require 'rack/contrib'
require 'thin'

class Logs
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    puts "SERVER AUTHORITY = #{req.server_authority}"
    puts "BODY = #{req.body}"
    puts "get? = #{req.delete?}"
    puts "PATH = #{req.path}"
    puts "FULLPATH = #{req.fullpath}"
    puts "ACCEPT ENCODING = #{req.accept_encoding}"
    puts "ACCEPT LANGUAGE = #{req.accept_language}"
    @app.call(env)
  end
end

class Response
  def call(env)
    req = Rack::Request.new(env)
    if req.path == "/"
      body = File.read('./app/views/default.html.erb')
      Rack::Response.new(body, 200, {"Content-Type" => "text/plain"})
    else
      Rack::Response.new("File not existing", 200, {"Content-Type" => "text/plain"})
    end
  end
end

app = Rack::Builder.new do |builder|
  builder.use Logs
  builder.run Response.new
end

Rack::Handler::Thin.run app

