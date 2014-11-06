class Interaction
  class ForbiddenAttribute < StandardError ; end
  include ActiveModel::Model

  @@allowed_attributes = []

  cattr_reader :allowed_attributes

  # Provides a attributes class method that adds the given symbols to the list
  # of allowed attributes and defines a getter method. For example:
  # attributes :title, :text
  def self.attributes(*attrs)
    attrs.each do |name|
      @@allowed_attributes << name.to_s
      attr_accessor name.to_sym
      define_method(name) { @attributes[name.to_s] }
      define_method("#{name}=") { |value| @attributes[name.to_s] = value }
    end
  end

  def initialize(params = {})
    @attributes = {}
    params.each do |name, value|
      if @@allowed_attributes.include?(name.to_s)
        @attributes[name.to_s] = value
      else
        raise ForbiddenAttribute, "#{name} is not an allowed attribute"
      end
    end if params
  end

  def save
    if valid?
      execute
      return true
    else
      return false
    end
  end

  def save!
    save or raise ActiveRecord::RecordInvalid.new(self)
  end
end
