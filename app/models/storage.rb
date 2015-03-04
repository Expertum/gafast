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
    location_good enum_string(:stor, :defect, :double)
    timestamps
  end
  attr_accessible :morion, :codeg, :name, :madein, :nds, :cena, :srok, :filial, :filial_id, :count, :location_good

  belongs_to :price
  belongs_to :filial

  def self.to_storage(id)
      storage = find_by_id(id)
      @ss = find_by_name(storage.name)
      if @ss then
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
