class Upload < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include Rails.application.routes.url_helpers

  fields do
    timestamps
  end
  attr_accessible :upload, :uploadable, :uploadable_id, :uploadable_type

  has_attached_file :upload,
    :styles => {
      :original => ["1500x1500>"],
      :thumb => ["120x120#","jpg"]},
    :convert_options => {
      :original => '',
      :thumb => ''
    }

    #validates_attachment_content_type :upload, :content_type => %w(image/jpeg image/jpg image/png)
    #do_not_validate_attachment_file_type :upload

  before_post_process { |this|
    logger.debug "DEBUG: upload.content_type: " + this.upload.content_type
    logger.debug "DEBUG: upload.original_filename: " + this.upload.original_filename
    if not this.upload.content_type.index('image/') == nil
      true
    elsif this.upload.content_type.in?(%w(application/octet-stream application/pdf)) && this.upload.original_filename =~ /\.[pP][dD][fF]$/
      this.upload.styles.delete(:original) #нам не надо конвертировать оригинальный pdf файл
      true # включаю генерацию предпросмотра для pdf
    elsif this.upload.original_filename =~ /\.[mM][pP][4]$/
      this.upload.styles.delete(:original)
      true
    else
      false
    end
  }

  belongs_to :uploadable, :polymorphic => true, :touch => true
  belongs_to :poster, :class_name => "User", :creator => true

  def is_image?
    return false unless upload_content_type
    @is_image ||= ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg'].include?(upload_content_type)
  end

  def is_video?
    return false unless upload_content_type
    @is_video ||= (%w(video/mp4)).include?(upload_content_type)
  end

  def to_jq_upload(user)
    {
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "thumbnail_url" => url_thumb,
      "delete_url" => upload_path(self),
      "delete_type" => "DELETE",
      "can_delete" => destroyable_by?(user),
      "is_image" => is_image?
    }
  end

  def icon_url(ext='doc')
    '/icons/filetypes/filetype-'+ext.to_s+'-icon.png'
  end

  def filetype_icon_url
    @filetype_icon_url ||= icon_url(upload_file_ext)
  end

  def upload_file_ext
    @upload_file_ext ||= upload_file_name.to_s.split('.').last
  end

  def url_thumb
    if File.exists?(upload.path(:thumb).to_s)
      upload.url(:thumb)
    elsif File.exists?(Rails.public_path + filetype_icon_url)
      filetype_icon_url
    else
      icon_url('any')
    end
  end

  def recent?
    created_at ? created_at > Time.now - 2.days : false
  end
  # --- Permissions --- #

  def create_permitted?
    return true if acting_user.administrator?
    acting_user.signed_up?
  end

  def update_permitted?
    return true if acting_user.administrator?
    return true if acting_user.farmaceft? && recent?
    poster_is?(acting_user) && recent?
  end

  def destroy_permitted?
    return true if acting_user.administrator?
    return true if acting_user.farmaceft? && recent?
    poster_is?(acting_user) && recent?
  end

  def view_permitted?(field)
    return true if acting_user.administrator?
    true
  end

  scope :viewable_by, ->(user) {
    if user.administrator?
      {}
    else
      {} # all
    end
  }

end
