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
    count :decimal, :precision => 12, :scale => 3, :default => 0.000
    location_good enum_string(:stor, :defect, :check, :double)
    good_minus :decimal, :precision => 12, :scale => 3, :default => 0.000
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
  belongs_to :poster, :class_name => "User", :creator => true

  def self.to_storage(id)
      storage = find_by_id(id)
      @ss = find_by_name(storage.name)
      if @ss && (@ss.id.to_i != id.to_i) && @ss.location_good == 'stor' then
         @ss.count = @ss.count.to_f + storage.count.to_f
         @ss.save!
      else
         storage.location_good = 'stor'
         storage.save!
      end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |storage|
        csv << storage.attributes.values_at(*column_names)
      end
    end
  end

  def w_cena?
    @md = self.madein
    @nm = self.name
    @s_price = Price.find_by_name(self.pr_name).id
    @cg = Good.where(:name => @nm, :price_id => @s_price, :madein => @md).first._?.cena.to_f
    @cs = self.cena.to_f
    @nds = (self.nds.to_f/100)+1
    @c_d_b =  (@cs/@nds)/1.35
     if (@cg.round(2) != @c_d_b.round(2)) && (@cg.round(2) != 0) then
        @@res = ((@cg*@nds)*1.35).round(2)
       return true, @@res
     else
       return false
     end
  end

  def w_codeg?
    @md = self.madein
    @nm = self.name
    @s_price = Price.find_by_name(self.pr_name).id
    @g_codeg = Good.where(:name => @nm, :price_id => @s_price, :madein => @md).first._?.codeg.to_s
    @s_codeg = self.codeg.to_s
    if @s_codeg != @g_codeg then
        @@res = @g_codeg
       return true, @@res
     else
       return false
     end
  end

  def self.pernac
    Storage.all.each{|x| if x.w_cena?
                            x.cena = x.w_cena?[1]
                            x.save!
                         end}
  end

  def num_plus
      
  end

  def summ_good
      
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
    #if !self.filial.nil?
    #  return true if (acting_user.filial_id == self.filial_id)
    #end
    # залогиненные видят все
    acting_user.signed_up?
  end

end
