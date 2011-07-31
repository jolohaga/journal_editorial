class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new do |u|  # unprivileged user
      u.roles << Role.find_by_name(Role::UNPRIVILEGED)
    end
    can :index, :dashboard
    if user.administrator?
      can :manage, :all
    elsif user.manager?
      # Manager
      can :read, [Assignment,Comment,Correspondence,Document,Folder,FormLetter,Role,State,Submission,User]
      can :update, [Document,Folder,FormLetter,State,Submission,User]
      can [:upload,:download], [Folder]
      can :create, [Assignment,Document,Folder,State,Submission,User]
      can :destroy, [Assignment, Folder, Document]
      can [:activity,:revert_state,:search], Submission
      can :submit, FormLetter
      can :search, User
    elsif user.managing_editor?
      # Managing editor
      can :read, [Assignment,Comment,Document,Folder,FormLetter,State,Submission,User]
      can [:activity,:search], Submission
      can [:create,:destroy], Specialization
      can :search, User
      can :download, Folder
    elsif user.minimum_readonly?
      # Visitor
      can :read, [Document,Folder,Submission,User]
    elsif user.technical_editor?
      # Technical editor
    elsif user.associate_editor?
      # Associate editor
      can :read, [Comment,Document,Folder,Submission,User]
      can :search, Submission
      can [:create,:destroy], Specialization
      can :adopt, Submission
      can :search, User
      can :download, Folder
    elsif user.reviewer?
      # Reviewer
    elsif user.corresponding_author?
      # Corresponding author
    elsif user.assistant_editor?
      # Assistant editor
    elsif user.assistant?
      # Assistant
    else
      # Unprivileged user
    end
  end
end