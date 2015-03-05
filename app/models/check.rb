class Check < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    check_text :string
    deliver_text :string
    timestamps
  end
  attr_accessible :check_text, :deliver_text
 
  belongs_to :poster, :class_name => "User", :creator => true
  
  belongs_to :filial

  has_many :storages

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
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
