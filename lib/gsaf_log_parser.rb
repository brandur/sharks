require 'csv'
require 'iconv'
require 'lightcsv'

#
# pacman -S catdoc
# xls2csv -c\| GSAF5.xls > GSAF5.csv
#

class GsafLogParser
  def parse(file)
    CSV.foreach(file, col_sep: '|') do |row|
      parse_row({
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
    # @todo: geo lookup
    incident.lat = nil
    incident.lng = nil
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
