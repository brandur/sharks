#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'gsaf_log_parser'

Sharks::Application.load_tasks

task :parse => :environment do
  file = './GSAF5.csv'
  GsafLogParser.new.parse_and_save(file)
end

desc 'Deploys a new secret token to config/initializers/secret_token.rb'
task :secret_deploy do
  secret = `rake secret`.strip
  token_file = 'config/initializers/secret_token.rb'
  File.open(token_file, 'w') do |file|
    file.puts File.read(token_file + ".example").gsub(/<secret token>/, secret)
  end
  puts "Wrote secret to #{token_file}"
end

