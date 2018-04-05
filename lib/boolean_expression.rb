module BooleanExpression
  class ParsingError < StandardError; end
  class MissingLeadingParenthesis < ParsingError; end
  class MissingTrailingParenthesis < ParsingError; end
  class InvalidKey < ParsingError; end
  class Formatting < ParsingError; end

  class EvaluationError < StandardError; end
  class MissingKeys < EvaluationError; end

# Case insensitive keys
class Parser
  attr :expression

  def initialize(expression)
    @expression = expression.to_s.downcase
    validate_expression
  end

  def validate_expression(permitted_keys)
    validate_balanced_parens(@expression)
    validate_expression_with_context(permitted_keys.map{|t| [t, true]}.to_h)
  end

  def validate_keys(context = {})
    keys = context.keys.map{|k| k.to_s.downcase}.join '|'
    regex = %r/^(?:\s*|#{keys}|[)(]|and|or|not)+$/i
    raise(InvalidKey, "Unpermitted keys used in boolean expression: <#{@expression}>") unless @expression =~ regex
  end

  # context in form of a hash
  def evaluate(context = {})
    context = Hash[context.map{|k,v| [k.downcase,v]}]
    validate_expression_with_context(context)

    kls = Class.new
    context.each do |key,value|
      kls.instance_eval { class << self; self end }.send(:attr_accessor, key)
      kls.send("#{key}=", value)
    end
    kls.instance_eval(@expression)
  end

  private

  def validate_balanced_parens(expression)
    parens = expression.gsub(/[^()]/, '')

    pairs = { '(' => ')' }

    stack = []
    parens.chars do |bracket|
      if expectation = pairs[bracket]
        stack << expectation
      else
        raise(MissingLeadingParenthesis, "Closing parenthesis was found without a matching opening parenthesis: <#{@expression}>") unless stack.pop == bracket
      end
    end

    raise(MissingTrailingParenthesis, "Missing one or more closing parenthesis: <#{@expression}>")

    stack.empty?
  end
end


context = {:Aa => true, :b => false, :c => true, :D => false, :e => true}

# true
be = BooleanExpression.new "((aA) and (b or (C or d)) and e)"
p be.evaluate(context)

# false
be = BooleanExpression.new "((B) OR (d))"
p be.evaluate(context)

# true
be = BooleanExpression.new "AA OR D AND E"
p be.evaluate(context)

# invalid, mismatched parens
be = BooleanExpression.new "AA)( OR B AND C"
p be.evaluate(context)

# invalid key
be = BooleanExpression.new "invalid_token"
p be.evaluate(context)


# class BoolExp
#        attr 'exp'
#        attr 'value'
#
#        def initialize exp, context = {}
#          @exp = exp.to_s
#
#          tokens = context.keys.map{|k| k.to_s}.join '|'
#          re = %r/^(?:\s*|#{ tokens }|[)(]|and|or|not)+$/i
#
#          raise "bad exp <#{ @exp }>" unless @exp =~ re
#
#          @value = Thread.new(exp, context) do |e, c|
#            $SAFE = 4
#            Module.new do
#              sc =
#                class << self
#                  self
#                end
#              c.each do |k,v|
#                case k.to_s
#                  when %r/^[A-Z]/
#                    const_set k, v
#                  else
#                    sc.module_eval{ attr_accessor k }
#                    send "#{ k }=", v
#                end
#              end
#              break module_eval(e)
#            end
#          end.value
#        end
#      end
