module AppUtils

  def self.collapse(value)
    if value.is_a?(Array)
      value = value.inject([]) do |a,v|
        v = collapse(v)
        a << v if keep?(v)
        a
      end
    elsif value.is_a?(Hash)
      collapsed = {}
      value.each do |k,v|
        v = collapse(v)
        collapsed[k] = v if keep?(v)
      end
      value = collapsed
    end
    keep?(value) ? value : nil
  end

  def self.keep?(value)
    value.present? || (value == false)
  end
end
