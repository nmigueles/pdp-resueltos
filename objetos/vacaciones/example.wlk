class Lugar {
  const nombre

  method tieneNombrePar() = nombre.length().even()

  method esDivertido() = self.tieneNombrePar() && self.condicionParaSerDivertido()

  method condicionParaSerDivertido()

  method esTranquilo()

  method tieneNombreRaro() = nombre.length() > 10
}

class Ciudad inherits Lugar {
  const atracciones
  const habitantes
  const decibelesPromedio

  override method condicionParaSerDivertido() = self.tieneMuchasAtracciones() && self.tieneMuchosHabitantes()

  method tieneMuchasAtracciones() = atracciones.size() > 3

  method tieneMuchosHabitantes() = habitantes > 100000

  override method esTranquilo() = decibelesPromedio < 20
}

class Pueblo inherits Lugar {
  const extensionTerritorial
  const anioDeFundacion
  const provincia

  override method condicionParaSerDivertido() = self.esDelLitoral() || self.fundadoAntesDel1800()

  method fundadoAntesDel1800() = anioDeFundacion < 1800

  method esDelLitoral() = (#{"Corrientes", "Entre Rios", "Santa Fe"}).contains(provincia)

  override method esTranquilo() = provincia == "La Pampa"
}

class Balneario inherits Lugar {
  const metrosDePlaya
  const marPeligroso = false
  const peatonal = false

  override method condicionParaSerDivertido() = marPeligroso && self.tieneMuchosMetrosDePlaya()

  method tieneMuchosMetrosDePlaya() = metrosDePlaya > 300

  override method esTranquilo() = !peatonal
}

// Personas

class Persona {
  const preferencia = new Preferencia()
  const presuepuestoMaximo

  method iriaALugar(lugar) = preferencia.iriaALugar(lugar)

  method agregarPreferencia(_preferencia) = preferencia.agregarPreferencia(_preferencia)

  method removerPreferencia(_preferencia) = preferencia.removerPreferencia(_preferencia)  

  method reiniciarPreferencias() = preferencia.reiniciarPreferencias()

  method puedePagar(monto) = monto <= presuepuestoMaximo
}

// Composite
class Preferencia { 
  const preferencias = #{}

  method agregarPreferencia(preferencia) = preferencias.add(preferencia)

  method removerPreferencia(preferencia) = preferencias.remove(preferencia)

  method reiniciarPreferencias() = preferencias.clear()

  method iriaALugar(lugar) = preferencias.any({ preferencia => preferencia.iriaALugar(lugar) })
}

object preferenciaTranquilidad {
  method iriaALugar(lugar) = lugar.esTranquilo()
}

object preferenciaDiversion {
  method iriaALugar(lugar) = lugar.esDivertido()
}

object preferenciaRaro {
  method iriaALugar(lugar) = lugar.tieneNombreRaro()
}

object _calendario { // Stub
  method hoy() = new Date()
}

class Tour {
  const calendario = _calendario
  const fechaDeSalida
  const cantidadDePersonasRequeridas
  const ciudadesARecorrer
  const precio

  const personas = #{}

  method confirmado() = self.tourCompleto()

  method agregarPersona(persona) {
    self.hayEspacio()
    self.adecuadoParaPersona(persona) 
    personas.add(persona)
  }

  method bajarPersona(persona) = personas.remove(persona)

  method tourCompleto() = personas.size() == cantidadDePersonasRequeridas

  method hayEspacio() {
    if (self.tourCompleto()) {
      throw new DomainException(message = "Se llego al limite de personas para el tour")
    }
  }

  method adecuadoParaPersona(persona) {
    if (!persona.puedePagar(precio)) {
      throw new DomainException(message = "El monto del tour no es adecuado para la persona")
    }

    if (!ciudadesARecorrer.all({ ciudad => persona.iriaALugar(ciudad) })) {
      throw new DomainException(message = "Hay lugares que no son adecuados para la persona")
    }
  }

  method saleEsteAnio() = fechaDeSalida.year() == calendario.hoy().year()

  method recaudacionTotal() = personas.size() * precio
}

object reporte {
  method toursPendientesDeConfirmacion(tours) = tours.find({ tour => !tour.confirmado() })

  method totalDeToursQueSalenEsteAnio(tours) = self.toursQueSalenEsteAnio(tours).sum({
    tour => tour.recaudacionTotal()
  })

  method toursQueSalenEsteAnio(tours) = tours.filter({ tour => tour.saleEsteAnio() })
}