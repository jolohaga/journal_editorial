class ExpertiseController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource :user #:class => 'User'
  
  def index
    @associate = User.includes(:specializations).find(params[:editor_id])
    if allowed?
      @specializations = @associate.specializations.order('specializations.category, specializations.name')
      @available_specializations = {}
      Specialization.order('category,name').all.group_by(&:category).each_pair{|key,val| @available_specializations[key] = val.collect{|s| s.name unless @specializations.include?(s)}.reject {|s| s.blank?}}
    else
      redirect_to_personal_expertise_page
    end
  end
  
  def create
    @associate = User.includes(:specializations).find(params[:editor_id])
    if allowed?
      flash[:notice] = 'Expertise successfully added.'
      specialization = Specialization.find_by_name(params[:specialization][:name])
      @associate.specializations << specialization unless @associate.specializations.include? specialization
      respond_with @associate, :location => editor_expertise_index_path(@associate)
    else
      redirect_to_personal_expertise_page
    end
  end
  
  def destroy
    @associate = User.includes(:specializations).find(params[:editor_id])
    if allowed?
      flash[:notice] = 'Expertise successfully removed.'
      @associate.specializations.delete(Specialization.find(params[:id]))
      respond_with @associate, :location => editor_expertise_index_path(@associate)
    else
      redirect_to_personal_expertise_page
    end
  end
  
  def allowed?
    current_user.manager? || (current_user == @associate)
  end
  
  def redirect_to_personal_expertise_page
    flash[:notice] = "Editing access restricted to this list only!"
    redirect_to editor_expertise_index_path(current_user)
  end
end
