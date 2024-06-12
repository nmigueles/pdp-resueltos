module Library where

import PdePreludat

data VisitaMedica = VisitaMedica
                      { diasDeRecuperacion :: Number
                      , costo              :: Number
                      }
  deriving (Show)

data Animal = Animal
                { nombre          :: String
                , tipo            :: String
                , peso            :: Number
                , edad            :: Number
                , enfermo         :: Bool
                , historialMedico :: [VisitaMedica]
                }
  deriving (Show)

-- Devuelve si un animal la paso mal, esto quiere decir
-- que alguna de las visitas medicas duró mas de 30 días
laPasoMal :: Animal -> Bool
laPasoMal = any ((> 30) . diasDeRecuperacion) . historialMedico

-- Devuelve si un animal tiene nombre falopa, esto quiere decir
-- que la ultima letra del nombre termina con i.
tieneNombreFalopa :: Animal -> Bool
tieneNombreFalopa = (== 'i') . last . nombre

-- Actividades

-- Modela una actividad que se le puede hacer a un animal
type Actividad = Animal -> Animal

modificarPeso :: Number -> Animal -> Animal
modificarPeso delta animal =
  animal
    { peso = ((+) delta . peso) animal
    }

-- Hacer que un animal coma N kilos de alimento balanceado
engorde :: Number -> Actividad
engorde kilos = modificarPeso ((min 5 . (/) 2) kilos)

-- Que pasa si no esta enfermo, no necesita revisacion medica, entonces se lo tengo que pasar por parametro?
-- Esto no me gusta
revisacionMedica :: VisitaMedica -> Actividad
revisacionMedica visitaMedica animal 
  | enfermo animal = (engorde 2 animal) { 
      historialMedico = ((++) [visitaMedica] . historialMedico) animal
  }
  | otherwise = animal

festejarCumpleanios :: Actividad
festejarCumpleanios animal = modificarPeso (-1) animal { 
  edad = ((+) 1 . edad) animal
}

chequeoDePeso :: Number -> Actividad
chequeoDePeso pesoLimite animal = animal { 
  enfermo = ((<=) pesoLimite . peso) animal
}

proceso :: [Actividad] -> Animal -> Animal
proceso actividades animal = foldr ($) animal actividades

-- Ejemplos
procesoEjemplo :: Animal
procesoEjemplo =
  proceso
    [ engorde 5,
      festejarCumpleanios,
      chequeoDePeso 10,
      revisacionMedica (VisitaMedica {
        diasDeRecuperacion = 30, 
        costo = 200
      })
    ]
    Animal
      { nombre = "Gachi",
        tipo = "Vaca",
        peso = 5,
        edad = 5,
        enfermo = False,
        historialMedico = []
      }

elPesoSubeDeFormaControlada :: Actividad -> Animal -> Bool
elPesoSubeDeFormaControlada actividad animal = 
  -- La actividad debe mejorar el peso del animal
  ((peso . actividad) animal >= peso animal) && 
    -- La actividad no debe hacer que el peso suba mas de 3 kilos
  ((peso . actividad) animal  - peso animal) <= 3

elPesoMejora :: [Actividad] -> Animal -> Bool
elPesoMejora [] animal = True
elPesoMejora (actividad:actividades) animal =
  elPesoSubeDeFormaControlada actividad animal && elPesoMejora actividades (actividad animal)

primerosTresAnimalesConNombreFalopa :: [Animal] -> [Animal]
primerosTresAnimalesConNombreFalopa = take 3 . filter tieneNombreFalopa
