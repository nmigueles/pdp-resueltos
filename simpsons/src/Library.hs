module Library where

import PdePreludat
import Data.List (find)

data Persona = Persona
  { nombre    :: String,
    dinero    :: Number,
    felicidad :: Number
  }
  deriving (Show)

type Actividad = Persona -> Persona


