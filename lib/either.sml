structure BaseEither : BASE_EITHER =
struct
	open BaseExn

	datatype ('f, 's) t = FIRST of 'f | SECOND of 's

	fun compare cmpF cmpS (a, b) =
			if Cont.phyEq (a, b) then EQUAL
			else
				case (a, b) of
					(FIRST a, FIRST b) => cmpF (a, b)
				| (FIRST _, _) => LESS
				| (_, FIRST _) => GREATER
				| (SECOND a, SECOND b) => cmpS (a, b)

	fun equal eqF eqS (a, b) =
			case (a, b) of
				(FIRST a, FIRST b) => eqF (a, b)
			| (SECOND a, SECOND b) => eqS (a, b)
			| _ => false

	type ('f, 's) equable = ('f, 's) t
	type ('f, 's) sexpable = ('f, 's) t

	fun toSExp forF forS t =
			case t of
				FIRST a => SExp.LIST [SExp.SYMBOL (Atom.atom "FIRST"), forF a]
			| SECOND b => SExp.LIST [SExp.SYMBOL (Atom.atom "SECOND"), forS b]

	fun fromSExp forF forS sexp =
			case sexp of
				SExp.LIST [SExp.SYMBOL tag, content] =>
					if Atom.toString tag = "FIRST" then FIRST (forF content)
					else if Atom.toString tag = "SECOND" then SECOND (forS content)
						else raise (InvalidArg "BaseEither.fromSExp")
			| _ => raise (InvalidArg "BaseEither.fromSExp")
end