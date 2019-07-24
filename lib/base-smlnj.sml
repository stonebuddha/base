signature BAVL = BASE_AVL
structure BAvl = BaseAvl

signature BBOOL = BASE_BOOL
structure BBool = BaseBool

signature BCOMPARABLE = BASE_COMPARABLE
functor BComparable_Make = BaseComparable_Make

signature BCONTAINER = BASE_CONTAINER
structure BContainer = BaseContainer

structure BContinueOrStop = BaseContinueOrStop

signature BEITHER = BASE_EITHER
structure BEither = BaseEither

signature BEXN = BASE_EXN
structure BExn = BaseExn

signature BINT = BASE_INT_S
signature BINT_UNBOUNDED = BASE_INT_S_COMMON
structure BInt = BaseInt
structure BInt32 = BaseInt32
structure BInt64 = BaseInt64

signature BLIST = BASE_LIST
structure BList = BaseList

signature BMONAD_S1 = BASE_MONAD_S1
signature BMONAD_S2 = BASE_MONAD_S2
functor BMonad_Make1 = BaseMonad_Make1
functor BMonad_Make2 = BaseMonad_Make2

signature BOPTION = BASE_OPTION
structure BOption = BaseOption

signature BRESULT = BASE_RESULT
structure BResult = BaseResult

signature BSEXP_LIB = BASE_SEXP_LIB
structure BSExpLib = BaseSExpLib

signature BUNIT = BASE_UNIT
structure BUnit = BaseUnit