#encoding: utf-8
class Price < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    timestamps
  end
  attr_accessible :name

  belongs_to :poster, :class_name => "User", :creator => true

  belongs_to :filial

  has_many :comments, :dependent => :destroy, :order => 'created_at DESC'
  has_many :logs, :as => :logable, :dependent => :destroy, :order => 'created_at DESC'
  has_many :read_by_assignments, :dependent => :destroy, :class_name => "PricesRead"
  has_many :read_by, :through => :read_by_assignments, :dependent => :destroy, :source => :user, :class_name => "User"

  has_many :uploads, :as => :uploadable, :dependent => :destroy

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
