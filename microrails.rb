require 'rubygems'
require 'action_controller'
# require 'active_record'
require 'dispatcher'

ActiveSupport::Dependencies.mechanism = :require
ActionView::Base.cache_template_loading = false
ActionController::Base.view_paths = [File.join(File.dirname(__FILE__), "views")]
# ActionController::Dispatcher.unprepared = false


class ActionController::Dispatcher
  def prepare_application
  end
end

def session(key, secret)
  ActionController::Base.session = { :session_key => key, :secret => secret }
end

def routes(&block)
  ActionController::Routing::Routes.draw do |map|
    map.instance_eval(&block)
  end
end

def controller(name, &block)
  ActionController::Routing.controller_paths << name
 
  klass = Object.const_set("#{name.camelize}Controller", Class.new(ActionController::Base))
  klass.class_eval(&block)
end

def start_webrick(host, port)
  require 'webrick'
  require 'webrick_server'
  
  puts
  puts "Booting WEBrick"
  
  puts "-- WEBrick listening at #{host}:#{port}"
  puts "-- Use CTRL-C to stop"
  
  DispatchServlet.dispatch(
    :port         => port,
    :ip           => host,
    :server_root  => File.dirname(__FILE__),
    :server_type  => WEBrick::SimpleServer,
    :charset      => "UTF-8",
    :mime_types   => WEBrick::HTTPUtils::DefaultMimeTypes,
    :debugger     => false)
end

def start_mongrel(host, port)
  require 'mongrel'
  require 'mongrel/rails'
    
  puts
  puts "Booting Mongrel"

  config = Mongrel::Configurator.new :host => host do
    listener :port => port do
      uri "/", :handler => Mongrel::Rails::RailsHandler.new(File.dirname(__FILE__))

      trap("INT") { stop }
      run
    end
  end

  puts "-- Mongrel listening at #{host}:#{port}"
  puts "-- Use CTRL-C to stop"

  config.join
end

def start(host, port)
  ActionController::Routing.use_controllers! ActionController::Routing.controller_paths
  
  begin
    require_library_or_gem 'mongrel'
  rescue Exception
    # Mongrel not available
  end

  if defined?(Mongrel)
    start_mongrel(host, port)
  else
    start_webrick(host, port)
  end
end