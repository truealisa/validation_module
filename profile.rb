require_relative 'validation'

class Profile
  include Validation

  validate :owner, type: User

  attr_accessor :owner

  def initialize(owner)
    @owner = owner
  end
end
