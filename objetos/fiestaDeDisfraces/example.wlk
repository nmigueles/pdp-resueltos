class Fiesta {
  const property lugar
  const property fecha
  const property invitados = []

  method esUnBodrio() = invitados.all({ invitado => !invitado.estaConforme() })

  method mejorDisfraz() = invitados.max({ invitado => invitado.disfraz().puntos(invitado) })

  method intercambiarTrajes(invitado1, invitado2) = self.estanEnLaFiesta(invitado1, invitado2) &&
                                                    self.algunoEstaDisconforme(invitado1, invitado2) && 
                                                    self.quedanConformes(invitado1, invitado2)

  method estanEnLaFiesta(invitado1, invitado2) = invitados.contains(invitado1) && invitados.contains(invitado2)

  method algunoEstaDisconforme(invitado1, invitado2) = !invitado1.estaConforme() || !invitado2.estaConforme()

  method quedanConformes(invitado1, invitado2) {
    const disfraz1 = invitado1.disfraz()
    const disfraz2 = invitado2.disfraz()
    
    invitado1.disfraz(disfraz2)
    invitado2.disfraz(disfraz1)

    const conformes = invitado1.estaConforme() && invitado2.estaConforme()

    invitado1.disfraz(disfraz1)
    invitado2.disfraz(disfraz2)
    return conformes
  }

  method agregarParticipante(invitado) {
    self.tieneDisfraz(invitado)
    self.noEstaEnLaFiesta(invitado)
    invitados.add(invitado)
  }

  method tieneDisfraz(invitado) {
    if (invitado.disfraz() == null) throw new DomainException(message = "El invitado no tiene disfraz")
  }

  method noEstaEnLaFiesta(invitado) {
    if (invitados.contains(invitado)) throw new DomainException(message = "El invitado ya esta en la fiesta")
  }
}

class Persona {
  var property edad
  var property disfraz = null
  var property personalidad

  method esSexy() = personalidad.esSexy(self)

  method esJoven() = edad < 30

  method esViejo() = edad > 50

  method estaConforme() = disfraz.puntos(self) > 10 && self.condicionConforme()

  method condicionConforme()
}

class Caprichoso inherits Persona {
  override method condicionConforme() = disfraz.cantidadDeLetrasDelNombre().even()
}

class Pretencioso inherits Persona {
  override method condicionConforme() = disfraz.esNuevo()
}

class Numerologo inherits Persona {
  const puntosDeLaSuerte

  override method condicionConforme() = disfraz.puntos(self) > puntosDeLaSuerte
}

class Disfraz {
  const property nombre
  const property fechaDeCompra = new Date()
  const property fechaDeConfeccion = new Date()
  var property caracteristica
  var property nivelDeGracia
  
  method puntos(portador) = caracteristica.puntos(self, portador)

  method cantidadDeLetrasDelNombre() = nombre.length()

  method esNuevo() = new Date() - fechaDeConfeccion < 30

  method compradoHacePoco() = new Date() - fechaDeCompra < 2
} 

// Caracteristicas

object gracioso {
  method puntos(disfraz, portador) = disfraz.nivelDeGracia() * self.multiplicadorPorEdad(portador)
  
  method multiplicadorPorEdad(portador) = if (portador.edad() > 50) 3 else 1
}

object tobara {
  method puntos(disfraz, portador) = if (disfraz.compradoHacePoco()) 3 else 5
}

object mickyMouse { method valor() = 8 }
object osoCarolina { method valor() = 6 }


class Careta {
  const property personaje = mickyMouse

  method puntos(disfraz, portador) = personaje.valor()
}

object sexy {
  method puntos(disfraz, portador) = if (portador.esSexy()) 15 else 2
}

class CombinacionDeCaracteristicas {
  const property caracteristicas = []

  method puntos(disfraz, portador) = caracteristicas.sum({ caracteristica => caracteristica.puntos(disfraz, portador) })
}

// Personalidad

object alegre {
  method esSexy(persona) = false
}

object taciturno {
  method esSexy(persona) = persona.esJoven()
}

object cambiante {
  const pool = [alegre, taciturno]
  method esSexy(persona) = self.caracteristicaAleatoria().esSexy(persona)

  method caracteristicaAleatoria() = pool.randomize().first()
}

object fiestaInolvidable inherits Fiesta(lugar="Casa de Dodain", fecha=new Date()) {
  override method agregarParticipante(invitado) {
    self.chequeoSexy(invitado)
    self.chequeoConformidad(invitado)
    super(invitado)
  }

  method chequeoSexy(invitado) {
    if (!invitado.esSexy()) throw new DomainException(message = "El invitado no es sexy")
  }

  method chequeoConformidad(invitado) {
    if (!invitado.estaConforme()) throw new DomainException(message = "El invitado no esta conforme con su traje")
  }
}