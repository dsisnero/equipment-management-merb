class Sites < Application
  # provides :xml, :yaml, :js

  def index
    @sites = Site.all
    #debugger
    display @sites
  end

  def show(id)
    @site = Site.get(id)
    raise NotFound unless @site
    display @site
  end

  def new
    only_provides :html
    @site = Site.new
    display @site
  end

  def edit(id)
    only_provides :html
    @site = Site.get(id)
    raise NotFound unless @site
    display @site
  end

  def create(site)
    @site = Site.new(site)
    if @site.save
      redirect resource(@site), :message => {:notice => "Site was successfully created"}
    else
      message[:error] = "Site failed to be created"
      render :new
    end
  end

  def update(id, site)
    @site = Site.get(id)
    raise NotFound unless @site
    if @site.update_attributes(site)
       redirect resource(@site)
    else
      display @site, :edit
    end
  end

  def destroy(id)
    @site = Site.get(id)
    raise NotFound unless @site
    if @site.destroy
      redirect resource(:sites)
    else
      raise InternalServerError
    end
  end

end # Sites
