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

