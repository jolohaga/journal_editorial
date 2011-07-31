module UsersHelper
  def display_roles(user, options = {})
    if options[:assignable_only] == true
      if options[:exclude_count] == true
        user.roles.assignable.order('name').map{|r| r.name}.join(", ")
      else
        user.roles.assignable.order('name').map{|r| r.name + "(#{user.assignments.as(r.name).length})"}.join(", ")
      end
    else
      user.roles.order('name').map{|r| r.name}.join(", ")
    end
  end
  
  def display_assignments_for(user, options = {})
    role = options[:as] || Role::VISITOR
    user.responsibilities.active_under_review.includes(:assignments).where("assignments.role = '#{role}'").map{|a| link_to(a.slug_display, submission_path(a))}.join(", ").html_safe
  end
end