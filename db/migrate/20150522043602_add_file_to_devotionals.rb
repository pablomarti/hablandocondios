class AddFileToDevotionals < ActiveRecord::Migration
  def change
    add_column :devotionals, :file, :string, :default => ""
  end
end
