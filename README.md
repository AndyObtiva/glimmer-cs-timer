# <img src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-timer/master/images/glimmer-timer-logo.png" height=80 /> Glimmer Timer
## [<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=40 /> Glimmer Custom Shell](https://github.com/AndyObtiva/glimmer#custom-shell-gem)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Mac Version**

![glimmer-timer-screenshot](glimmer-timer-screenshot.png) 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Windows Version**
<br>
<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![glimmer-timer-screenshot-windows](glimmer-timer-screenshot-windows.png)
<br>
Glimmer Timer is a sample desktop GUI application built with Glimmer (Ruby Desktop Development Library).

Currently supports a countdown timer only.

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-timer/master/images/glimmer-timer-logo.png" height=40 /> Download Mac Version](https://www.dropbox.com/s/cfd0rsjfuy3gexe/Timer-1.0.0.dmg?dl=1)

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-timer/master/images/glimmer-timer-logo.png" height=40 /> Download Windows Version](https://www.dropbox.com/s/z0auecd44crkn2l/Timer-1.0.0.msi?dl=1)

## Platforms

This has been tested and confirmed to be working on:
- Mac: [Download DMG File](https://www.dropbox.com/s/cfd0rsjfuy3gexe/Timer-1.0.0.dmg?dl=1)
- Windows: [Download MSI File](https://www.dropbox.com/s/z0auecd44crkn2l/Timer-1.0.0.msi?dl=1)

## Pre-requisites

- [Glimmer](https://github.com/AndyObtiva/glimmer) application, [Glimmer](https://github.com/AndyObtiva/glimmer) custom shell, or another [Glimmer](https://github.com/AndyObtiva/glimmer) custom widget
- JRuby version required by Glimmer
- Java version required by Glimmer

## Setup

### Glimmer Application

Add the following to a Glimmer application `Gemfile`:

```ruby
gem 'glimmer-cs-timer', '1.0.0'
```

Run:

```
jruby -S bundle
```

(or just `bundle` if using RVM)

### Glimmer Custom Shell or Glimmer Custom Widget

When reusing in a Glimmer custom shell or custom widget, you can follow the same steps for Glimmer application, and then add a require statement to your library file:

```ruby
require 'glimmer-cs-timer'
# ... more require statements follow
```
## Contributing to glimmer-cs-timer
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

[MIT](https://opensource.org/licenses/MIT)

Copyright (c) 2020 Andy Maleh.

--

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=40 />](https://github.com/AndyObtiva/glimmer) Built with [Glimmer](https://github.com/AndyObtiva/glimmer) (Ruby Desktop Development GUI Library)

Icon made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
