signature BASE_SEXPABLE_S0 =
sig
	type sexpable

	val fromSExp : SExp.value -> sexpable
	val toSExp : sexpable -> SExp.value
end

signature BASE_SEXPABLE_S1 =
sig
	type 'a sexpable

	val fromSExp : (SExp.value -> 'a) -> SExp.value -> 'a sexpable
	val toSExp : ('a -> SExp.value) -> 'a sexpable -> SExp.value
end

signature BASE_SEXPABLE_S2 =
sig
	type ('a, 'b) sexpable

	val fromSExp : (SExp.value -> 'a) -> (SExp.value -> 'b) -> SExp.value -> ('a, 'b) sexpable
	val toSExp : ('a -> SExp.value) -> ('b -> SExp.value) -> ('a, 'b) sexpable -> SExp.value
end

signature BASE_SEXPABLE_S3 =
sig
	type ('a, 'b, 'c) sexpable

	val fromSExp : (SExp.value -> 'a) -> (SExp.value -> 'b) -> (SExp.value -> 'c) -> SExp.value -> ('a, 'b, 'c) sexpable
	val toSExp : ('a -> SExp.value) -> ('b -> SExp.value) -> ('c -> SExp.value) -> ('a, 'b, 'c) sexpable -> SExp.value
end

signature BASE_SEXP_UTILS =
sig
	val equal : SExp.value * SExp.value -> bool
	val fromExn : exn -> SExp.value
	val printer : SExp.value -> string
end

structure BaseSExpUtils : BASE_SEXP_UTILS =
struct
	open BaseUtils
	infixr 0 $

	val equal = SExp.same

	fun fromExn BadImplementation = SExp.SYMBOL $ Atom.atom "BadImplementation"
		| fromExn (InvalidArg msg) = SExp.LIST [SExp.SYMBOL $ Atom.atom "InvalidArg", SExp.STRING msg]
		| fromExn (NotFound msg) = SExp.LIST [SExp.SYMBOL $ Atom.atom "NotFound", SExp.STRING msg]

	fun printer sexp =
		let
			fun printerForList [] = "()"
				| printerForList [sexp] = "(" ^ printerForVal sexp ^ ")"
				| printerForList (hd :: tl) = (List.foldl (fn (sexp, acc) => acc ^ " " ^ printerForVal sexp) ("(" ^ printerForVal hd) tl) ^ ")"
			and printerForVal sexp =
				case sexp of
					SExp.SYMBOL a => Atom.toString a
				| SExp.LIST sexps => printerForList sexps
				| SExp.BOOL b => if b then "#t" else "#f"
				| SExp.INT i => IntInf.toString i
				| SExp.FLOAT r => Real.toString r
				| SExp.STRING s => "\"" ^ s ^ "\""
		in
			printerForVal sexp
		end
end