class IncidentsController < ApplicationController
  caches_page :index, :globe

  def index
    @incidents = Incident.limit(15)
    respond_to do |format|
      format.html
      format.json { render :json => @incidents }
    end
  end

  def globe
    # @todo: support HTML format as WebGL globe with no cruft?
    incidents = Incident.limit(500)
    flat = []
    incidents.each { |i| next unless i.lat ; flat << i.lat << i.lng << (i.is_fatal ? 0.7 : 0.1) }
    render :json => flat
  end
end
