class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all, :except => [ :new, :create ]

  # Normally, users should be created via the user lifecycle, except
  #  for the initial user created via the form on the front screen on
  #  first run.  This method creates the initial user.

  def index
    @users = User.
      search(params[:search], :id, :name, :email_address).
      order_by(parse_sort_param(:name, :email_address, :role))
  end

  def create
    hobo_create do
      if valid?
        self.current_user = this
        flash[:notice] = t("hobo.messages.you_are_site_admin", :default=>"You are now the site administrator")
        redirect_to home_page
      end
    end
  end

  def do_accept_invitation
    do_transition_action :accept_invitation do
      if this.valid?
        self.current_user = this
        flash[:notice] = t("hobo.messages.you_signed_up", :default=>"You have signed up")
      end
    end
  end

end
