module Glimmer
  module SWT
    # Asynchronous multi-threaded Glimmer SWT proxy base-module that wraps an existing SWT proxy    
    # to enable druby service interactions while an app GUI is running on the main thread
    module Async
      module Proxy
        include Glimmer::SWT::Async
        
        attr_reader :proxy
        
        def initialize(proxy)
          @proxy = proxy
        end
        
        def heartbeat
          Time.now.utc.tap do |time|
            @heartbeat = time
            Glimmer::Config.logger.debug "Heartbeat from client at: #{time}"
          end
        end
        
      end
      
    end
    
  end
  
end
