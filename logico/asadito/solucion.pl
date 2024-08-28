amigo(mati).
amigo(pablo).
amigo(leo).
amigo(fer).
amigo(flor).
amigo(ezequiel).
amigo(marina).

asado(fecha(15,9,2011), mixta).
asado(fecha(15,9,2011), mondiola).
asado(fecha(15,9,2011), chinchu).
asado(fecha(22,9,2011), chori).
asado(fecha(22,9,2011), waldorf).
asado(fecha(22,9,2011), vacio).

asistio(fecha(15,9,2011), flor).
asistio(fecha(15,9,2011), pablo).
asistio(fecha(15,9,2011), leo).
asistio(fecha(15,9,2011), fer).

asistio(fecha(22,9,2011), marina).
asistio(fecha(22,9,2011), flor).
asistio(fecha(22,9,2011), pablo).
asistio(fecha(22,9,2011), mati).


noSeBanca(leo, flor).
noSeBanca(pablo, fer).
noSeBanca(fer, leo).
noSeBanca(flor, fer).

leGusta(mati, chori).
leGusta(fer, mondiola).
leGusta(pablo, asado).
leGusta(mati, vacio).
leGusta(fer, vacio).
leGusta(mati, waldorf).
leGusta(flor, mixta).

leGusta(ezequiel, Comida) :- leGusta(mati, Comida).
leGusta(ezequiel, Comida) :- leGusta(fer, Comida).

leGusta(marina, Comida) :- leGusta(flor, Comida).
leGusta(marina, mondiola).

% No le gusta entonces blablaba P.U.C.

fechas(Fecha) :- distinct(Fecha, asistio(Fecha, _)).

asadoViolento(FechaAsado) :-
    fechas(FechaAsado),
    forall(asistio(FechaAsado, Persona), (
        noSeBanca(Persona, OtraPersona), 
        asistio(FechaAsado, OtraPersona),
        Persona \= OtraPersona
    )).

comida(achura(chori, 200)). % ya sabemos que el chori no es achura
comida(achura(chinchu, 150)).
comida(ensalada(waldorf, [manzana, apio, nuez, mayo])).
comida(ensalada(mixta, [lechuga, tomate, cebolla])).
comida(morfi(vacio)).
comida(morfi(mondiola)).
comida(morfi(asado)).

calorias(Nombre, Calorias) :-
    comida(Comida),
    caloriasDeUnaComida(Comida, Nombre, Calorias).

caloriasDeUnaComida(ensalada(Nombre, Ingredientes),Nombre, Calorias) :-
    length(Ingredientes, Calorias).
caloriasDeUnaComida(achura(Nombre, Calorias), Nombre, Calorias).
caloriasDeUnaComida(morfi(Nombre), Nombre, 200).
    
asadoFlojito(FechaAsado) :-
    distinct(FechaAsado, asado(FechaAsado, _)),
    aggregate_all(sum(Calorias), (
        asado(FechaAsado, NombreComida),
        calorias(NombreComida, Calorias)
    ), Total),
    Total < 400.

asadoSaludable(FechaAsado) :-
    distinct(FechaAsado, asado(FechaAsado, _)),
    forall(asado(FechaAsado, NombreComida), (
        calorias(NombreComida, Calorias),
        Calorias < 200
    )).