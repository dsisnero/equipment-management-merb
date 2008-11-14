class Facilities < Application
  provides :xml, :yaml, :js

  def index
    @facilities = Facility.all
    display @facilities
  end

  def show(lid_fac)
    lid,fac = lid_fac.split("_")
    @facility = Facility.get(lid,fac)
    raise NotFound unless @facility
    display @facility
  end

  def new
    only_provides :html
    @facility = Facility.new
    display @facility
  end

  def edit(id)
    only_provides :html
  #  lid,fac = lid_fac.split("_")
    @facility = Facility.get(id)
    raise NotFound unless @facility
    display @facility
  end

  def create(facility)
    @facility = Facility.new(facility)
    if @facility.save
      redirect resource(@facility), :message => {:notice => "Facility was successfully created"}
    else
      message[:error] = "Facility failed to be created"
      render :new
    end
  end

  def update(id, facility)
    @facility = Facility.get(id)
    raise NotFound unless @facility
    if @facility.update_attributes(facility)
       redirect resource(@facility)
    else
      display @facility, :edit
    end
  end

  def destroy(id)
    @facility = Facility.get(id)
    raise NotFound unless @facility
    if @facility.destroy
      redirect resource(:facilities)
    else
      raise InternalServerError
    end
  end

end # Facilities
