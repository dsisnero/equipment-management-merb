require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a circuit exists" do
  Circuit.all.destroy!
  request(resource(:circuits), :method => "POST", 
    :params => { :circuit => { :id => nil }})
end

describe "resource(:circuits)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:circuits))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of circuits" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a circuit exists" do
    before(:each) do
      @response = request(resource(:circuits))
    end
    
    it "has a list of circuits" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Circuit.all.destroy!
      @response = request(resource(:circuits), :method => "POST", 
        :params => { :circuit => { :id => nil }})
    end
    
    it "redirects to resource(:circuits)" do
      @response.should redirect_to(resource(Circuit.first), :message => {:notice => "circuit was successfully created"})
    end
    
  end
end

describe "resource(@circuit)" do 
  describe "a successful DELETE", :given => "a circuit exists" do
     before(:each) do
       @response = request(resource(Circuit.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:circuits))
     end

   end
end

describe "resource(:circuits, :new)" do
  before(:each) do
    @response = request(resource(:circuits, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@circuit, :edit)", :given => "a circuit exists" do
  before(:each) do
    @response = request(resource(Circuit.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@circuit)", :given => "a circuit exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Circuit.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @circuit = Circuit.first
      @response = request(resource(@circuit), :method => "PUT", 
        :params => { :article => {:id => @circuit.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@circuit))
    end
  end
  
end

