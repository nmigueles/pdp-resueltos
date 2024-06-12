module Library where

import PdePreludat

data Postre = Postre
  { sabores :: [String], -- string por ahora
    peso :: Number,
    temperatura :: Number
  }
  deriving (Show, Eq)

data Mago = Mago
  { hechizos :: [Hechizo],
    horrorcruxes :: Number
  }

type Hechizo = Postre -> Postre

-- Incendio: calienta el postre 1 grado y lo hace perder 5% de su peso.
incendio :: Hechizo
incendio postre =
  postre
    { temperatura = ((+) 1 . temperatura) postre,
      peso = ((*) 0.95 . peso) postre
    }

-- Immobulus: congela el postre, llevando su temperatura a 0.
immobulus :: Hechizo
immobulus postre = postre {temperatura = 0}

-- Wingardium Leviosa: levanta el postre en el aire y lo deja caer,
-- lo que agrega a sus sabores el sabor “concentrado”. Además, pierde 10% de su peso.
wingardiumLeviosa :: Hechizo
wingardiumLeviosa postre =
  postre
    { sabores = sabores postre ++ ["concentrado"],
      peso = ((*) 0.9 . peso) postre
    }

-- Diffindo: Corta el postre, disminuyendo su peso en el porcentaje indicado.
diffindo :: Number -> Hechizo
diffindo porcentaje postre =
  postre
    { peso = ((*) (1 - porcentaje / 100) . peso) postre
    }

-- Riddikulus: Requiere como información adicional un sabor y lo agrega a los sabores que
-- tiene un postre, pero invertido.
riddikulus :: String -> Hechizo
riddikulus sabor postre =
  postre
    { sabores = ((++) [reverse sabor] . sabores) postre
    }

-- Avada kedavra: Hace lo mismo que el immobulus pero además hace que el postre pierda
-- todos sus sabores.
avadaKedavra :: Hechizo
avadaKedavra postre =
  immobulus
    postre
      { sabores = []
      }

-- (un postre está listo cuando pesa algo más que cero, tiene algún sabor y además no está congelado).
postreEstaListo :: Postre -> Bool
postreEstaListo postre = peso postre > 0 && (not . null . sabores) postre && temperatura postre > 0

hechizoDejaListoElPostre :: Hechizo -> Postre -> Bool
hechizoDejaListoElPostre hechizo = postreEstaListo . hechizo

hechizoDejaListoPostres :: Hechizo -> [Postre] -> Bool
hechizoDejaListoPostres hechizo = all (hechizoDejaListoElPostre hechizo)

promedio :: [Number] -> Number
promedio numeros = sum numeros / length numeros

pesoPromedioDeLosPostresListos :: [Postre] -> Number
pesoPromedioDeLosPostresListos = promedio . map peso . filter postreEstaListo

-- Si el hechizo deja el postre igual que el otro hechizo, entonces retorna true
hechizoEsIgualA :: Hechizo -> Hechizo -> Postre -> Bool
hechizoEsIgualA hechizo otroHechizo postre = hechizo postre == otroHechizo postre

-- Magos

agregarHechizo :: Hechizo -> Mago -> Mago
agregarHechizo hechizo mago = mago {hechizos = ((++) [hechizo] . hechizos) mago}

type Practica = Mago -> Mago

practicarHechizo :: Hechizo -> Postre -> Practica
practicarHechizo hechizo postre mago =
  (agregarHechizo hechizo mago)
    { horrorcruxes = ((+) (if hechizoEsIgualA hechizo avadaKedavra postre then 1 else 0) . horrorcruxes) mago
    }

devolverMejorHechizo :: Postre -> Hechizo -> Hechizo -> Hechizo
devolverMejorHechizo postre hechizo otroHechizo = if (length . sabores . hechizo) postre >= (length . sabores . otroHechizo) postre then hechizo else otroHechizo

-- Dado un postre y un mago obtener su mejor hechizo, que es aquel de sus hechizos que deja al postre con más cantidad de sabores luego de usarlo.
mejorHechizo :: Postre -> Mago -> Hechizo
mejorHechizo postre (Mago hechizos _) = foldr (devolverMejorHechizo postre) (head hechizos) hechizos