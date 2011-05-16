module Adelaide; end

require 'adelaide.kpeg.rb'

pp = Adelaide::Parser.new(ARGF.read.chomp)
unless pp.parse
  pp.show_error(STDERR)
  pp.raise_error
end

p pp.ast
Rubinius::AST::AsciiGrapher.new(pp.ast, Adelaide::Parser::AST::Node).print
#puts pp.ast.render

