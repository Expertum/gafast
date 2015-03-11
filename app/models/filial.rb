class Filial < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string, :required
    contact_name :string, :required
    telephone    :string, :required
    notes        :text
    timestamps
  end
  attr_accessible :name, :contact_name, :telephone, :notes, :news

  has_many :workers, :class_name => "User", :dependent => :destroy
  has_many :prices, :dependent => :destroy
  has_many :news, :dependent => :destroy

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator? ||
    acting_user.farmaceft?
  end

  def update_permitted?
    acting_user.administrator? ||
    acting_user.farmaceft?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
