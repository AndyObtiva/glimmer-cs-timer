require 'drb/drb'

there = nil

at_exit {
  puts "Exiting"
  there.close
}

until there
  begin
    there = DRbObject.new_with_uri('druby://127.0.0.1:12345')
    puts "There: #{there}"
  rescue DRb::DRbConnError => e
    puts '>>DRb::DRbConnError'
    puts e.full_message
    puts 'sleeping'
    sleep(0.5)
    there = nil
  end  
end
puts "Connected There: #{there}"
there.open
begin
  sleep(0.1)
  opened = nil
  begin
    opened = there.visible?
  rescue DRb::DRbConnError => e
    puts 'server down'
    puts e.full_message
    exit(1)
  end
  puts "there.opened? #{opened}"
end until opened
puts 'Opened? true'

# build a make shift shell just to have the mac bouncing icon stop bouncing when GUI shows up
require 'glimmer-dsl-swt'
include Glimmer
shell { |proxy|
  alpha 0
  on_swt_show {
    loop {
      sleep(0.1)
      closed = nil
      begin
        closed = there.visible.nil? || !there.visible?
      rescue DRb::DRbConnError => e
        puts e.full_message
        closed = true
      end
      if closed
        puts "there.closed? true"
        proxy.swt_widget.close      
      end
    }
  }
}.open
# TODO observe server object for closing and close icon when that happens 
