class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :thread_key
      t.integer :parent_id
      t.text :rank
      t.string :author
      t.text :body

      t.timestamps
    end
  end
end
