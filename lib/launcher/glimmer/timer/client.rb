require 'logging'
require 'glimmer/config'
require 'ext/glimmer/config'
require 'fileutils'

# Glimmer::Config.logger.error org.eclipse.swt.internal.cocoa.NSBundle.bundle_with_identifier(org.eclipse.swt.internal.cocoa.NSString.stringWith 'org.glimmer.application.timer')

module Glimmer
  class Timer
    class Client
      include Glimmer
      
      SERVER_SCRIPT_FILE = File.expand_path('../../../../../bin/glimmer-cs-timer-server', __FILE__)
      
      attr_reader :async_app_shell
      
      def initialize
        at_exit {
          Glimmer::Config.logger.info "Exiting"
          async_app_shell&.close
          Glimmer::Config.logger.info "Sent request to async_app_shell.close"
          Glimmer::Config.logger.appenders.each(&:flush)          
        }              
      end
      
      def server_running?
        !!(`ps aux`.split("\n").detect { |line| line.include?('glimmer-cs-timer-server') } )
      end
      
      def start
        require 'drb/drb'
        started_server = false
        while async_app_shell.nil?
          begin
            @async_app_shell = DRbObject.new_with_uri('druby://127.0.0.1:12345')
            Glimmer::Config.logger.debug async_app_shell.heartbeat
            Glimmer::Config.logger.info "Connected: #{async_app_shell}"
            Glimmer::Config.logger.appenders.each(&:flush)          
          rescue StandardError, DRb::DRbConnError => e
            @async_app_shell = nil
            Glimmer::Config.logger.debug "Failed to connect. #{e.message}. Retrying..."
            unless started_server || server_running?            
              if File.exist?('glimmer-cs-timer.jar')
                system "GLIMMER_APP_LAUNCHER=server GLIMMER_LOGGER_LEVEL=#{Logging::LEVELS.invert[Glimmer::Config.logger.level]} java -XstartOnFirstThread -jar glimmer-cs-timer.jar &" 
              else
                system "glimmer --log-level=#{Logging::LEVELS.invert[Glimmer::Config.logger.level]} #{SERVER_SCRIPT_FILE} &" 
              end
              started_server = true
            end
            sleep(0.05)
          end
        end
        
        async_app_shell.open
        Glimmer::Config.logger.info "Sent request to async_app_shell.open"
        Glimmer::Config.logger.appenders.each(&:flush)          
        
        opened = nil
        opened_heartbeat = 0
        until opened || opened_heartbeat == 100
          unless opened.nil?
            sleep(0.05)
            Glimmer::Config.logger.debug async_app_shell.heartbeat
            opened_heartbeat += 1
          end
          begin
            opened = async_app_shell.visible?
          rescue StandardError, DRb::DRbConnError => e    
            Glimmer::Config.logger.debug "Encountered error while checking app visible status. #{e.message}. Retrying..."
            opened = false
          end  
        end
        
        Glimmer::Config.logger.info "App is visible."
        Glimmer::Config.logger.appenders.each(&:flush)         
        open
      end
      
      def open
        require 'glimmer-dsl-swt'
        # build a make shift shell just to have the mac bouncing icon stop bouncing when GUI shows up
        shell { |proxy|
          alpha 0
          on_swt_show {
            @close_monitoring_thread ||= Thread.new {
              begin
                sleep(0.1)
                closed = nil
                begin                  
                  Glimmer::Config.logger.debug async_app_shell.heartbeat
                  closed = !async_app_shell.visible?
                rescue StandardError, DRb::DRbConnError => e    
                  Glimmer::Config.logger.debug e.full_message
                  closed = true
                end
              end until closed  
              Glimmer::Config.logger.info "App closed from service."
              Glimmer::Config.logger.appenders.each(&:flush)
              async_exec {
                proxy.swt_widget.close unless proxy.swt_widget.disposed?
              }
            }
          }
          on_shell_activated {
            async_exec {
              closed = nil
              begin
                closed = !async_app_shell.visible?
              rescue DRb::DRbConnError => e    
                closed = true
              end              
              async_app_shell.force_active unless proxy.swt_widget.disposed? || closed
            }            
          }
          on_shell_closed {
            Glimmer::Config.logger.info "App closed from client."
            Glimmer::Config.logger.appenders.each(&:flush)              
          }
        }.open      
      end
    end
  end
end
