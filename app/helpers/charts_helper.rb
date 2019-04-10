module ChartsHelper

  def project(value, cx=50, cy=50, radius=25)
    return [project_x(value, cx, radius), project_y(value, cy, radius)]
  end

  def radians(value)
    value * 2 * Math::PI #- (Math::PI / 2)
  end

  def project_x(value, cx, radius)
    Math.cos(radians(value)) * radius + cx
  end

  def project_y(value, cy, radius)
    Math.sin(radians(value)) * radius + cy
  end
end
