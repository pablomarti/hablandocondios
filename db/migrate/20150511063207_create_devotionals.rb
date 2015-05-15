class CreateDevotionals < ActiveRecord::Migration
  def change
    create_table :devotionals do |t|
      t.string :title
      t.integer :day
      t.string :passage
      t.text :passage_text
      t.text :story
      t.text :questions
      t.string :passage_mem
      t.string :quote

      t.timestamps null: false
    end
  end
end
