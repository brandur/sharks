class IncidentsController < ApplicationController
  caches_page :by_gender, :index, :globe, :per_year

  def by_gender
    f_1y, m_1y     = calc_gender_ratio(1.year.ago)
    f_10y, m_10y   = calc_gender_ratio(10.years.ago)
    f_100y, m_100y = calc_gender_ratio(100.years.ago)
    render :json => {
      :a1y   => { :f => f_1y,   :m => m_1y }, 
      :a10y  => { :f => f_10y,  :m => m_10y }, 
      :a100y => { :f => f_100y, :m => m_100y }
    }
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

  def per_year
    incident_stats = Incident.
      where('occurred_on > ?', 10.years.ago).
      count_by('occurred_on', :group_by => 'year').
      map do |y|
        { :year => y.year, :count => y.count_all }
      end
    render :json => incident_stats
  end

  private

  def calc_gender_ratio(age_floor)
    incidents = Incident.where('occurred_on > ?', age_floor)
    num_male = incidents.where('sex = ?', 'm').count.to_f
    num_female = incidents.where('sex = ?', 'f').count.to_f
    total = num_male + num_female
    return num_female / total, num_male / total
  end
end
