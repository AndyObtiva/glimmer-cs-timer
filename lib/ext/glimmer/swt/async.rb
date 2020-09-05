module Glimmer
  module SWT
    # Asynchronous multi-threaded Glimmer SWT methods to perform operations
    # in a separate thread asynchronously of the main GUI thread.
    module Async
      include Glimmer
      
      def async(&operation)
        Thread.new {
          async_exec {
            begin
              operation.call
            rescue => e
              Glimmer::Config.logger e.full_message
            end      
          }
        }
      end  
      
      def async_await(&operation)
        result = nil
        Thread.new {
          async_exec {
            begin
              result = operation.call
            rescue => e
              Glimmer::Config.logger e.full_message
              result = nil
            end      
          }
        }
        while result.nil?
          sleep(0.01)      
        end
        result  
      end  
    end  
  end
end

Dir.glob(File.expand_path('../async/**/*.rb', __FILE__)) {|f| require f}
