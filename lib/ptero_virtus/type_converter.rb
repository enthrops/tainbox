class PteroVirtus::TypeConverter

  def self.define_converter(type, block)
    method_name = conversion_method_name_for(type)
    raise "Converter for #{type} already exists" if instance_methods.include?(method_name)
    define_method(method_name, block)
  end

  def self.conversion_method_name_for(type)
    "convert_to_#{type.to_s.downcase}".to_sym
  end

  def initialize(type, value)
    @type = type
    @value = value
  end

  def convert
    method_name = self.class.conversion_method_name_for(type)
    raise "Type not supported: #{type}" unless respond_to?(method_name)
    send(method_name)
  end

  def convert_to_integer
    Integer(value) rescue nil
  end

  def convert_to_float
    Float(value) rescue nil
  end

  def convert_to_string
    value.to_s
  end

  def convert_to_symbol
    value.to_sym rescue nil
  end

  def convert_to_boolean
    !!value
  end

  private

  attr_reader :type
  attr_reader :value
end
