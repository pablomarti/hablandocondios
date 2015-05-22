class AddCreditsToDevotionals < ActiveRecord::Migration
  def change
    add_column :devotionals, :credits, :string, :default => ""
  end
end
