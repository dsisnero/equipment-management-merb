class SiteBase < Application
  
  before :load_site  
  layout :site
  
  private  

  def load_site
    @site = Site.get(params[:site_id])
    raise NotFound unless @site
  end
end
