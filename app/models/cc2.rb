class CC2 < ActiveRecord::Base
  belongs_to :ancestor, :class_name => 'C2', :foreign_key => :ancestor_id
  belongs_to :descendant, :class_name => 'C2', :foreign_key => :descendant_id
end
