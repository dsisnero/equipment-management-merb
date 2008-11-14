class Circuits < Application
  
  before :ensure_authenticated
  
  provides :xml, :json
  
  #cache :index,:show

  def index
    if lid_fac = params[:lid_fac]
      lid,fac = lid_fac.split('_')
      @facility = Facility.get(lid,fac)
      @circuits = @facility.from_circuits + @facility.to_circuits
    else
      @circuits = Circuit.all
    end    
    display @circuits
  end

  def show(id)
    @circuit = Circuit.get(id)
    raise NotFound unless @circuit
    display @circuit
  end

  def new
    only_provides :html
    @circuit = Circuit.new
    display @circuit
  end

  def edit(id)
    only_provides :html
    @circuit = Circuit.get(id)
    raise NotFound unless @circuit
    display @circuit
  end

  def create(circuit)
    @circuit = Circuit.new(circuit)
    if @circuit.save
      redirect resource(@circuit), :message => {:notice => "Circuit was successfully created"}
    else
      message[:error] = "Circuit failed to be created"
      render :new
    end
  end

  def update(id, circuit)
    @circuit = Circuit.get(id)
    raise NotFound unless @circuit
    if @circuit.update_attributes(circuit)
       redirect resource(@circuit)
    else
      display @circuit, :edit
    end
  end

  def destroy(id)
    @circuit = Circuit.get(id)
    raise NotFound unless @circuit
    if @circuit.destroy
      redirect resource(:circuits)
    else
      raise InternalServerError
    end
  end

end # Circuits
