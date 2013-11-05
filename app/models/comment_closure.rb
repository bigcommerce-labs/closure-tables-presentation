class CommentClosure < ActiveRecord::Base
  belongs_to :ancestor, :class_name => 'Comment', :foreign_key => :ancestor_id
  belongs_to :descendant, :class_name => 'Comment', :foreign_key => :descendant_id
end
