class HelloWorld < Application
  
  before :ensure_authenticated

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    "Hello World"
  end
  
end
