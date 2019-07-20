structure BaseExn : BASE_EXN =
struct
	open Utils
	infixr 0 $

	exception BadImplementation
	exception InvalidArg of string
	exception NotFound of string

	fun toSExp BadImplementation = SExp.SYMBOL $ Atom.atom "BadImplementation"
		| toSExp (InvalidArg msg) = SExp.LIST [SExp.SYMBOL $ Atom.atom "InvalidArg", SExp.STRING msg]
		| toSExp (NotFound msg) = SExp.LIST [SExp.SYMBOL $ Atom.atom "NotFound", SExp.STRING msg]
		| toSExp _ = raise (InvalidArg "BaseExn.toSExp")
end