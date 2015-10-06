class Changestringtotextincheckmodel < ActiveRecord::Migration
  def self.up
    change_column :checks, :check_text, :text, :limit => nil
  end

  def self.down
    change_column :checks, :check_text, :string
  end
end
