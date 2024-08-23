% Punto 1

viajaA(dodain, "Pehuenia").
viajaA(dodain, "San Martin de los Andes").
viajaA(dodain, "Esquel").
viajaA(dodain, "Sarmiento").
viajaA(dodain, "Camarones").
viajaA(dodain, "Playas Doradas").

viajaA(alf, "Bariloche").
viajaA(alf, "San Martin de los Andes").
viajaA(alf, "El Bolsón").

viajaA(nico, "Mar del Plata").

viajaA(vale, "Calafate").
viajaA(vale, "El Bolsón").

viajaA(martu, Destino) :- 
    viajaA(nico, Destino).


viajaA(martu, Destino) :- 
    viajaA(alf, Destino).

% personas(Persona) :- viajaA(Persona, _).
personas(Persona) :- distinct(Persona, viajaA(Persona, _)).

% Juan como no se decide, no damos por hecho que viaja a ningun lado, por lo tanto no lo modelamos ya que por principio de universo cerrado, todo lo que no esta modelado es falso.
% Lo mismo ocurre con Carlos, que no se va a tomar vacaciones.

% Punto 2
% atraccion(Destino, Atraccion)

% Functor de atraccion
% parqueNacional(Nombre)
% cerro(Nombre, Altura)
% excursion(Nombre)
% cuerpoDeAgua(Nombre, SePuedePescar, TemperaturaPromedioDelAgua)
% playa(Nombre, DiferenciaPromedio)

atraccion("Esquel", parqueNacional("Los Alerces")).
atraccion("Esquel", excursion("Trochita")).
atraccion("Esquel", excursion("Trevelin")).

atraccion("Pehuenia", cerro("Batea Mahuida", 2000)).
atraccion("Pehuenia", cuerpoDeAgua("Moquehue", 1, 14)).
atraccion("Pehuenia", cuerpoDeAgua("Aluminé", 1, 19)).

atraccion("Bariloche", playa("Bonita", 5)).

atraccion("Mar del Plata", playa("Grande", 1)).

% atracciones copadas
atraccionCopada(cerro(_, Altura)) :- Altura > 2000.
atraccionCopada(cuerpoDeAgua(_, 1, Temperatura)) :- Temperatura > 20.
atraccionCopada(playa(_, Diferencia)) :- Diferencia < 5.
atraccionCopada(excursion(Nombre)) :-
    string_length(Nombre, Length),
    Length > 7.
atraccionCopada(parqueNacional(_)).
    
% Un destino es copado si tiene al menos una atraccion copada
destinoCopado(Destino) :- 
    atraccion(Destino, Atraccion),
    atraccionCopada(Atraccion).

vacacionesCopadas(Persona) :-
    personas(Persona),
    forall(viajaA(Persona, Destino), destinoCopado(Destino)).

% Para todo p(x) => q(x),

% Punto 3

% noSeCruzo(Persona, OtraPersona)

noSeCruzo(Persona, OtraPersona) :-
    personas(Persona),
    personas(OtraPersona),
    Persona \= OtraPersona,
    forall(viajaA(Persona, Destino), not(viajaA(OtraPersona, Destino))).

% Punto 4

costoDeVida("Sarmiento", 100).
costoDeVida("Esquel", 150).
costoDeVida("Pehuenia", 180).
costoDeVida("San Martin de los Andes", 150).
costoDeVida("Camarones", 135).
costoDeVida("Playas Doradas", 170).
costoDeVida("Bariloche", 140).
costoDeVida("Calafate", 240).
costoDeVida("El Bolsón", 145).
costoDeVida("Mar del Plata", 140).

destinoGasolero(Destino) :-
    costoDeVida(Destino, Costo),
    Costo < 160.

vacacionesGasoleras(Persona) :-
    personas(Persona),
    forall(viajaA(Persona, Destino), destinoGasolero(Destino)).

% Punto 5

armarItineratio(Persona, Itinerario) :-
    personas(Persona),
    %       Uno    , como busco ese uno      , Todos
    findall(Destino, viajaA(Persona, Destino), Destinos),
    permutation(Destinos, Itinerario).
    
