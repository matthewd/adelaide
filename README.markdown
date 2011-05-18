
Run:

    # If you don't already have it
    rbx gem install kpeg

    rbx -S kpeg -f adelaide.kpeg &&
      rbx -rubygems ./test.rb test.rb


`test.rb` looks like this:

    module Adelaide; end
    
    require 'adelaide.kpeg.rb'
    
    pp = Adelaide::Parser.new(ARGF.read.chomp)
    unless pp.parse
      pp.show_error(STDERR)
      pp.raise_error
    end
    
    Rubinius::AST::AsciiGrapher.new(pp.ast, Adelaide::Parser::AST::Node).print


That will output the following AST:

    Root
      @value: \
        Module
          @name: \
          ConstantAccess
            @name: "Adelaide"
          @body: \
          Body
            @stmts: \
            @rescue_: \
            @else_: nil
            @ensure_: nil
        LocalSend
          @name: "require"
          @args: \
            String
              @value: "adelaide.kpeg.rb"
          @block: nil
        Assign
          @lhs: \
          VariableAccess
            @name: "pp"
          @rhs: \
          ObjSend
            @name: "new"
            @args: \
              ObjSend
                @name: "chomp"
                @args: \
                @block: nil
                @target: \
                ObjSend
                  @name: "read"
                  @args: \
                  @block: nil
                  @target: \
                  ConstantAccess
                    @name: "ARGF"
            @block: nil
            @target: \
            ScopedConstant
              @name: "Parser"
              @parent: \
              ConstantAccess
                @name: "Adelaide"
        Unless
          @true_value: \
            ObjSend
              @name: "show_error"
              @args: \
                ConstantAccess
                  @name: "STDERR"
              @block: nil
              @target: \
              VariableAccess
                @name: "pp"
            ObjSend
              @name: "raise_error"
              @args: \
              @block: nil
              @target: \
              VariableAccess
                @name: "pp"
          @false_value: nil
          @cond: \
          ObjSend
            @name: "parse"
            @args: \
            @block: nil
            @target: \
            VariableAccess
              @name: "pp"
        ObjSend
          @name: "print"
          @args: \
          @block: nil
          @target: \
          ObjSend
            @name: "new"
            @args: \
              ObjSend
                @name: "ast"
                @args: \
                @block: nil
                @target: \
                VariableAccess
                  @name: "pp"
              ScopedConstant
                @name: "Node"
                @parent: \
                ScopedConstant
                  @name: "AST"
                  @parent: \
                  ScopedConstant
                    @name: "Parser"
                    @parent: \
                    ConstantAccess
                      @name: "Adelaide"
            @block: nil
            @target: \
            ScopedConstant
              @name: "AsciiGrapher"
              @parent: \
              ScopedConstant
                @name: "AST"
                @parent: \
                ConstantAccess
                  @name: "Rubinius"

