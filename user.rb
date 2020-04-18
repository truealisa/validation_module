require_relative 'validation'

class User
  include Validation

  validate :name, presence: true, format: /\w{3,24}/
  validate :phone_number, format: /\d{10}/

  attr_accessor :name, :phone_number

  def initialize(name, phone_number)
    @name = name
    @phone_number = phone_number
  end
end
