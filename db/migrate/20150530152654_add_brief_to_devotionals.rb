class AddBriefToDevotionals < ActiveRecord::Migration
  def change
    add_column :devotionals, :brief, :text
  end
end
