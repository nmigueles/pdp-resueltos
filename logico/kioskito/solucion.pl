% PUNTO 1
% turno(Persona, Dia, HorarioInicio, HorarioFinal)
turno(dodain, lunes, 9, 15).
turno(dodain, miercoles, 9, 15).
turno(dodain, viernes, 9, 15).

turno(lucas, martes, 10, 20).

turno(juanC, sabado, 18, 22).
turno(juanC, domingo, 18, 22).

turno(juanFdS, jueves, 10, 20).
turno(juanFdS, viernes, 12, 20).

turno(leoC, lunes, 14, 18).
turno(leoC, miercoles, 14, 18).

turno(martu, miercoles, 23, 24).

turno(vale, Dia, HorarioInicio, HorarioFinal) :- 
	turno(dodain, Dia, HorarioInicio, HorarioFinal).

turno(vale, Dia, HorarioInicio, HorarioFinal) :- 
	turno(juanC, Dia, HorarioInicio, HorarioFinal).

% No se modela que nadie hace el mismo horario que leoC ni que maiu esta pensando en qué horario hacer por principio de universo cerrado (ya que todo lo que no se pone se presume falso)

% PUNTO 2
% personas(Persona) :- turno(Persona, _, _, _).
personas(Persona) :- distinct(Persona, turno(Persona, _, _, _)).

dias(Dia) :- distinct(Dia, turno(_, Dia, _, _)).

quienAtiende(Persona, Dia, Hora) :-
	personas(Persona),
	dias(Dia),
	turno(Persona, Dia, HorarioInicio, HorarioFinal),
	Hora >= HorarioInicio, 
	Hora =< HorarioFinal.

% PUNTO 3

foreverAlone(Persona, Dia, Hora) :-
	personas(Persona),
	personas(OtraPersona),
	Persona \= OtraPersona,
	quienAtiende(Persona, Dia, Hora),
	not(quienAtiende(OtraPersona, Dia, Hora)).

% PUNTO 4

posibleAtencion(Dia, Trabajadores) :-
	findall(Persona, turno(Persona, Dia, _, _), Personas),
	combinarAtencion(Personas, Trabajadores).

combinarAtencion([], []).

combinarAtencion([Persona|Personas], [Persona|Trabajadores]) :-
	combinarAtencion(Personas, Trabajadores). % [dodain, leoC, vale]

combinarAtencion([_|Personas], Trabajadores) :-
	combinarAtencion(Personas, Trabajadores). 

% recursión y explosión combinatoria 

% PUNTO 5

% venta(Nombre, Fecha, Producto)
% golosina(Valor)
% cigarrillo([Marca])
% bebida(EsAlcoholca, Cantidad)

venta(dodain, "10/08", golosina(1200)).
venta(dodain, "10/08", cigarrillo([jockey])).
venta(dodain, "10/08", golosina(50)).

venta(dodain, "12/08", bebida(1, 8)).
venta(dodain, "12/08", bebida(0, 1)).
venta(dodain, "12/08", golosina(10)).

venta(martu, "12/08", golosina(1000)).
venta(martu, "12/08", cigarrillo([chesterfield, colorado, parisiennes])).

venta(lucas, "11/08", golosina(600)).

venta(lucas, "18/08", bebida(0, 2)).
venta(lucas, "18/08", cigarrillo([derby])).

vendedor(Persona) :- distinct(Persona, venta(Persona, _, _)).

ventaImportante(venta(_, _, Producto)) :-
	productoImportante(Producto).

productoImportante(golosina(Valor)) :-
	Valor > 100.

productoImportante(cigarrillo(Marcas)) :-
	length(Marcas, Cantidad),
	Cantidad > 2.

productoImportante(bebida(1, _)).

productoImportante(bebida(_, Cantidad)) :-
	Cantidad > 5.

primerElemento([PrimerProducto|_], PrimerProducto).

primerVentaImportante(Persona, Fecha) :-
	findall(Producto, venta(Persona, Fecha, Producto), Productos),
	primerElemento(Productos, PrimerProducto),
	productoImportante(PrimerProducto).

vendedorSuertudo(Persona) :-
	vendedor(Persona),
	forall(venta(Persona, Fecha, _), primerVentaImportante(Persona, Fecha)).
