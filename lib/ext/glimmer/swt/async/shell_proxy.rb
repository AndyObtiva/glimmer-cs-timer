require 'ext/glimmer/swt/async/proxy'

module Glimmer
  module SWT
    module Async
      class ShellProxy
        include Glimmer::SWT::Async::Proxy
      
        def open
          Glimmer::Config.logger.info 'Received a client request to Glimmer::SWT::Async::ShellProxy#open'
          Glimmer::Config.logger.appenders.each(&:flush)          
          async {
            @open = true
            @proxy.swt_widget.set_alpha(255)
            @proxy.visible = true
            @proxy.swt_widget.set_active
            @proxy.swt_widget.set_focus
          }
          Thread.new {
            until !@open || (@heartbeat && (Time.now.utc - @heartbeat) > 1)
              sleep(1)
            end    
            async_exec {
              close if @open && (@heartbeat && (Time.now.utc - @heartbeat) > 1)
            }
          }
        end
        
        def close
          Glimmer::Config.logger.info 'Received a client request to Glimmer::SWT::Async::ShellProxy#close'
          Glimmer::Config.logger.appenders.each(&:flush)          
          async {
            if @open
              @open = false
              @heartbeat = nil
              @proxy.visible = false
            end
          }
        end
        
        def method_missing(method, *args, &block)
          async_await {
            @proxy&.send(method, *args, &block)
          }
        end
        
        def respond_to?(method, *args, &block)
          async_await {
            @proxy&.respond_to?(method, *args, &block)
          }
        end
      end
    end
  end
end
