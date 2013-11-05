class C2 < ActiveRecord::Base
  has_one :parent, class_name: C2
  has_many :children, class_name: C2, :foreign_key => :parent_id, dependent: :destroy
  has_many :descendant_closures, :class_name => CC2, :foreign_key => :descendant_id, dependent: :destroy
  has_many :ancestor_closures, :class_name => CC2, :foreign_key => :ancestor_id, dependent: :destroy

  validates :thread_key, :body, presence: true

  after_create :propagate_closure_records

  class << self
    def fetch(parent = 0)
      C2
        .joins(:descendant_closures)
        .select('c2s.*,cc2s.depth')
        .where('cc2s.ancestor_id = ?',parent)
        .order(rank: :asc)
    end
  end

  protected

  ##
  # Creates the closure table records for this comment in O(N) time.
  #
  def propagate_closure_records
    # self closure
    cc = CC2.new
    cc.ancestor_id = self.id
    cc.descendant_id = self.id
    cc.depth = 0
    unless cc.save
      self.destroy
      return false
    end

    heredity = CC2.where('descendant_id = ? AND ancestor_id != ?',self.parent_id,0).order(depth: :desc)

    # add root closure
    root_closure = CC2.new
    root_closure.ancestor_id = 0
    root_closure.descendant_id = self.id
    root_closure.depth = heredity.count
    root_closure.save

    # add up the tree closures
    gps = []
    i = heredity.count
    heredity.each do |ancestor|
      gps << ancestor.ancestor_id.to_s.rjust(10,'0')

      obj = CC2.new
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
