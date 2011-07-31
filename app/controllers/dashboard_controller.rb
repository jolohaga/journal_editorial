class DashboardController < ApplicationController
  respond_to :html, :xml
  authorize_resource :class => :dashboard
  
  def index
    @assignments = current_user.responsibilities.active_under_review
    @outstanding = Submission.includes(:states).non_terminal.order('states.recorded_at').recorded_before(Date.today-30).limit(20).sort {|x,y| x.current_state.recorded_at <=> y.current_state.recorded_at}
    @recent = Submission.non_terminal.order('cached_slug DESC').recorded_before(Date.today).limit(20).sort {|x,y| x.current_state.recorded_at <=> y.current_state.recorded_at}.reverse
    @awaiting_review = Submission.awaiting_review.includes(:states).sort {|x,y| x.current_state.recorded_at <=> y.current_state.recorded_at } #.order('states.recorded_at')
    @recent_activity = Observation.recents.order('created_at DESC').limit(30)
  end
end