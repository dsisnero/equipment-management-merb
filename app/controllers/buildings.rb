require File.join(File.dirname(__FILE__), "site_base")

class Buildings < SiteBase
  # provides :xml, :yaml, :js
  
  def index
    @buildings = @site.buildings
    display @buildings
  end

  def show(id)
    @building = Building.get(id)
    raise NotFound unless @building
    display @building
  end
  
  def new
    only_provides :html
    @building = @site.buildings.build
    display @building
  end

  def edit(id)
    only_provides :html
    @building = Building.get(id)
    raise NotFound unless @building
    display @building
  end

  def create(building)
    @building = @site.buildings.build(building)
    if @building.save
      redirect resource(@site,@building), :message => {:notice => "Building was successfully created"}
    else
      message[:error] = "Building failed to be created"
      render :new
    end
  end

  def update(id, building)
    @building = @site.buildings.get(id)
    raise NotFound unless @building
    if @building.update_attributes(building)
       redirect resource(@site,@building)
    else
      display @building, :edit
    end
  end

  def destroy(id)
    @building = Building.get(id)
    raise NotFound unless @building
    if @building.destroy
      redirect resource(:buildings)
    else
      raise InternalServerError
    end
  end  
 

end # Buildings
