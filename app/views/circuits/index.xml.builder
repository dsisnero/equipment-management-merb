xml.circuits do
  for circuit in @circuits
    xml.circuit do
      xml.usi circuit.usi
      xml.csa circuit.csa
      xml.from_lid_fac circuit.from_lid_fac
      xml.to_lid_fac circuit.to_lid_fac
      xml.nas circuit.nas
      xml.svc circuit.svc
      xml.from_interface_type circuit.from_interface_type
      xml.cutover_status circuit.cutover_status
  end
  end
end


