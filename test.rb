module Adelaide; end

require 'adelaide.kpeg.rb'

pp = Adelaide::Parser.new(ARGF.read.chomp)
unless pp.parse
  pp.show_error(STDERR)
  pp.raise_error
end

script = Rubinius::AST::Script.new(pp.ast)

#Rubinius::AST::AsciiGrapher.new(script, Adelaide::Parser::AST::Node).print
Rubinius::AST::AsciiGrapher.new(script, Rubinius::AST::Node).print

