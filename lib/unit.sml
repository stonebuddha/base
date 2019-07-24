structure BaseUnit : BASE_UNIT =
struct
	open BaseExn

	type t = unit

	type sexpable = t

	fun toSExp () = SExp.LIST []

	fun fromSExp (SExp.LIST []) = ()
		| fromSExp _ = raise (InvalidArg "BaseUnit.fromSExp")

	structure Comparable = BaseComparable_Make(
		struct
			type comparable = t

			fun compare ((), ()) = EQUAL

			val toSExp = toSExp
		end)
	open Comparable

	type stringable = t

	fun toString () = "()"

	fun fromString "()" = ()
		| fromString _ = raise (InvalidArg "BaseUnit.fromString: () expected")
end