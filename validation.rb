module Validation
  VALIDATION_TYPES = %i[presence format type].freeze

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    attr_reader :validations

    def validate(attribute, options)
      @validations ||= {}
      @validations[attribute] = options
    end
  end

  def validate!
    self.class.validations.each_pair do |attr, options|
      options.each_pair do |validation_type, value|
        unless VALIDATION_TYPES.include?(validation_type)
          raise ValidationError, "'#{validation_type}' validation type is unknown"
        end

        send("validate_#{validation_type}", attr, value)
      end
    end
    self
  end

  def valid?
    validate!
    true
  rescue ValidationError
    false
  end

  def validate_presence(attr, value)
    unless [true, false].include? value
      raise ValidationError, "'#{value}' is unknown value for `#{__method__}`"
    end

    attr_value = send(attr)
    present = !attr_value.nil? && attr_value != ''
    case value
    when true
      raise ValidationError, "Validation failed, `#{attr}` must be present" if present == false
    when false
      raise ValidationError, "Validation failed, `#{attr}` must be absent" if present == true
    end
  end

  def validate_format(attr, value)
    unless value.is_a?(Regexp)
      raise ValidationError, "'#{value}' has wrong format for `#{__method__}`. Expect Regexp"
    end

    attr_value = send(attr)
    unless attr_value.match?(value)
      raise ValidationError, "Validation failed, `#{attr}` must match Regexp: #{value.inspect}"
    end
  end

  def validate_type(attr, value)
    unless value.is_a?(Class)
      raise ValidationError, "'#{value}' is wrong value for `#{__method__}`. Expect Class name"
    end

    attr_value = send(attr)
    unless attr_value.is_a?(value)
      raise ValidationError, "Validation failed, `#{attr}` must be an instance of #{value}"
    end
  end

  class ValidationError < StandardError; end
end
