module Merb
  module GlobalHelpers
    
    def parent_layout(layout, &block)
      render capture(&block), :layout => layout
    end 
    # helpers defined here available to all views.  
  end
end
