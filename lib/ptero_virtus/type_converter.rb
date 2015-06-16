class PteroVirtus::TypeConverter

  def initialize(type, value)
    @type = type
    @value = value
  end

  def convert
    method_name = "convert_to_#{type.to_s.downcase}"
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

  private

  attr_reader :type
  attr_reader :value
end
