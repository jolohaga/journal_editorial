module AssociatesHelper
  def associates_create_path
    @submission.nil? ? associates_path : submission_associates_path(@submission)
  end
end