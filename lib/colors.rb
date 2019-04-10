module Colors

  def self.rand_color
    "##{rand_part}#{rand_part}#{rand_part}"
  end

  def self.rand_part
    r = Random.rand(256)
    puts "rand_part:#{r}"
    r.to_s(16).rjust(2, '0')
  end
end
