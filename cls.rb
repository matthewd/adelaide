
class A
  def x
    return "foo!"
  end
  def z
    return "bar!"
  end
end

class B
  def x
    o = 7
    return "foo!"
  end
  def z
    return "bar!"
  end
end

def zz
  puts '!!!'
end

puts 'mmm'

a += A.a 7, 2,
  4
5



