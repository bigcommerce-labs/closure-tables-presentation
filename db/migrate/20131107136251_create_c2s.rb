class CreateC2s < ActiveRecord::Migration
  def change
    create_table :cc2s do |t|
      t.integer :ancestor_id
      t.integer :descendant_id
      t.integer :depth

      t.timestamps
    end

    create_table :c2s do |t|
      t.string :thread_key
      t.integer :parent_id
      t.text :rank
      t.string :author
      t.text :body

      t.timestamps
    end
  end
end