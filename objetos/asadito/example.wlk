
class Persona {
  var property posicion
  var property elementos

  var property criterioDePedidos = criterioSordo


  method pedirElemento(persona, elementoPedido) {
    criterioDePedidos.pedirElemento(persona, self, elementoPedido)
  }

  method entregarElemento(persona, elemento) {
    if (self.noTieneElemento(elemento)) {
      throw new Exception(message = "No tiene ese elemento.")
    }
    elementos.remove(elemento) // Me lo remuevo a mi
    persona.recibirElemento(elemento) // Se lo entrego a la otra persona
  }

  method recibirElemento(elemento) {
    elementos.add(elemento)
  }

  method noTieneElemento(elemento) {
    return elementos.constains(elemento)
  }


  method elementoALaMano() {
    // Devuelve el primer elemento que tiene a la mano, osea el primero de la lista de elementos
    return elementos.first()
  }

  method intercambiarPosicionCon(otro) {
    const destino = otro.posicion()
    const nuevosElementos = otro.elementos()

    otro.posicion(posicion)
    otro.elementos(elementos)

    self.posicion(destino)
    self.elementos(nuevosElementos)
  }
}

object criterioSordo {
  method pedirElemento(duenio, destinatario, elementoPedido) {
    const elemento = duenio.elementoALaMano()
    duenio.entregarElemento(destinatario, elemento)
  }
}

object criterioDejameComerTranquilo {
  method pedirElemento(duenio, destinatario, elementoPedido) {
    duenio.elementos().forEach({ elemento => duenio.entregarElemento(destinatario, elemento)})
  }
}

object criterioIntercambiarPosicionEnLaMesa {
  method pedirElemento(duenio, destinatario, elementoPedido) {
    duenio.intercambiarPosicionCon(destinatario)
  }
}

object criterioPasarObjecto {
  method pedirElemento(duenio, destinatario, elementoPedido) {
    duenio.entregarElemento(destinatario, elementoPedido)
  }
}