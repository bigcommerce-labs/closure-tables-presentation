class CreateCommentClosures < ActiveRecord::Migration
  def change
    create_table :comment_closures do |t|
      t.integer :ancestor_id
      t.integer :descendant_id
      t.integer :depth

      t.timestamps
    end
  end
end
