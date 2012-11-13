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
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "megahal"
  gem.homepage = "http://github.com/jasonhutchens/megahal"
  gem.license = "MIT"
  gem.summary = %Q{MegaHAL is a learning chatterbot.}
  gem.description = %Q{MegaHAL is a grammatical inference algorithm that can generate quasi natural language sentences in the context of a conversation.}
  gem.email = "jasonhutchens@gmail.com"
  gem.authors = ["Jason Hutchens"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
