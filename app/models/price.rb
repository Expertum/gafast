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

  has_many :goods, :dependent => :destroy, :accessible => true
  has_many :uploads, :as => :uploadable, :dependent => :destroy

  # --- Permissions --- #

  def create_permitted?
    acting_user.signed_up?
  end

  def update_permitted?
    acting_user.signed_up?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    return true if acting_user.administrator?
    if !self.filial.nil?
      return true if acting_user.filial_id == self.filial_id
    
    # права для колцентра
     #if acting_user.callcenter?
      # return poster_is? acting_user || poster.nil?
       # колцентр может видеть только некоторые поля
       #return field.in?(basic_fields) if field
       # колцентр не должен видеть если ушло дальше дело
       #return state.in?(["ustnoe_uvedomlenie", "registracia", "go_sbor_documentov", "otkaz_go_sbor_documentov", "viplacheno", "zakritie_otkaz",
       # "otkaz_uvedomlenie", "otkaz_go_sbor_documentov", "otkaz_rassmotrenie_sb", "otkaz_rassmotrenie_ur", "otkaz_rassmotrenie_ex", "otkaz_vizir", "otkaz_vyplata"])
     #end
    end
    # залогиненные видят все
    acting_user.signed_up?
  end

end
