require 'ext/glimmer/swt/async/proxy'

module Glimmer
  module SWT
    module Async
      class ShellProxy
        include Glimmer::SWT::Async::Proxy
        
        HEARTBEAT_DELAY_MAX = 2
      
        def open
          Glimmer::Config.logger.info 'Received a client request to Glimmer::SWT::Async::ShellProxy#open'
          Glimmer::Config.logger.appenders.each(&:flush)          
          async {
            @open = true
            @proxy.swt_widget.set_alpha(255)
            @proxy.visible = true
            @proxy.swt_widget.force_active unless proxy.display.active_shell == proxy.swt_widget
          }
          @close_monitoring_thread ||= Thread.new {
            until closed? || heartbeat_delay_exceeds_max?
              sleep(1)
            end    
            async_exec {
              close if open? && heartbeat_delay_exceeds_max?
            }
          }
        end
        
        def close
          Glimmer::Config.logger.info 'Received a client request to Glimmer::SWT::Async::ShellProxy#close'
          Glimmer::Config.logger.appenders.each(&:flush)          
          async {
            if open?
              @open = false
              @heartbeat = nil
              @proxy.visible = false
            end
          }
        end
        
        def force_active
          Glimmer::Config.logger.info 'Received a client request to Glimmer::SWT::Async::ShellProxy#force_active'
          Glimmer::Config.logger.appenders.each(&:flush)          
          async {
            if open?
              @proxy.swt_widget.force_active unless proxy.display.active_shell == proxy.swt_widget
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
        
        def open?
          @open
        end
        
        def closed?
          !@open
        end
        
        def heartbeat_delay_exceeds_max?
          @heartbeat && (Time.now.utc - @heartbeat) > HEARTBEAT_DELAY_MAX
        end
      end
    end
  end
end
