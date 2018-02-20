class Good < ActiveRecord::Base

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
    nacenka :decimal, :precision => 12, :scale => 2, :default => 35
    to_order :boolean, :default => false
    timestamps
  end
  attr_accessible :morion, :codeg, :name, :madein, :nds, :cena, :srok, :price, :count, :price_id, :nacenka, :to_order

  belongs_to :price
  belongs_to :poster, :class_name => "User", :creator => true

  def self.imports(file,cena,poster,filid,nakladna,nds)
     inserts = []
    if nakladna == 'true' then
      #puts "NAKLADNA//////////////////////////////////////"
      if cena == 'Оптима'
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]

          strg = row.to_hash
           p = Price.find_by_name('Оптима')
           nacenka = Filial.find_by_id(filid).nacenka.to_f
           
           count_str = strg['Quantity'].to_f
           name_str  = strg['GoodsName'].to_s
           
           morion    = strg['BarCode'].to_s 
           codeg     = strg['GoodsID'].to_s
           madein    = strg['ProducerName'].to_s
           nds       = nds
           cena      = ((strg['SellPrice'].to_f*(nacenka.to_f/100+1))*(nds.to_f/100+1)).round(2)
           srok      = strg['BestBefore'].to_date.strftime("%d.%m.%Y")
           
           storag_ad = Storage.where(:name => name_str, :filial_id => filid, :pr_name => p.name)[0]
           
           if storag_ad.nil? then
             storag_ad = Storage.new(:morion =>morion, :codeg => codeg, :name => name_str, :madein => madein, :nds =>nds, :cena =>cena, :srok =>srok, 
                                     :price_id => p.id, :filial_id => filid, :pr_name => 'Оптима', :poster_id => User.find_by_name(poster).id)
           else
             storag_ad.morion = morion
             storag_ad.cena = cena
           end  
             storag_ad.location_good = 'stor'
             storag_ad.price_id = p.id
             storag_ad.srok = srok
             storag_ad.count += count_str
             storag_ad.save!
           
          #puts '***************************'
          #puts strg
          #puts '***************************'
        end
      end # Optima end
      if cena == 'ЛАКС'
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]

          strg = row.to_hash
           p = Price.find_by_name('ЛАКС')
           nacenka = Filial.find_by_id(filid).nacenka.to_f
           
           count_str = strg['Количество'].to_f
           name_str  = strg['Наименование товара'].to_s
           
           morion    = strg['Код Морион'].to_s 
           codeg     = strg['Код Морион'].to_s
           madein    = strg['Производитель'].to_s
           nds       = nds
           cena      = ((strg['Цена'].to_f*(nacenka.to_f/100+1))*(nds.to_f/100+1)).round(2)
           srok      = strg['Срок годн.']._?.to_date.strftime("%d.%m.%Y")
           
           storag_ad = Storage.where(:name => name_str, :filial_id => filid, :pr_name => p.name)[0]
           
           if storag_ad.nil? then
             storag_ad = Storage.new(:morion =>morion, :codeg => codeg, :name => name_str, :madein => madein, :nds =>nds, :cena =>cena, :srok =>srok, 
                                     :price_id => p.id, :filial_id => filid, :pr_name => 'ЛАКС', :poster_id => User.find_by_name(poster).id)
           else
             storag_ad.morion = morion
             storag_ad.cena = cena
           end  
             storag_ad.location_good = 'stor'
             storag_ad.price_id = p.id
             storag_ad.srok = srok
             storag_ad.count += count_str
             storag_ad.save!        
         end        
      end   # LAKS end
    else
      #puts "PRICE ****************************************"
#--- Add Price
      p = Price.find_or_create_by_name(cena)
      p.filial_id = filid
      p.poster = poster
      p.save!
#---
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      good = find_by_id(row["id"]) || new
      good.attributes = row.to_hash.slice(*accessible_attributes)
      d = good.nds.to_s
      if d.split('-').count == 2 then good.nds = d.split('-')[1].to_f end
      if d.split('-').count == 1 then good.nds = d.split('-')[0].to_f end

      good.price = p
      inserts.push good #good.save!
    end
     Good.import inserts
    end # nakladna end
  end

  def self.open_spreadsheet(file)
    File.rename(file.path,file.path.to_s+'.xls')
    case File.extname(file.original_filename)
    when ".csv"  then Csv.new(file.path, nil, :ignore)
    when ".xls"  then Roo::Excel.new(file.path.to_s+'.xls')
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
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
    return false if acting_user.guest?
    # залогиненные видят все
    acting_user.signed_up?
  end

end
