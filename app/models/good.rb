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
    timestamps
  end
  attr_accessible :morion, :codeg, :name, :madein, :nds, :cena, :srok, :price, :count, :price_id

  belongs_to :price

  def self.import(file,cena,poster,filid)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      good = find_by_id(row["id"]) || new
      good.attributes = row.to_hash.slice(*accessible_attributes)
      p = Price.find_or_create_by_name(cena)
      p.filial_id = filid
      p.poster = poster
      p.save!
      good.price = p
      good.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
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
