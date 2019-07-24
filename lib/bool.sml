structure BaseBool : BASE_BOOL =
struct
	open Utils BaseExn
	infixr 0 $

	type t = bool

	type sexpable = t

	fun toSExp b = SExp.BOOL b

	fun fromSExp (SExp.BOOL b) = b
		| fromSExp _ = raise (InvalidArg "BaseBool.fromSExp")

	structure Comparable = BaseComparable_Make(
		struct
			type comparable = t

			fun compare (false, false) = EQUAL
				| compare (false, _) = LESS
				| compare (_, false) = GREATER
				| compare (true, true) = EQUAL

			val toSExp = toSExp
		end)
	open Comparable

	type stringable = t

	fun toString true = "true"
		| toString false = "false"

	fun fromString "true" = true
		| fromString "false" = false
		| fromString s = raise (InvalidArg $ "BaseBool.fromString: expected true or false but got " ^ s)

	type intable = t

	fun toInt true = 1
		| toInt false = 0

	fun fromInt 0 = false
		| fromInt 1 = true
		| fromInt _ = raise (InvalidArg "BaseBool.fromInt")
end