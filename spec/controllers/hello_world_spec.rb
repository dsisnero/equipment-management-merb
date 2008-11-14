require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe HelloWorld, "index action" do
  before(:each) do
    dispatch_to(HelloWorld, :index)
  end
end