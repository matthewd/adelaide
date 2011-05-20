module Adelaide; end

require 'adelaide.kpeg.rb'

ARGF.read.each do |fn|
  fn.chomp!
  puts fn
  pp = Adelaide::Parser.new(File.read(fn))
  unless pp.parse
    puts "Filename: #{fn}"
    pp.show_error(STDERR)
    pp.raise_error
    puts
  end
end

