module Glimmer
  class Timer
    include Glimmer::UI::CustomShell
    
    import 'javax.sound.sampled'

    APP_ROOT = File.expand_path('../../../..', __FILE__)
    VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
    LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
    FILE_SOUND_ALARM = File.join(APP_ROOT, 'sounds', 'alarm1.wav')
        
    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240
    option :greeting, default: 'Hello, World!'

    attr_accessor :countdown, :min, :sec

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
          display_about_dialog
        }
      }

      @min = 0
      @sec = 0
    }

    ## Use after_body block to setup observers for widgets in body
    #
    after_body {
      Thread.new {
        loop {
          sleep(1)
          if @countdown
            sync_exec {
              @countdown_time = Time.new(1, 1, 1, 0, min, sec)
              @countdown_time -= 1
              self.min = @countdown_time.min
              self.sec = @countdown_time.sec
              if @countdown_time.min <= 0 && @countdown_time.sec <= 0
                stop_countdown
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
        minimum_size (OS.windows? ? 214 : 200), 114
        image File.join(APP_ROOT, 'package', 'windows', "Timer.ico") if OS.windows?
        text "Timer"
        grid_layout

        group {
          text 'Countdown'
          font height: 20

          composite {
            row_layout {
              margin_width 0
              margin_height 0
            }
            @min_spinner = spinner {
              text_limit 2
              digits 0
              maximum 60
              selection bind(self, :min)
              enabled bind(self, :countdown, on_read: :!)
              on_widget_default_selected {
                start_countdown
              }
            }
            label {
              text ':'
              font(height: 18) if OS.mac?
            }
            @sec_spinner = spinner {
              text_limit 2
              digits 0
              maximum 60
              selection bind(self, :sec)
              enabled bind(self, :countdown, on_read: :!)
              on_widget_default_selected {
                start_countdown
              }
            }
          }

          composite {
            row_layout {
              margin_width 0
              margin_height 0
            }
            @start_button = button {
              text '&Start'
              enabled bind(self, :countdown, on_read: :!)
              on_widget_selected {
                start_countdown
              }
              on_key_pressed { |event|
                start_countdown if event.keyCode == swt(:cr)
              }
            }
            @stop_button = button {
              text 'St&op'
              enabled bind(self, :countdown)
              on_widget_selected {
                stop_countdown
              }
              on_key_pressed { |event|
                stop_countdown if event.keyCode == swt(:cr)
              }
            }
          }
        }
        menu_bar {
          menu {
            text '&File'
            menu_item {
              text 'Preferences...'
              on_widget_selected {
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
    
    def start_countdown
      self.countdown = true
      @stop_button.swt_widget.set_focus    
    end

    def stop_countdown
      self.countdown = false
      @min_spinner.swt_widget.set_focus
    end

    def play_countdown_done_sound
      begin
        if FILE_SOUND_ALARM.start_with?('uri:classloader')
          jar_file_path = FILE_SOUND_ALARM
          file_path = jar_file_path.sub(/^uri\:classloader\:/, '').sub('//', '/') # the latter sub is needed for Mac
          object = java.lang.Object.new
          file_input_stream = object.java_class.resource_as_stream(file_path)          
          file_or_stream = java.io.BufferedInputStream.new(file_input_stream)      
        else
          file_or_stream = java.io.File.new(FILE_SOUND_ALARM)
        end
        audio_stream = AudioSystem.get_audio_input_stream(file_or_stream)
        clip = AudioSystem.clip
        clip.open(audio_stream)
        clip.start
      rescue => e
        pd e
        puts e.full_message
      end
    end

  end
end
