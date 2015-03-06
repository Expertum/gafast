class Removedeliverfromcheck < ActiveRecord::Migration
  def self.up
    remove_column :checks, :deliver_text
  end

  def self.down
    add_column :checks, :deliver_text, :string
  end
end
