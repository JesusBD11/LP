{-# LANGUAGE RecordWildCards #-}    -- per utilitzar fields

import Data.Char (isUpper)
import Data.List (nub, isInfixOf)
import Data.List.Split (splitOn)    -- cal instal·lar: cabal install split
import Data.String.Utils (strip)    -- cal instal·lar: cabal install MissingH
import Data.Maybe (mapMaybe, fromMaybe)

type Programa = [ Regla ]

--data Regla = Regla Atom [ Atom ]


--data Atom = Atom String [ Term ]
--    deriving (Eq, Show)


data Term = Var String | Sym String
   deriving (Eq, Show) 

data Regla = Regla { _cap::Atom, _cos::[ Atom ] }   
	deriving (Eq, Show)
	
data Atom = Atom { _nomPredicat::String, _termes::[ Term ] }
    deriving (Eq, Show)


type Sustitucio = [ (Term, Term) ]

type BaseConeixement = [ Atom ]


--------------------Funciones relacionadas con la construccion del input------------------------


--Construe una regla

buildRegla :: (Atom,[Atom]) -> Regla
buildRegla (a,b) = Regla {_cap = a , _cos = b}

--Separa por espacios un String

splitSpces :: String -> [String]
splitSpces s = splitOn " " s

--Separa el cos del cap de una regla

splitFlecha :: String -> [String]
splitFlecha s = splitOn "=>" s

--Funcion auxiliar que determina si un String empieza por Mayuscula

esMayu :: String -> Bool
esMayu (x:xs) = isUpper x

--Funcion auxiliar que termina si un String empieza por minuscula

noesMayu :: String -> Bool
noesMayu (x:xs)
	 |isUpper x = False
	 |otherwise = True

--Funcion que filtra los Strings que empiezan por Mayuscula (Var)	 

filtrarVariables :: [String] -> [String]
filtrarVariables v = filter (esMayu) v

--Funcion que filtra los Strings que empiezan por minuscula (Sym)	 

filtrarConstantes :: [String] -> [String]
filtrarConstantes v = filter (noesMayu) v

--Se encarga de transfromar cada antecedente a un Atom

organizarAntecedentes :: [String] -> Atom 
organizarAntecedentes s = Atom (head s) terminos
	where     
	  variables = filtrarVariables (tail s)
	  constantes = filtrarConstantes (tail s)
	  x = map Var variables
	  y = map Sym constantes
	  terminos = enlazarterminos x y

--Se encarga de transforar una lista de Strings a un Atom

stringToAtom :: [String] -> Atom 
stringToAtom s = Atom (head s) (map Sym (tail s))

--Separa los antecendetes mediante el &		

splitAntecedentes :: String -> [String]
splitAntecedentes s = splitOn "&" s

aux :: String -> Atom
aux s = stringToAtom $ splitSpces s

--Separa por espacios un antecedente y lo manda a una funcion que lo transformara a un Atom

parareglas :: String -> Atom
parareglas s = organizarAntecedentes $ splitSpces s

--Elimina espacios en blanco de los diferentes Strings de la lista

noWhiteSpace :: [String] -> [String]
noWhiteSpace s = map (strip) s

--Elimina el punto del final de linea 

eliminarPunto :: [String] -> [String]
eliminarPunto l = map (takeWhile (/= '.')) l
 
--Determina si una linea de la entrada es una regla o un fet

conflecha :: String -> Bool
conflecha l 
	|length (splitSpces l) > 3 = True
	|otherwise = False

--Funciones que filtran dependiendo si es un fet o una regla 

individual :: String -> Bool
individual l 
	|length (splitSpces l) <= 3 = True
	|otherwise = False	

es_regla :: [String] -> [String] 
es_regla s = filter (conflecha) s

no_regla :: [String] -> [String] 
no_regla s = filter (individual) s

--Crea una regla a partir de un String

prepararReglas :: String -> Regla
prepararReglas l = buildRegla (capDef,atoms)
	where     
	  particion = splitFlecha l
	  cos = head particion
	  cap = last particion
	  cosSupreme =  noWhiteSpace $ splitAntecedentes cos
	  atoms = map (parareglas) cosSupreme
	  capDef = parareglas $ strip cap

--Crea una regla a partir de un String (fet)

prepararIndividuales :: String -> Regla
prepararIndividuales l = buildRegla (cap,[])
	where
		cap = aux l

--Concatena dos listas de Regla(Programa)

enlazarLista :: [Regla] -> [Regla] -> Programa
enlazarLista a b = (a ++ b)

--Concatena dos terminos

enlazarterminos :: [Term] -> [Term] -> [Term]
enlazarterminos a b = a ++ b

--Funciones auxiliares que separan las preguntas del resto del input -------

getPreguntas :: [String] -> [String]
getPreguntas l = tail (dropWhile (/= "end") (init l))

getAntesdelEnd :: [String] -> [String]
getAntesdelEnd l = takeWhile (/= "end") l

eliminarEnd :: [String] -> [String]
eliminarEnd s = filter (/= "end") s

-------------------------------------------------------------------









------------------------Funciones relacionada con la contruccion de la base de conocimiento-----------------


sustitucioBuida :: Sustitucio
sustitucioBuida = []

--Determina si un termino es un Sym 

isSym :: Term -> Bool
isSym (Sym s) = True
isSym (Var s) = False


--Funciones que unifican dos Atom // el segundo atom siempre es un Atom ground

tratarUnificar :: [Term] -> [Term] -> Sustitucio
tratarUnificar [] [] = []
tratarUnificar (x:a) (y:atomBase)
	|not (isSym x) =  [(x,y)] ++ (tratarUnificar a atomBase)
	|otherwise = tratarUnificar a atomBase                                      


unifica :: Atom -> Atom -> Maybe Sustitucio
unifica a atomBase
		|(_nomPredicat a) /= (_nomPredicat atomBase) = Nothing
		|a == atomBase = Just []
		|(head (_termes a)) == (last (_termes a)) = Nothing
		|(isSym (head (_termes a))) && ((head (_termes a)) /= (head (_termes atomBase))) = Nothing
		|(isSym (last (_termes a))) && ((last (_termes a)) /= (last (_termes atomBase))) = Nothing
		|otherwise = Just (tratarUnificar (_termes a) (_termes atomBase))

-------------------------------------------------------------------------------------------------------------


--Te devuelve True en el caso de que un atom no se encuentre en la base de conocimiento 

atomNorepetido :: BaseConeixement -> Atom -> Bool
atomNorepetido [] a = True
atomNorepetido (x:bc) a
		|x == a = False  
		|otherwise = atomNorepetido bc a

--El contrario de si atomNorepetido

buscarAtom :: BaseConeixement -> Atom -> Bool
buscarAtom [] a = False
buscarAtom (x:bc) a
		|x == a = True  
		|otherwise = buscarAtom bc a

--Funcion que itera sobre un atom aplicando diferentes sustituciones

avaluaAtom :: BaseConeixement -> Atom -> [ Sustitucio ] -> [ Sustitucio ]
avaluaAtom bc atom s = nub $ foldl (++) [] listaAux  --Las sustituciones que encontremos las añadimos a la lista de 
													  --sustituciones que ya teniamos
    where
        listaAux = nub $ map (\s -> mapMaybe (\nueva -> concatena (Just s) (unifica (sustitueix atom s) nueva)) bc) s


--Funcion auxiliar que se encarga de concatenar dos Maybe Susticio

concatena :: Maybe Sustitucio -> Maybe Sustitucio -> Maybe Sustitucio
concatena (Just s) (Just t) = (Just (s ++ t))
concatena  _        _       = Nothing

--Dado un Atom y una posible sustitucion, devuelve ese Atom despues de sustituirlo

sustitueix :: Atom -> Sustitucio -> Atom 
sustitueix a [] = a  --En el caso de que la sustitucion sea vacia, devolvemos el Atom tal cual
sustitueix (Atom pred terms) sust = (Atom pred (newx:newy:[]))
	where 
		term1 = terms !! 0
		term2 = terms !! 1
		newx = fromMaybe term1 (lookup term1 sust)
		newy = fromMaybe term2 (lookup term2 sust)

--Dada una regla del programa, tratamos de generar mas atoms ground y ampliar la base conocimineto

avaluaRegla :: BaseConeixement -> Regla -> BaseConeixement
avaluaRegla bc (Regla cap cos)
		|(length (cos) == 0) && (atomNorepetido bc cap) = bc ++ [cap]
		|otherwise = newbc
	 	where
	        sust  = [[]] --empezamos con la lista vacia y con el primer atom del cos de la regla

	        posiblesSust = foldl (\sust atom -> avaluaAtom bc atom sust) sust cos --iteraremos sobre todos los atoms haciendo sustituciones sobre ellos
	        																	--con la lista de los atoms anteriores
	        
	        newbc = filter (esFet) $ map (\s -> sustitueix cap s) posiblesSust --por ultimo miraremos si las sustituciones que
	        																	--hemos encontrado se pueden sustituir en el cap de la regla
	        																	-- y asi poder incluirla a la base conocimiento


--Funciones que itera sobre toda las reglas de un programa tratando de encontrat mas atoms ground

consequencia :: Programa -> BaseConeixement -> BaseConeixement
consequencia [] bc = bc
consequencia (x:pr) bc = avaluaRegla bc x ++ consequencia pr bc

baseDatos pr kbx = do
	let antigua = kbx 
	let baseNueva = nub $ consequencia pr kbx
	--print antigua
	if antigua /= baseNueva
		then baseDatos pr baseNueva
		else return $ baseNueva

----------------------------------------------------------------------






------------------------------Funciones para resolver las query---------------------------------------------

--Busca aquellas query que se responder con True/False

respuestasYesOrNO :: BaseConeixement -> [Regla] -> [Bool]
respuestasYesOrNO bc [] = [] 
respuestasYesOrNO bc (x:pr)
		|(_nomPredicat (_cap x) == "query") && (length (_termes (_cap x)) == 0) = [buscarAtom bc (head (_cos x))] ++ respuestasYesOrNO bc pr
		|otherwise = respuestasYesOrNO bc pr

--Comprueba que un Atom sea fet

esFet :: Atom -> Bool
esFet (Atom a terms)
	|isSym (head terms) && isSym (last terms) = True 
	|otherwise = False

--Trata de encontrat respuesta a las query con vario antecedentes

avaluaPreguntas :: BaseConeixement -> Regla -> [Sustitucio]
avaluaPreguntas bc (Regla cap cos) = foldl (\s atom -> avaluaAtom bc atom s) [[]] cos

responderPreguntas :: BaseConeixement -> [Regla] -> [Sustitucio]
responderPreguntas bc [] = []
responderPreguntas bc (r:pr) = avaluaPreguntas bc r ++ responderPreguntas bc pr

---------------------------------Funciones auxiliares para printear--------------------------------------------


sacarResp [] = return ()
sacarResp l = do 
	let s = filter (/= []) l
	let a = head s
	print a
	sacarResp $ tail s


printOutput [] = return ()
printOutput output = do 
	let o = head output
	print o 
	printOutput (tail output)	 


---------------Main del programa-----------------------------------------------------------------------------------


main :: IO()
main = do
	contents <- readFile "datos.txt"  ---Nombre del fichero de donde se quiera leer
	let datos = lines contents  --Dividimos por salto de linea
	
	let sin_puntos = eliminarPunto datos  --Eliminamos los de cada linea

	let preguntas = getPreguntas sin_puntos  --Obtenemos las preguntas y las convertimos a reglas
	let preguntasHechas = map (prepararReglas) preguntas
	
	let noPreguntas = getAntesdelEnd sin_puntos --Nos quedamos con las datos para crear la Base de conocimiento

	let reglas = es_regla noPreguntas --Separamos las reglas y las preparamos en formato programa
	let intermedio = map (prepararReglas) reglas

	let noreglas = no_regla noPreguntas --Separamos los fets y los preparamos en modo programa
	let indi = map (prepararIndividuales) noreglas
	
	let programa = enlazarLista indi intermedio --Creamos el programa juntando reglas y fets
	print "Programa:"
	print programa
	--print programa
	let kb0 = []
	baseDef <- baseDatos programa kb0  --Creamos la Base de conocimiento
	print "-----------------------"
	print "Base de datos:"
	print baseDef

	print "------------"
	print "respuestas a las query de true o false:"

 	let res = respuestasYesOrNO baseDef preguntasHechas --respuesta a las preguntas de True/False

 	printOutput res
 	print "------------"
 	print "respuestas del resto de query:"

 	let ey = responderPreguntas baseDef preguntasHechas

 	sacarResp ey
