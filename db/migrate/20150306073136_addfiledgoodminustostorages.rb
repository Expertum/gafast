class Addfiledgoodminustostorages < ActiveRecord::Migration
  def self.up
    add_column :storages, :good_minus, :decimal, :precision => 12, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :storages, :good_minus
  end
end
