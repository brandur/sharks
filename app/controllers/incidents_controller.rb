class IncidentsController < ApplicationController
  caches_page :by_age_group, :by_fatality, :by_country, :by_gender, :index, :globe, :per_year

  def by_age_group
    current_incidents = Incident.where('occurred_on > ?', 10.years.ago).where('age IS NOT NULL')
    render :json => { 
      '0-17'  => current_incidents.where('age <= ?', 17).count, 
      '18-29' => current_incidents.where('age >= ? AND age <= ?', 18, 29).count, 
      '30-44' => current_incidents.where('age >= ? AND age <= ?', 30, 44).count, 
      '45-59' => current_incidents.where('age >= ? AND age <= ?', 45, 59).count, 
      '60+'   => current_incidents.where('age >= ?', 60).count, 
    }
  end

  def by_country
    # todo: cross-plaform dates? (`STRFTIME` will fail on non-SQLite DBs)
    incident_groups = ActiveRecord::Base.connection.select_all(<<eos)
SELECT occurred_on_year AS year, country, count_all AS count
FROM (
  SELECT STRFTIME('%Y', occurred_on) AS occurred_on_year, country, COUNT(*) AS count_all 
  FROM incidents 
  WHERE occurred_on > '#{Date.today.year - 10}-01-01'
  GROUP BY STRFTIME('%Y', occurred_on), country
)
ORDER BY year DESC, count_all DESC
eos
    render :json => incident_groups.group_by{ |g| g['year'] }
  end

  def by_fatality
    current_incidents = Incident.where('occurred_on > ?', 10.years.ago)
    render :json => {
      :fatal => count_fatal = current_incidents.where('is_fatal = ?', true).count, 
      :total => count_total = current_incidents.count, 
    }
  end

  def by_gender
    current_incidents = Incident.where('occurred_on > ?', 10.years.ago)
    render :json => {
      :male   => current_incidents.where('sex = ?', 'm').count, 
      :female => current_incidents.where('sex = ?', 'f').count, 
    }
  end

  def by_year
    incident_stats = Incident.
      where('occurred_on > ?', 10.years.ago).
      count_by('occurred_on', :group_by => 'year').
      map do |y|
        { :year => y.year, :count => y.count_all }
      end.
      reverse
    render :json => incident_stats
  end

  def globe
    # @todo: support HTML format as WebGL globe with no cruft?
    incidents = Incident.limit(500)
    flat = []
    incidents.each do |i|
      next unless i.lat
      flat << i.lat << i.lng << (i.is_fatal ? 0.7 : 0.1)
    end
    render :json => flat
  end

  def index
    @incidents = Incident.limit(15)
    respond_to do |format|
      format.html
      format.json { render :json => @incidents }
    end
  end
end
