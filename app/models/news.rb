class News < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title   :string, :required
    content :text
    timestamps
  end

  attr_accessible :title, :content

  has_many :comments, :dependent => :destroy, :order => 'created_at DESC'

  belongs_to :poster, :class_name => "User", :creator => true
  belongs_to :filial

  has_many :news_reads, :dependent => :destroy
  has_many :users, :through => :news_reads

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    true
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
