module AssignmentsHelper
  
  def available_associates
    User.associates.order('LOWER(users.last_name), LOWER(users.first_name)').map {|u| [u.name, u.id]} - @submission.assignments.map {|a| [a.user.name, a.user.id]}
  end
end