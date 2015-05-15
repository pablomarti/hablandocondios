class AddImageToDevotionals < ActiveRecord::Migration
  def change
    add_column :devotionals, :image, :string, :default => ""
  end
end
