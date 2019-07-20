structure BaseInt : BASE_INT =
struct
	type t = int

	open BaseUtils
	infixr 0 $

	type sexpable = t

	fun fromSExp (SExp.INT i) = IntInf.toInt i
		| fromSExp _ = raise (InvalidArg "BaseInt.fromSExp")

	fun toSExp i = SExp.INT (IntInf.fromInt i)
end