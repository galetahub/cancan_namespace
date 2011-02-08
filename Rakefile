require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'cancan_namespace', 'version')

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the cancan_namespace plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the cancan_namespace plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'CancanNamespace'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "cancan_namespace"
    gemspec.version = CancanNamespace::Version.dup
    gemspec.summary = "Cancan namespace"
    gemspec.description = "Add namespace for cancan authorization library"
    gemspec.email = "galeta.igor@gmail.com"
    gemspec.homepage = "https://github.com/galetahub/cancan_namespace"
    gemspec.authors = ["Igor Galeta", "Pavlo Galeta"]
    gemspec.files = FileList["[A-Z]*", "lib/**/*"]
    gemspec.rubyforge_project = "cancan_namespace"
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
