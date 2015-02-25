class Firstfuckingmigration < ActiveRecord::Migration
  def self.up
    create_table :filials do |t|
      t.string   :name
      t.string   :contact_name
      t.string   :telephone
      t.text     :notes
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :comments do |t|
      t.string   :content
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :logs do |t|
      t.string   :action
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :news do |t|
      t.string   :title
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :news_reads do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :oblasts do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :prices do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :poster_id
      t.integer  :filial_id
    end
    add_index :prices, [:poster_id]
    add_index :prices, [:filial_id]

    create_table :prices_reads do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :uploads do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :users, :phone_number, :string
    add_column :users, :role, :string
    add_column :users, :receive_messages, :boolean, :default => true
    add_column :users, :position, :string
    add_column :users, :last_active_at, :datetime
    add_column :users, :filial_id, :integer
    change_column :users, :state, :string, :limit => 255, :default => "invited"

    add_index :users, [:filial_id]
  end

  def self.down
    remove_column :users, :phone_number
    remove_column :users, :role
    remove_column :users, :receive_messages
    remove_column :users, :position
    remove_column :users, :last_active_at
    remove_column :users, :filial_id
    change_column :users, :state, :string, :default => "active"

    drop_table :filials
    drop_table :comments
    drop_table :logs
    drop_table :news
    drop_table :news_reads
    drop_table :oblasts
    drop_table :prices
    drop_table :prices_reads
    drop_table :uploads

    remove_index :users, :name => :index_users_on_filial_id rescue ActiveRecord::StatementInvalid
  end
end
