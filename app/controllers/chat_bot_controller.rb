class ChatBotController < ApplicationController

  def create 
    open_ai_service = OpenAiService.new
    response = open_ai_service.get_response(params[:prompt])
    render json: { response: response }
  end
  
end