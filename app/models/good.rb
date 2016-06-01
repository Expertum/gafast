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

  def self.imports(file,cena,poster,filid)
     inserts = []
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
