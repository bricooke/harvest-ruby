# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/harvest.rb'
require 'spec/rake/spectask'


Hoe.new('harvest-ruby', Harvest::VERSION) do |p|
  p.rubyforge_name = 'harvest-ruby' # if different than lowercase project name
  p.developer('Brian Cooke', 'bcooke@roobasoft.com')
end


desc "Run specifications"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = './spec/**/*_spec.rb'
end


# vim: syntax=Ruby
