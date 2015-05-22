class Devotional < ActiveRecord::Base

  mount_uploader :image, DevotionalImageUploader
  mount_uploader :file, FileUploader
  
end
