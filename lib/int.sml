structure BaseInt : BASE_INT =
struct
	open Utils BaseExn
	infixr 0 $

	type t = int

	type sexpable = t

	fun fromSExp (SExp.INT i) = IntInf.toInt i
		| fromSExp _ = raise (InvalidArg "BaseInt.fromSExp")

	fun toSExp i = SExp.INT (IntInf.fromInt i)
end