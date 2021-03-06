# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'glimmer/launcher'
require 'rake'

require 'juwelier'
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "glimmer-cs-timer"
  gem.homepage = "http://github.com/AndyObtiva/glimmer-cs-timer"
  gem.license = "MIT"
  gem.summary = %Q{Timer - Glimmer Custom Shell}
  gem.description = %Q{Timer - Glimmer Custom Shell - It supports a countdown timer}
  gem.email = "andy.am@gmail.com"
  gem.authors = ["Andy Maleh"]
  gem.files = Dir['VERSION', 'LICENSE.txt', 'CHANGELOG.md', 'README.md', 'glimmer-cs-timer.gemspec', 'lib/**/*', 'app/**/*', 'bin/**/*', 'vendor/**/*', 'package/**/*', 'sounds/**/*', 'images/**/*']
  gem.executables = ['glimmer-cs-timer', 'timer']
  gem.require_paths = ['vendor', 'lib', 'app']
  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.ruby_opts = [Glimmer::Launcher. jruby_os_specific_options]
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "glimmer-cs-timer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'glimmer/rake_task'
Glimmer::RakeTask::Package.javapackager_extra_args =
  " -name 'Timer'" +
  " -title 'Timer'" +
  " -Bwin.menuGroup='Timer'" +
  " -Bmac.CFBundleName='Timer'" +
  " -Bmac.CFBundleIdentifier='org.glimmer.application.timer'"
  # " -BlicenseType=" +
  # " -Bmac.category=" +
  # " -Bmac.signing-key-developer-id-app="
