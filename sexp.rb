module Adelaide; end

require './adelaide.kpeg.rb'
require './ast'

pr = Adelaide::Parser.new(ARGF.read.chomp)
unless pr.parse
  pr.show_error(STDERR)
  pr.raise_error
end

require 'pp'
puts pr.ast.to_sexp.pretty_inspect

