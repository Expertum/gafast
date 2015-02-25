class Log < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    action  :string
    params  :text
    ht_key  :string
    message :string, :name => true
    timestamps
  end
  attr_accessible :action, :params, :message

  belongs_to :logable, :polymorphic => true, :touch => true
  belongs_to :user, :creator => true

  # --- Permissions --- #

  def create_permitted?
    acting_user.signed_up?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
