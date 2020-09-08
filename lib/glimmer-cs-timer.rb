$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require 'glimmer-dsl-swt'
require 'views/glimmer/timer'

Glimmer::Config.logger.level = :info
