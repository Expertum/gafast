class Storage < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    morion :string
    codeg  :string
    name  :string
    madein :string
    nds :string
    cena :decimal, :precision => 12, :scale => 2, :default => 0.00
    srok :date
    count :decimal, :precision => 12, :scale => 2, :default => 0.00
    location_good enum_string(:stor, :defect, :check, :double)
    good_minus :decimal, :precision => 12, :scale => 2, :default => 0.00
#    date_check :date
#    date_deliver :date
    check :boolean, :default => false
#   deliver :boolean, :default => false
#    check_text :string
#    deliver_text :string
    pr_name :string
    timestamps
  end
  attr_accessible :morion, :codeg, :name, :madein, :nds, :cena, :srok, :filial, :filial_id, :count, :location_good, :price, :price_id,
                  :date_check, :date_deliver, :check, :deliver, :check_text, :deliver_text, :good_minus, :pr_name


  belongs_to :price
  belongs_to :filial

  def self.to_storage(id)
      storage = find_by_id(id)
      @ss = find_by_name(storage.name)
      if @ss && (@ss.id.to_i != id.to_i) && @ss.location_good == 'stor' then
         @ss.count = @ss.count.to_f + storage.count.to_f
         storage.location_good = 'double'
         @ss.save!
      else
         storage.location_good = 'stor'
      end
      storage.save!
  end

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
      return true if (acting_user.filial_id == self.filial_id)
    
    # права для колцентра
     if acting_user.farmaceft?
       return poster_is? acting_user || poster.nil?
       # колцентр может видеть только некоторые поля
       #return field.in?(basic_fields) if field
       # колцентр не должен видеть если ушло дальше дело
       #return state.in?(["ustnoe_uvedomlenie", "registracia", "go_sbor_documentov", "otkaz_go_sbor_documentov", "viplacheno", "zakritie_otkaz",
       # "otkaz_uvedomlenie", "otkaz_go_sbor_documentov", "otkaz_rassmotrenie_sb", "otkaz_rassmotrenie_ur", "otkaz_rassmotrenie_ex", "otkaz_vizir", "otkaz_vyplata"])
     end
    end
    # залогиненные видят все
    acting_user.signed_up?
  end

end
