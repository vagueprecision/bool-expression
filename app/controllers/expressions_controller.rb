class ExpressionsController < ApplicationController
  def index
    @expressions = Expression.all
  end

  def edit
    @expression = Expression.find(params[:id])
    @activities = Activity.all
  end

  def new
    @expression = Expression.new
    @activities = Activity.all
  end

  def create
    expression = Expression.create(expression_params)
    redirect_to edit_expression_path(expression.id)
  end

  def update
    expression = Expression.find(params[:id])
    expression.update(expression_params)
    redirect_to edit_expression_path(expression.id)
  end

  def destroy
    Expression.find(params[:id]).destroy
    redirect_to expressions_path
  end

  def validate
    expression = BooleanExpression::Parser.new(expression_param)
    begin
      expression.validate(Activity.pluck(:key))
      valid = true
    rescue BooleanExpression::ParsingError => e
      valid = false
      exception = e
    end

    render json: {
      valid: valid,
      errorType: e.try(:class),
      errorMessage: e.try(:message)
    }
  end

  def evaluate
    expression = BooleanExpression::Parser.new(expression_param)
    hash = Activity.pluck(:key, :sample_value).to_h
    result = expression.evaluate(hash)

    render json: {
      result: result
    }
  end

  private

  def expression_params
    params.require(:expression).permit(:name, :expression)
  end

  def expression_param
    params.require(:expression)
  end
end
