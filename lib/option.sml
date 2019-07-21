structure BaseOption : BASE_OPTION =
struct
	open Utils BaseExn
	infixr 0 $

	type 'a t = 'a option

	fun equal equal (a, b) =
			if Cont.phyEq (a, b) then true
			else
				case (a, b) of
					(NONE, NONE) => true
				| ((NONE, SOME _) | (SOME _, NONE)) => false
				| (SOME x, SOME y) => equal (x, y)

	type 'a sexpable = 'a t

	fun toSExp _ NONE = SExp.SYMBOL (Atom.atom "NONE")
		| toSExp forContent (SOME x) = SExp.LIST [SExp.SYMBOL (Atom.atom "SOME"), forContent x]

	fun fromSExp forContent sexp =
			case sexp of
				SExp.SYMBOL tag => if Atom.toString tag = "NONE" then NONE else raise (InvalidArg "BaseOption.fromSExp")
			| SExp.LIST [SExp.SYMBOL tag, sexpOfContent] =>
				if Atom.toString tag = "SOME" then SOME (forContent sexpOfContent)
				else raise (InvalidArg "BaseOption.fromSExp")
			| _ => raise (InvalidArg "BaseOption.fromSExp")
end