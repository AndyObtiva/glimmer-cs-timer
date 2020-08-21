module Glimmer
  class Timer
    include Glimmer::UI::CustomShell
    
    import 'javax.sound.sampled'

    APP_ROOT = File.expand_path('../../../..', __FILE__)
    VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
    LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
        
    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240
    option :greeting, default: 'Hello, World!'

    def play_countdown_done_sound
      begin
        file_path = File.expand_path(File.join('..', 'alarm1.wav'), __FILE__)
        file = java.io.File.new(file_path)
        audio_stream = AudioSystem.get_audio_input_stream(file)
        clip = AudioSystem.clip
        clip.open(audio_stream)
        clip.start
      rescue => e
        pd e
        puts e.full_message
      end
    end

    ## Use before_body block to pre-initialize variables to use in body
    #
    #
    before_body {
      Display.setAppName('Timer')
      Display.setAppVersion(VERSION)
      @display = display {
        on_about {
          display_about_dialog
        }
        on_preferences {
          #display_preferences_dialog
          display_about_dialog
        }
      }
    }

    ## Use after_body block to setup observers for widgets in body
    #
    after_body {
      @countdown_date_time_widget.swt_widget.setTime(0, 0, 0)
      Thread.new {
        loop {
          sleep(1)
          if @countdown
            sync_exec {
              @countdown_time = Time.new(1, 1, 1, @countdown_date_time_widget.hours, @countdown_date_time_widget.minutes, @countdown_date_time_widget.seconds)
              @countdown_time -= 1
              @countdown_date_time_widget.swt_widget.setTime(@countdown_time.hour, @countdown_time.min, @countdown_time.sec) 
              if @countdown_time.hour <= 0 && @countdown_time.min <= 0 && @countdown_time.sec <= 0
                @countdown = false
                play_countdown_done_sound
              end
            }
          end
        }
      }
    }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body {
      shell {
        # Replace example content below with custom shell content
        minimum_size 320, 240
        image File.join(APP_ROOT, 'package', 'windows', "Timer.ico") if OS.windows?
        text "Glimmer - Timer"
        grid_layout

        label {text 'Set Countdown:'}
        @countdown_date_time_widget = date_time(:time) {
          on_widget_default_selected {
            @countdown = true
          }
        }

        button {
          text 'Start'
          on_widget_selected {
            @countdown = true
          }
        }
        menu_bar {
          menu {
            text '&File'
            menu_item {
              text 'Preferences...'
              on_widget_selected {
                #display_preferences_dialog
                display_about_dialog
              }
            }
          }
        }
      }
    }

    def display_about_dialog
      message_box(body_root) {
        text 'About'
        message "Glimmer - Timer #{VERSION}\n\n#{LICENSE}"
      }.open
    end
    
    def display_preferences_dialog
      dialog(swt_widget) {
        text 'Preferences'
        grid_layout {
          margin_height 5
          margin_width 5
        }
        group {
          row_layout {
            type :vertical
            spacing 10
          }
          text 'Greeting'
          font style: :bold
          [
            'Hello, World!', 
            'Howdy, Partner!'
          ].each do |greeting_text|
            button(:radio) {
              text greeting_text
              selection bind(self, :greeting) { |g| g == greeting_text }
              layout_data {
                width 160
              }
              on_widget_selected { |event|
                self.greeting = event.widget.getText
              }
            }
          end
        }
      }.open
    end
  end
end
