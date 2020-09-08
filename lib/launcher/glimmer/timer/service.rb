require 'glimmer-cs-timer'

# TODO if the app has just been started from the client (not just as a service), then display shell right away without hiding first

require 'ext/glimmer/swt/async'

module Glimmer
  class Timer
    class Service
      # TODO look into abstracting Service into a reusable supermodule or superclass
      
      include Glimmer
       
      attr_reader :app_shell
      
      def initialize
        first_time = true
        @app_shell = timer { |proxy|
          alpha 0 # make invisible so user doesn't see it's preloaded
          on_shell_closed { |event|
            event.doit = false # preventing real closing (just hide instead)
            proxy.visible = false
          }
          on_swt_show { |event|
            if first_time
              Glimmer::Config.logger.info "App GUI is ready for display."
              Glimmer::Config.logger.appenders.each(&:flush)          
              first_time = false
            end
          }
        }  
      end  
      
      def start
        # TODO support a way to shut down (like via file touch)
        Thread.new {
          async_exec {
            app_shell.hide unless app_shell.swt_widget.alpha > 0
            require 'drb/drb'
        
            async_app_shell = Glimmer::SWT::Async::ShellProxy.new(app_shell) # needed for DRB
            # TODO make sure to select an available port randomly to support having multiple apps
            service_uri = 'druby://127.0.0.1:12345'
            DRb.start_service(service_uri, async_app_shell)
            Glimmer::Config.logger.info "App Service is ready for client connection at: #{service_uri}"
            Glimmer::Config.logger.appenders.each(&:flush)            
          }
        }  
        app_shell.open # must happen on first thread since it contains GUI
        app_shell.dispose
        DRb.stop_service
      end
    end
  end
end
