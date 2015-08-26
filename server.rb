require 'sinatra'
require 'json'

enable :show_errors

get '/' do
  @time = Time.now
  erb :home
end

post '/calc' do
  @x = params[:x].to_f
  @y = params[:y].to_f
  @operator = params[:operator]
  case @operator
  when 'plus'
    @result = @x + @y
  when 'minus'
    @result = @x - @y
  when 'times'
    @result = @x * @y
  when 'divided by'
    @result = @x / @y
  else
    @error = 'Unknown Operator'
  end
  erb :result
end

#first pass for api demo - duplicate route:
post '/api/v1/calc' do
  content_type :json # better place?

  begin
    @x = params[:x].to_f  #type conversion
    @y = params[:y].to_f
    @operator = params[:operator]
    case @operator
    when 'plus'
      @result = @x + @y
    when 'minus'
      @result = @x - @y
    when 'times'
      @result = @x * @y
    when 'divided by'
      @result = @x / @y
    else
      @error = 'Unknown Mathematical Operator'
    end 

    if !@error && @result.infinite?
      @error = "Result was infinity"
    end  

  rescue => e
    @error = e.message
  end  

  if @error
    halt 400, { error: @error }.to_json 
  else 
    { x: @x, y: @y, operator: @operator, result: @result }.to_json
  end
end