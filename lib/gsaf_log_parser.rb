require 'csv'
require 'geokit'

#
# pacman -S catdoc
# xls2csv -c\| GSAF5.xls > GSAF5.csv
#

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
      yield incident if block_given?
      $stdout.puts "Parsed '#{incident.case_id}'"
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
        Date.parse(str.gsub(/^reported /i, '').strip)
      rescue
        nil
      end
    end
    incident.occurred_on_str = sanitize(row[:occurred_on])
    incident.country         = sanitize(row[:country]) do |str|
      str = str.titlecase if str && str != 'USA'
      str
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

  def sanitize(str)
    str = nil if str.blank?
    str = str.strip if str
    str = yield str if block_given?
    str
  end
end
