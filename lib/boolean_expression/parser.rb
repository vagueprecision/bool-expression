# frozen_string_literal: true

module BooleanExpression
  class ParsingError < StandardError; end

  class MissingOpeningParensError < ParsingError; end
  class MissingClosingParensError < ParsingError; end
  class UnpermittedKeysError < ParsingError; end
  class MalformedExpressionError < ParsingError; end

  # Case insensitive keys
  class Parser
    attr_reader :expression

    def initialize(expression)
      @expression = expression.to_s.downcase
    end

    # key_value_pairs as an array
    def validate(permitted_keys)
      validate_balanced_parens(@expression)
      key_value_pairs = permitted_keys.map { |t| [t, true] }.to_h.symbolize_keys!
      evaluate(key_value_pairs)
      nil
    end

    # key_value_pairs as a hash
    def evaluate(key_value_pairs)
      key_value_pairs = Hash[key_value_pairs.map { |k, v| [k.downcase, v] }]
      validate_keys(key_value_pairs.keys)

      kls = Class.new
      key_value_pairs.each do |key, value|
        kls.instance_eval { class << self; self end }.send(:attr_accessor, key)
        kls.send("#{key}=", value)
      end
      kls.instance_eval(@expression)
    rescue SyntaxError
      raise(MalformedExpressionError, 'Malformed expression')
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
          unless stack.pop == bracket
            raise(MissingOpeningParensError,
                  'A closing parenthesis was found without an opening parenthesis preceding it')
          end
        end
      end

      raise(MissingClosingParensError, "Missing #{stack.count} closing parentheses") if stack.any?
    end

    def validate_keys(permitted_keys)
      delimited_keys = permitted_keys.join '|'
      regex = %r/^(?:\s*|#{delimited_keys}|[)(]|and|or|not)+$/i
      raise(UnpermittedKeysError, 'Unpermitted keys found') unless @expression =~ regex
    end
  end
end
