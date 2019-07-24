structure BaseInt : BASE_INT =
struct
	open Utils BaseExn
	infixr 0 $

	type t = int

	type sexpable = t

	fun fromSExp (SExp.INT i) = IntInf.toInt i
		| fromSExp _ = raise (InvalidArg "BaseInt.fromSExp")

	fun toSExp i = SExp.INT (IntInf.fromInt i)

	type intable = t

	fun toInt i = i
	fun fromInt i = i

	type stringable = t

	fun toString i = Int.toString i

	fun fromString s =
			case Int.fromString s of
				SOME i => i
			| NONE => raise (InvalidArg $ "BaseInt.fromString: " ^ s)

	structure Comparable = BaseComparable_Make(
		struct
			type comparable = t

			val compare = Int.compare

			val toSExp = toSExp
		end)
	open Comparable
end