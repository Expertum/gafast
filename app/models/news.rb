class News < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title   :string, :required
    content :text
    timestamps
  end

  attr_accessible :title, :content

  has_many :comments, :dependent => :destroy, :order => 'created_at DESC'

  has_many :read_by_assignments, :dependent => :destroy, :class_name => "NewsRead"
  has_many :read_by, :through => :read_by_assignments, :dependent => :destroy, :source => :user, :class_name => "User"

  belongs_to :poster, :class_name => "User", :creator => true
  belongs_to :filial

  has_many :news_reads, :dependent => :destroy
  has_many :users, :through => :news_reads

  scope :not_read_by, lambda { |user| where("`news`.id NOT IN (SELECT `news_reads`.news_id FROM `news_reads` where `news_reads`.user_id = ? \
                     AND `news_reads`.updated_at > `news`.updated_at - 1)", user.id)}

  def read_by?(user=acting_user)
    @read_by = {} unless @read_by
    @read_by[user[:id]].nil? ? @read_by[user[:id]] = News.not_read_by(user).find_by_id(self.id).nil? : @read_by[user[:id]]
  end

  def mark_read_by(user=acting_user)
    self.read_by += [ user ] unless self.read_by_assignments.user_id_is(user[:id]).*.touch[0] == true
  end

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
