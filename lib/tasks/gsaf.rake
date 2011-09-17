require 'sharks'

#
# To fully process a set of records, run:
#     rake download xls2csv parse
#
# Which will run each requisite step in the correct order:
#     rake download -- Downloads the latest shark attack file
#     rake xls2csv  -- Convert XLS to a computer-friendly CSV
#     rake parse    -- Parse the CSV and store its records to the DB
#

task :download do
  file = ENV['FILE'] || "#{Rails.root}/gsaf.xls"
  assert_cmd_present('curl')
  `curl http://www.sharkattackfile.net/spreadsheets/GSAF5.xls -o #{file}`
end

task :parse => :environment do
  file = ENV['FILE'] || "#{Rails.root}/gsaf.csv"
  Sharks::GsafLogParser.new.parse_and_save(file)
end

# Install `xls2csv` on Archlinux with `pacman -S catdoc`
task :xls2csv do
  file_in  = ENV['FILE_IN']  || "#{Rails.root}/gsaf.xls"
  file_out = ENV['FILE_OUT'] || "#{Rails.root}/gsaf.csv"
  assert_cmd_present('xls2csv')
  `xls2csv -c\| #{file_in} > #{file_out}`
end

def assert_cmd_present(cmd)
  raise "Command #{cmd} is required, please install it" if `which #{cmd}`.strip.empty?
end
