class WorkSignup < Signup

#validates :parent, :presence => true
validates :waiver, :acceptance => true

  def is_parent
    :parent == true
  end
end