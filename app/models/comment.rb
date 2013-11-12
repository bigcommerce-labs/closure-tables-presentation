class Comment < ActiveRecord::Base
  has_one :parent, class_name: Comment
  has_many :children, class_name: Comment,
           :foreign_key => :parent_id, dependent: :destroy
  has_many :descendant_closures, :class_name => CommentClosure,
           :foreign_key => :descendant_id, dependent: :destroy
  has_many :ancestor_closures, :class_name => CommentClosure,
           :foreign_key => :ancestor_id, dependent: :destroy

  validates :thread_key, :body, presence: true

  after_create :propagate_closure_records

  class << self
    ##
    # Fetches the tree/subtree. Keeping this out of scopes to illustrate structure of query.
    #
    def fetch(parent = 0)
      Comment
        .joins(:descendant_closures)
        .select('comments.*,comment_closures.depth')
        .where('comment_closures.ancestor_id = ?',parent)
        .order(rank: :asc)
    end
  end

  protected

  ##
  # Creates the closure table records for this comment in O(N) time.
  #
  def propagate_closure_records
    # self closure
    cc = CommentClosure.new
    cc.ancestor_id = self.id
    cc.descendant_id = self.id
    cc.depth = 0
    unless cc.save
      self.destroy
      return false
    end

    heredity = CommentClosure.where('descendant_id = ? AND ancestor_id != ?',
                                    self.parent_id,0)
      .order(depth: :desc)

    # add root closure
    root_closure = CommentClosure.new
    root_closure.ancestor_id = 0
    root_closure.descendant_id = self.id
    root_closure.depth = heredity.count
    root_closure.save

    # add up the tree closures
    gps = []
    i = heredity.count
    heredity.each do |ancestor|
      gps << ancestor.ancestor_id.to_s.rjust(10,'0')

      obj = CommentClosure.new
      obj.ancestor_id = ancestor.ancestor_id
      obj.descendant_id = self.id
      obj.depth = i
      obj.save

      i -= 1
    end

    gps << id.to_s.rjust(10,'0')

    self.rank = gps.join('-')
    self.save
  end

end
