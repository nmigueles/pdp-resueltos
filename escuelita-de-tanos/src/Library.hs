module Library where

import PdePreludat

data Guantelete = Guantelete
  { material :: String,
    gemas :: [Gema]
  }

data Personaje = Personaje
  { edad :: Number,
    energia :: Number,
    habilidades :: [String],
    nombre :: String,
    planeta :: String
  }

type Universo = [Personaje]

chasquidoDeUniverso :: Guantelete -> Universo -> Universo
chasquidoDeUniverso guantelete universo
  | ((==) 6 . length . gemas) guantelete && ((==) "uru" . material) guantelete = take (((2 `div`) . length) universo) universo
  | otherwise = universo

esAptoPendex :: Universo -> Bool
esAptoPendex = any ((< 45) . edad)

energiaTotal :: Universo -> Number
energiaTotal = sumOf energia . filter (conMasDeNHabilidades 1)

conMasDeNHabilidades :: Number -> Personaje -> Bool
conMasDeNHabilidades n = (>) n . length . habilidades

type Gema = Personaje -> Personaje

modificarEnergia :: Number -> Personaje -> Personaje
modificarEnergia valor personaje =
  personaje
    { energia = energia personaje + valor
    }

laMente :: Number -> Gema
laMente valor = modificarEnergia (-valor)

elAlma :: String -> Gema
elAlma habilidad personaje = (modificarEnergia (-10) personaje) { 
    habilidades = (filter (habilidad /=) . habilidades) personaje
}

elEspacio :: String -> Gema
elEspacio planeta personaje = (modificarEnergia (-20) personaje) { planeta = planeta }

elPoder :: Gema
elPoder personaje 
 | conMasDeNHabilidades 3 personaje = personaje { 
    energia = 0
 }
 | otherwise = personaje { 
    energia = 0,
    habilidades = []
 }

elTiempo :: Gema
elTiempo personaje = (modificarEnergia (-50) personaje) { 
    edad = (max 18 . div 2 . edad) personaje
}

laGemaLoca :: Gema -> Gema
laGemaLoca gema = gema . gema

unGuanteleteDeGoma = Guantelete { 
      material  = "goma",
      gemas     = [elTiempo, elAlma "usar Mjolnir", laGemaLoca (elAlma "progamacion en Haskell")]
    }

utilizar :: Personaje -> [Gema] -> Personaje
utilizar = foldr ($)

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa (Guantelete _ [gema]) _ = gema
gemaMasPoderosa (Guantelete _ (gema1 : gema2 : gemas)) personaje
  | (energia . gema1) personaje > (energia . gema2) personaje   = gemaMasPoderosa (Guantelete "" (gema2 : gemas)) personaje
  | otherwise                                                   = gemaMasPoderosa (Guantelete "" (gema1 : gemas)) personaje
