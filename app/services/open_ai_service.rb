class OpenAiService

  def initialize
    @client = OpenAI::Client.new
  end

  def get_response(prompt)
    messages = [
      { role: "user", content: prompt }, 
      { role: "system", content: "You are a helpful assistant that answers in English." },
    ]
    response_text = ""

    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: messages,
        temperature: 0.7,
        functions: [
          {
            name: 'calculate_sum',
            descriptions: 'Calculates the sum of two numbers',
            parameters: {
              type: 'object',
              properties: {
                num1: { type: 'number', description: 'The first number' },
                num2: { type: 'number', description: 'The second number' },
              },
              required: ['num1', 'num2']
            }
          },
          {
            name: "find_post",
            descriptions: 'finds a post by title and returns its body',
            parameters: {
              type: 'object',
              properties: {
                title: { type: 'string', description: 'the title of the post'}
              },
              required: ['title']
            }
          }
        ],
        function_call: 'auto',
      }
    )
    choices = response["choices"].first
    puts "CHOICES -> #{choices}"
    message = choices["message"]
    
    if message['function_call']
      puts "Inside fuction calling"
      function_call = message['function_call']
      function_name = function_call["name"]
      arguments     = JSON.parse(function_call["arguments"])
      response_text = call_function(function_name, arguments)
    else
      response_text = message["content"]
    end
    response_text.strip
  end

  private

  def call_function(function_name, arguments)
    case function_name
    when "calculate_sum"
      num1 = arguments['num1']
      num2 = arguments['num2']
      calculate_sum(num1, num2)
    when 'find_post'
      title = arguments['title']
      find_post_by_title(title)
    else
      "Function not recognized"
    end
  end

  def calculate_sum(num1, num2)
    (num1 + num2).to_s
  end

  def find_post_by_title title
    post = Post.where("LOWER(title) LIKE ?", "%#{title.downcase}%").first
    if post
      post.body
    else
      "Post not found"
    end  
  end

end