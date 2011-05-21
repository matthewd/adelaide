
class A
  def x(a)
    return "foo!"
  end
  def z(a,b=c,*d,&e)
    return "bar!"
  end
end

class B
  def x(a=b)
    o = 7
    return "foo!"
  end
  def z(a,b=c,*d)
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



