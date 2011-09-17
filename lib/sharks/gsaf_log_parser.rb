# encoding: utf-8

require 'csv'
require 'geokit'

module Sharks
  class GsafLogParser
    def parse(file)
      CSV.foreach(file, col_sep: '|') do |row|
        # Skip the header row in the CSV
        next if row[0] == 'Case #'
        incident = parse_row({
          :case_id     => row[0],
          :occurred_on => row[1],
          :country     => row[2],
          :area        => row[3],
          :location    => row[4],
          :activity    => row[5],
          :name        => row[6],
          :sex         => row[7],
          :age         => row[8],
          :injury      => row[9],
          :time_of_day => row[10],
          :species     => row[11],
          :source      => row[12],
        })
        if incident
          yield incident if block_given?
          $stdout.puts "Parsed '#{incident.case_id}'"
        end
      end
    end

    def parse_and_save(file)
      parse(file) do |new_incident|
        incident = Incident.find_by_case_id(new_incident.case_id)
        if incident
          incident.attributes = new_incident.attributes
        else
          incident = new_incident
        end
        incident.save!
      end
    end

    def parse_row(row)
      incident = Incident.new
      incident.case_id         = sanitize(row[:case_id])
      return unless incident.case_id
      incident.occurred_on     = sanitize(row[:occurred_on]) do |str|
        begin
          parse_date(str)
        rescue
          nil
        end
      end
      incident.occurred_on_str = sanitize(row[:occurred_on])
      incident.country         = sanitize(row[:country]) do |str|
        if str
          case str.downcase
          when 'reunion'
            'Réunion'
          when 'uae'
            'United Arab Emirates'
          when /^united arab emirates/
            'United Arab Emirates'
          when 'usa'
            'USA'
          else
            str.titlecase
          end
        end
      end
      incident.area            = sanitize(row[:area])
      incident.location        = sanitize(row[:location])
      incident.activity        = sanitize(row[:activity])
      incident.name            = sanitize(row[:name]) do |str|
        if str
          case str.downcase
          when 'female'
          when 'male'
          when 'woman'
          when 'man'
          when 'unidentified'
            nil
          else
            # Sometimes the name of a boat is reported ..
            if !str.downcase.include?('boat')
              # Eliminate a note in parenthesis tailing a name
              str.gsub(/\s*\(.*\)$/, '').titlecase
            else
              nil
            end
          end
        end
      end
      incident.sex             = sanitize(row[:sex]) do |str|
        str.downcase if str
      end
      incident.age             = sanitize(row[:age])
      incident.injury          = sanitize(row[:injury])
      incident.is_fatal        = incident.injury && incident.injury.downcase.include?('fatal')
      incident.is_provoked     = incident.injury && incident.injury.downcase.include?('provoked')
      incident.time_of_day     = sanitize(row[:time_of_day])
      incident.species         = sanitize(row[:species])
      incident.source          = sanitize(row[:source])
      incident
    end

    private

    DATE_ERRORS = {
      /-\s+([0-9]+)/              => '-\1', 
      /^(Ca.)?\s*[0-9]+\s*B\.C\./ => '', 
      /Jut/i                      => 'Jul'
    }.freeze

    def parse_date(str)
      # First of all, try to strip 'reported' from the beginning
      str = str.gsub(/^reported /i, '').strip

      # Fix some known GSAF spelling errors that we know the Ruby date parser 
      # handles improperly
      DATE_ERRORS.each do |search, replace|
        str = str.gsub(search, replace)
      end

      unless str.blank?
        Date.parse(str)
      else
        nil
      end
    end

    def sanitize(str)
      str = nil if str.blank?
      str = str.strip.force_encoding('utf-8') if str
      str = yield str if block_given?
      str
    end
  end
end
