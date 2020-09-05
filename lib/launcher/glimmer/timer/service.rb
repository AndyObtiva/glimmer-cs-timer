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
        @app_shell = timer { |proxy|
          alpha 0 # make invisible so user doesn't see it's preloaded
          on_shell_closed { |event|
            event.doit = false # preventing real closing (just hide instead)
            proxy.visible = false
          }
        }  
      end  
      
      def start
        Thread.new {
          async_exec {
            app_shell.hide
            require 'drb/drb'
        
            async_app_shell = Glimmer::SWT::Async::ShellProxy.new(app_shell) # needed for DRB
            # TODO make sure to select an available port randomly to support having multiple apps
            DRb.start_service("druby://127.0.0.1:12345", async_app_shell)
            puts 'Service is ready.'
          }
        }  
        app_shell.open # must happen on first thread since it contains GUI
        app_shell.dispose
        DRb.stop_service
      end
    end
  end
end
