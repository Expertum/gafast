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
    to_order :boolean, :default => false
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
                  :date_check, :date_deliver, :check, :deliver, :check_text, :deliver_text, :good_minus, :pr_name, :to_order, :poster_id


  belongs_to :price
  belongs_to :filial
  belongs_to :poster, :class_name => "User", :creator => true

  def self.to_storage(id)
      storage = find_by_id(id)
      #@ss = find_by_name(storage.name)
      @ss = Storage.where(:name => storage.name, :filial_id => storage.filial_id, :madein => storage.madein).first
      if @ss && (@ss.id.to_i != id.to_i) && @ss.location_good == 'stor' then
         @ss.count = @ss.count.to_f + storage.count.to_f
         storage.location_good = 'double'
         @ss.save!
      else
         storage.location_good = 'stor'
      end
      storage.to_order = 'false'
      storage.save!
  end

  def self.to_del(id)
      storage = find_by_id(id)
      storage.to_order = 'false'
      storage.location_good = 'double'
      storage.save!
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
  unless self.filial.name.nil? 
    unless Price.find_by_name(self.pr_name).nil?
    if (self.location_good == 'stor' || self.location_good == 'defect') then
      @nac = (self.filial.nacenka.to_f/100)+1
      @md = self.madein
      @nm = self.name
      @s_price = Price.find_by_name(self.pr_name).try(:id)
      @cg = Good.where(:name => @nm, :price_id => @s_price, :madein => @md).first._?.cena.to_f
      @cs = self.cena.to_f
      @nds = (self.nds.to_f/100)+1
      @c_d_b =  (@cs/@nds)/@nac
        if (@cg.round(2) != @c_d_b.round(2)) && (@cg.round(2) != 0) then
           @@res = ((@cg*@nds)*@nac).round(2)
          return true, @@res
        else
          return false
        end
    end
  end
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

  def self.pernac(id)
    @p_goods={}
    @prom ={}
    #Storage.all.each{|x| if x.w_cena?
                            #x.cena = x.w_cena?[1]
                            #x.save!
     #                       @p_goods.merge!(x.id => {'cena' => x.w_cena?[1]})
     #                    end}
#    puts @p_goods
#    sleep 2.5
    #Storage.update(@p_goods.keys, @p_goods.values)
    # новая концепція
    x = Storage.find_by_id(id.to_i)
    if x.w_cena?
       x.cena = x.w_cena?[1]
       x.save!
    end
  end

  def find_good?(good,price)
    pr_id = Price.find_by_name(price)._?.id
    if Good.where(:name => good, :price_id => pr_id).size != 0 && pr_id != nil
      return true
    else
      return false
    end
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
