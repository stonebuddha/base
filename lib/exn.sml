structure BaseExn : BASE_EXN =
struct
	open Utils
	infixr 0 $

	exception InvalidArg of string
	exception NotFound of string

	fun toSExp (InvalidArg msg) = SExp.LIST [SExp.SYMBOL $ Atom.atom "InvalidArg", SExp.STRING msg]
		| toSExp (NotFound msg) = SExp.LIST [SExp.SYMBOL $ Atom.atom "NotFound", SExp.STRING msg]
		| toSExp exn = SExp.LIST [SExp.SYMBOL $ Atom.atom (exnName exn), SExp.STRING $ exnMessage exn]
end