module Library where

import PdePreludat

data Persona = Persona
  { nombre :: String,
    deuda :: Number,
    felicidad :: Number,
    tieneEsperanza :: Bool,
    estrategia :: Estrategia
  }
  deriving (Show)

type Estrategia = Persona -> Bool

type Pais = [Persona]

tieneMasDeDosVocales :: Pais -> Bool
tieneMasDeDosVocales = any ((>) 2 . length . filter isVowel . nombre)

isVowel :: Char -> Bool
isVowel character = character `elem` "aeiou"

totalDeuda :: Pais -> Number
totalDeuda = sum . filter even . map deuda

type Candidato = Persona -> Persona

yrigoyen :: Candidato
yrigoyen persona =
  persona
    { deuda = deuda persona / 2
    }

alende :: Candidato
alende persona =
  persona
    { tieneEsperanza = True,
      felicidad = felicidad persona * 1.1
    }

alsogaray :: Candidato
alsogaray persona =
  persona
    { tieneEsperanza = False,
      deuda = deuda persona + 100
    }

martinezRaymonda :: Candidato
martinezRaymonda = yrigoyen . alende

vaAVotarA :: [Candidato] -> Persona -> [Candidato]
vaAVotarA [] _ = []
vaAVotarA (candidato : candidatos) persona
  | estrategia persona (candidato persona) = candidato : vaAVotarA candidatos persona
  | otherwise = []

transformarPersona :: [Candidato] -> Persona -> Persona
transformarPersona candidatos persona = (foldr ($) persona . vaAVotarA candidatos) persona