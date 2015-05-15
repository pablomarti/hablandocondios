class Devotional < ActiveRecord::Base

  mount_uploader :image, DevotionalImageUploader
  
end
