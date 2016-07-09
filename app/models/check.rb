class Check < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    check_text :text
    deliver :boolean, :default => false
#    deliver_text :string
    timestamps
  end
  attr_accessible :check_text, :filial_id, :filial, :deliver
 
  belongs_to :poster, :class_name => "User", :creator => true
  
  belongs_to :filial

  has_many :storages

  validate :cena_is_not_nil

  private
    def cena_is_not_nil
    @dd = [] 
    @cht = self.check_text.split('||')
    @cht.each{|x| @dd << x.split(';')}
    @dd.each do |name, count, cena|
      if cena.to_i == 0 
        errors.add(:check, '!!! У чеці прісутня нульова ціна !!! - ' + name.to_s)
        break
      end
    end
  end

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
