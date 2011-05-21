
class Object
  def to_sexp
    to_s
  end
end

module Adelaide::Parser::AST
  class Root
    def to_sexp
      [:script, [:block, *(@value.map {|v| v.to_sexp })]]
    end
  end

  class Statements
    def to_sexp(name=:block)
      [name, *(@value.map {|x| x.to_sexp })]
    end
  end

  class Body
    def to_sexp
      return [:scope] if @stmts.empty?
      [:scope, [:block, *(@stmts.map {|x| x.to_sexp })]]
    end
  end

  class Module
    def to_sexp
      n = ConstantAccess === @name ? @name.name.to_sym : @name.to_sexp
      [:module, n, @body.to_sexp]
    end
  end

  class Class
    def to_sexp
      n = ConstantAccess === @name ? @name.name.to_sym : @name.to_sexp
      [:class, n, @superclass ? @superclass.to_sexp : nil, @body.to_sexp]
    end
  end

  class HereDoc
    def to_sexp
      @value.to_sexp
    end
  end

  class DString
    def to_sexp
      if String === @parts.first
        first, *rest = @parts
        first = first.value
      else
        first = ""
      end
      rest = rest.map {|x| Statements === x ? x.to_sexp(:evstr) : x.to_sexp }
      [:dstr, first, *rest]
    end
  end

  class Return
    def to_sexp
      [:return, *@value.map {|x| x.to_sexp }]
    end
  end

  class Alias
    def to_sexp
      [:alias, [:lit, @to.to_sym], [:lit, @from.to_sym]]
    end
  end

  class VAlias
    def to_sexp
      [:alias, @to.to_sym, @from.to_sym]
    end
  end

  class Undef
    def to_sexp
      [:undef, [:lit, @name.to_sym]]
    end
  end

  class Self
    def to_sexp
      [:self]
    end
  end

  class Splat
    def to_sexp
      [:splat, @value.to_sexp]
    end
  end

  class ToplevelConstant
    def to_sexp
      [:colon3, @name.to_sym]
    end
  end

  class ScopedConstant
    def to_sexp
      [:colon2, @parent.to_sexp, @name.to_sym]
    end
  end

  class ConstantAccess
    def to_sexp
      [:const, @name.to_sym]
    end
  end

  class Method
    def to_sexp
      args = [:args]
      arg_values = [:block]
      @args.each do |arg|
        case arg[0]
        when :req
          args << arg[1].to_sym
        when :opt
          args << arg[1].to_sym
          arg_values << [:lasgn, arg[1].to_sym, arg[2].to_sexp]
        when :rest
          args << :"*#{arg[1]}"
        when :block
          args << :"&#{arg[1]}"
        end
      end
      args << arg_values if arg_values.size > 1
      [:defn, @name.to_sym, args, @body.to_sexp]
    end
  end

  class Unless
    def to_sexp
      [:if, @cond.to_sexp, @false_value ? @false_value.to_sexp : [:nil], [:block, *(@true_value.map {|x| x.to_sexp })]]
    end
  end

  class VariableAccess
    def var_type
      case @name
      when /^@@/
        :cvar
      when /^@/
        :ivar
      when /^\$[1-9][0-9]*$/
        :nth_ref
      when /^\$[~&`'+]$/
        :back_ref
      when /^\$/
        :gvar
      else
        :lvar
      end
    end
    def to_sexp
      [var_type, @name.to_sym]
    end
  end

  class LocalSend
    def to_sexp
      a = [:arglist]
      a += @args.map {|a| a.to_sexp } if @args
      a << @block.to_sexp if @block
      [:call, nil, @name.to_sym, a]
    end
  end

  class ObjSend
    def to_sexp
      a = [:arglist]
      a += @args.map {|a| a.to_sexp } if @args
      a << @block.to_sexp if @block
      [:call, @target.to_sexp, @name.to_sym, a]
    end
  end

  class String
    def to_sexp
      [:str, @value]
    end
  end

  class Assign
    def to_sexp
      if Array === @lhs
        if Array === @rhs
          # foo, bar = baz, quux
        else
          # foo, bar = baz
        end
      else
        if Array === @rhs
          # foo = bar, baz
        else
          # foo = bar
          case @lhs
          when VariableAccess
            [:lasgn, @lhs.name.to_sym, @rhs.to_sexp]
          end
        end
      end
    end
  end

  class Float
    def to_sexp
      [:lit, @value]
    end
  end

  class Int
    def to_sexp
      [:lit, @value]
    end
  end

  class OpAssign0
    def to_sexp
      if ConstantAccess === @target
        [:cdecl, @target.name.to_sym, [:call, @target.to_sexp, @op.to_sym, [:arglist, @value.to_sexp]]]
      else
        [:lasgn, @target.name.to_sym, [:call, @target.to_sexp, @op.to_sym, [:arglist, @value.to_sexp]]]
      end
    end
  end

  class Super
    def to_sexp
      if @args.nil?
        [:zsuper]
      else
        a = [:super]
        a += @args.map {|a| a.to_sexp } if @args
        a << @block.to_sexp if @block
        a
      end
    end
  end

  class And
    def to_sexp
      [:and, @left.to_sexp, @right.to_sexp]
    end
  end

  class Or
    def to_sexp
      [:or, @left.to_sexp, @right.to_sexp]
    end
  end

  class Not
    def to_sexp
      [:not, @value.to_sexp]
    end
  end

  class BinOp
    def to_sexp
      [:call, @left.to_sexp, @op, [:arglist, @right.to_sexp]]
    end
  end
end
