structure BaseInt : BASE_INT_S where type t = int =
struct
	open Utils BaseExn
	infixr 0 $

	type t = int

	type sexpable = t

	fun fromSExp (SExp.INT i) = (IntInf.toInt i handle Overflow => raise (InvalidArg "BaseInt.fromSExp: out of range"))
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

	val zero = 0
	val one = 1
	val minusOne = ~1

	val numBits = Option.valOf Int.precision

	val maxValue = Option.valOf Int.maxInt

	val minValue = Option.valOf Int.minInt

	type floatable = t

	val toReal = Real.fromInt

	fun fromReal r = Real.toInt IEEEReal.TO_ZERO r handle (Domain | Overflow) => raise (InvalidArg $ "BaseInt.fromReal " ^ Real.toString r ^ " is out of range or NaN")

	fun op// (a, b) = toReal a / toReal b

	fun fromInt32 n = Int32.toInt n handle Overflow => raise (InvalidArg $ "BaseInt.fromInt32 " ^ Int32.toString n ^ " is out of range")

	val toInt32 = Int32.fromInt

	fun fromInt64 n = Int64.toInt n handle Overflow => raise (InvalidArg $ "BaseInt.fromInt64 " ^ Int64.toString n ^ " is out of range")

	val toInt64 = Int64.fromInt

	fun fromLargeInt n = LargeInt.toInt n handle Overflow => raise (InvalidArg $ "BaseInt.fromLargeInt " ^ LargeInt.toString n ^ " is out of range")

	val toLargeInt = LargeInt.fromInt

	val abs = Int.abs

	fun succ n = n + 1

	fun pred n = n - 1

	fun decr r = r := pred (!r)

	fun incr r = r := succ (!r)

	fun pow (base, exponent) =
			if exponent < 0 then raise (InvalidArg "BaseInt.pow: exponent cannot be negative")
			else
				if abs base > 1 andalso exponent > numBits - 1 then raise (InvalidArg "BaseInt.pow: integer overflow")
				else
					let
						val acc = ref 1
						val exp = ref (Word.fromInt exponent)
						val cur = ref base
					in
						while !exp > 0w0 do
							let
								val b = Word.andb (!exp, 0w1) = 0w1
							in
								if b then acc := !acc * !cur else ();
								exp := Word.>> (!exp, 0w1);
								cur := !cur * !cur
							end
						handle Overflow => raise (InvalidArg "BaseInt.pow: integer overflow");
						!acc
					end

	val op** = pow

	val op+ = op Int.+
	val op- = op Int.-
	val op* = op Int.*

	val op~ = op Int.~
	val neg = op Int.~

	val op/% = Int.quot
	val op% = Int.rem
	val op div = op Int.div
	val op mod = op Int.mod

	structure Comparable = BaseComparable_Make(
		struct
			type comparable = t

			val compare = Int.compare

			val toSExp = toSExp
		end)
	open Comparable
end

structure BaseInt32 : BASE_INT_S where type t = Int32.int =
struct
	open Utils BaseExn
	infixr 0 $

	type t = Int32.int

	type sexpable = t

	fun fromSExp (SExp.INT i) = (Int32.fromLarge i handle Overflow => raise (InvalidArg "BaseInt32.fromSExp: out of range"))
		| fromSExp _ = raise (InvalidArg "BaseInt32.fromSExp")

	fun toSExp i = SExp.INT (Int32.toLarge i)

	type intable = t

	fun toInt i = Int32.toInt i handle Overflow => raise (InvalidArg $ "BaseInt32.toInt " ^ Int32.toString i ^ " is out of range")
	fun fromInt i = Int32.fromInt i

	type stringable = t

	fun toString i = Int32.toString i

	fun fromString s =
			case Int32.fromString s of
				SOME i => i
			| NONE => raise (InvalidArg $ "BaseInt32.fromString: " ^ s)

	val zero = fromInt 0
	val one = fromInt 1
	val minusOne = fromInt ~1

	val numBits = Option.valOf Int32.precision

	val maxValue = Option.valOf Int32.maxInt

	val minValue = Option.valOf Int32.minInt

	type floatable = t

	val toReal = Real.fromLargeInt o Int32.toLarge

	fun fromReal r = (Int32.fromLarge $ Real.toLargeInt IEEEReal.TO_ZERO r) handle (Domain | Overflow) => raise (InvalidArg $ "BaseInt32.fromReal " ^ Real.toString r ^ " is out of range or NaN")

	fun op// (a, b) = toReal a / toReal b

	fun fromInt32 n = n
	fun toInt32 n = n

	fun fromInt64 n = (Int32.fromLarge $ Int64.toLarge n) handle Overflow => raise (InvalidArg $ "BaseInt32.fromInt64 " ^ Int64.toString n ^ " is out of range")

	val toInt64 = Int64.fromLarge o Int32.toLarge

	fun fromLargeInt n = Int32.fromLarge n handle Overflow => raise (InvalidArg $ "BaseInt32.fromLargeInt " ^ LargeInt.toString n ^ " is out of range")

	val toLargeInt = Int32.toLarge

	val abs = Int32.abs

	fun succ n = n + one

	fun pred n = n - one

	fun decr r = r := pred (!r)

	fun incr r = r := succ (!r)

	fun pow (base, exponent) =
			if exponent < 0 then raise (InvalidArg "BaseInt32.pow: exponent cannot be negative")
			else
				if abs base > 1 andalso exponent > numBits - 1 then raise (InvalidArg "BaseInt32.pow: integer overflow")
				else
					let
						val acc = ref one
						val exp = ref (Word.fromInt exponent)
						val cur = ref base
					in
						while !exp > 0w0 do
							let
								val b = Word.andb (!exp, 0w1) = 0w1
							in
								if b then acc := !acc * !cur else ();
								exp := Word.>> (!exp, 0w1);
								cur := !cur * !cur
							end
						handle Overflow => raise (InvalidArg "BaseInt32.pow: integer overflow");
						!acc
					end

	val op** = pow

	val op+ = op Int32.+
	val op- = op Int32.-
	val op* = op Int32.*

	val op~ = op Int32.~
	val neg = op Int32.~

	val op/% = Int32.quot
	val op% = Int32.rem
	val op div = op Int32.div
	val op mod = op Int32.mod

	structure Comparable = BaseComparable_Make(
		struct
			type comparable = t

			val compare = Int32.compare

			val toSExp = toSExp
		end)
	open Comparable
end

structure BaseInt64 : BASE_INT_S where type t = Int64.int =
struct
	open Utils BaseExn
	infixr 0 $

	type t = Int64.int

	type sexpable = t

	fun fromSExp (SExp.INT i) = (Int64.fromLarge i handle Overflow => raise (InvalidArg "BaseInt64.fromSExp: out of range"))
		| fromSExp _ = raise (InvalidArg "BaseInt64.fromSExp")

	fun toSExp i = SExp.INT (Int64.toLarge i)

	type intable = t

	fun toInt i = Int64.toInt i handle Overflow => raise (InvalidArg $ "BaseInt64.toInt " ^ Int64.toString i ^ " is out of range")
	fun fromInt i = Int64.fromInt i

	type stringable = t

	fun toString i = Int64.toString i

	fun fromString s =
			case Int64.fromString s of
				SOME i => i
			| NONE => raise (InvalidArg $ "BaseInt64.fromString: " ^ s)

	val zero = fromInt 0
	val one = fromInt 1
	val minusOne = fromInt ~1

	val numBits = Option.valOf Int64.precision

	val maxValue = Option.valOf Int64.maxInt

	val minValue = Option.valOf Int64.minInt

	type floatable = t

	val toReal = Real.fromLargeInt o Int64.toLarge

	fun fromReal r = (Int64.fromLarge $ Real.toLargeInt IEEEReal.TO_ZERO r) handle (Domain | Overflow) => raise (InvalidArg $ "BaseInt64.fromReal " ^ Real.toString r ^ " is out of range or NaN")

	fun op// (a, b) = toReal a / toReal b

	fun fromInt32 n = Int64.fromLarge $ Int32.toLarge n
	fun toInt32 n = (Int32.fromLarge $ Int64.toLarge n) handle Overflow => raise (InvalidArg $ "BaseInt64.toInt32 " ^ Int64.toString n ^ " is out of range")

	fun fromInt64 n = n
	fun toInt64 n = n

	fun fromLargeInt n = Int64.fromLarge n handle Overflow => raise (InvalidArg $ "BaseInt64.fromLargeInt " ^ LargeInt.toString n ^ " is out of range")

	val toLargeInt = Int64.toLarge

	val abs = Int64.abs

	fun succ n = n + one

	fun pred n = n - one

	fun decr r = r := pred (!r)

	fun incr r = r := succ (!r)

	fun pow (base, exponent) =
			if exponent < 0 then raise (InvalidArg "BaseInt32.pow: exponent cannot be negative")
			else
				if abs base > 1 andalso exponent > numBits - 1 then raise (InvalidArg "BaseInt32.pow: integer overflow")
				else
					let
						val acc = ref one
						val exp = ref (Word.fromInt exponent)
						val cur = ref base
					in
						while !exp > 0w0 do
							let
								val b = Word.andb (!exp, 0w1) = 0w1
							in
								if b then acc := !acc * !cur else ();
								exp := Word.>> (!exp, 0w1);
								cur := !cur * !cur
							end
						handle Overflow => raise (InvalidArg "BaseInt32.pow: integer overflow");
						!acc
					end

	val op** = pow

	val op+ = op Int64.+
	val op- = op Int64.-
	val op* = op Int64.*

	val op~ = op Int64.~
	val neg = op Int64.~

	val op/% = Int64.quot
	val op% = Int64.rem
	val op div = op Int64.div
	val op mod = op Int64.mod

	structure Comparable = BaseComparable_Make(
		struct
			type comparable = t

			val compare = Int64.compare

			val toSExp = toSExp
		end)
	open Comparable
end

structure BaseLargeInt : BASE_INT_S_COMMON where type t = LargeInt.int =
struct
	open Utils BaseExn
	infixr 0 $

	type t = LargeInt.int

	type sexpable = t

	fun fromSExp (SExp.INT i) = i
		| fromSExp _ = raise (InvalidArg "BaseLargeInt.fromSExp")

	fun toSExp i = SExp.INT i

	type intable = t

	fun toInt i = LargeInt.toInt i handle Overflow => raise (InvalidArg $ "BaseLargeInt.toInt " ^ LargeInt.toString i ^ " is out of range")
	fun fromInt i = LargeInt.fromInt i

	type stringable = t

	fun toString i = LargeInt.toString i

	fun fromString s =
			case LargeInt.fromString s of
				SOME i => i
			| NONE => raise (InvalidArg $ "BaseLargeInt.fromString: " ^ s)

	val zero = fromInt 0
	val one = fromInt 1
	val minusOne = fromInt ~1

	type floatable = t

	val toReal = Real.fromLargeInt

	fun fromReal r = Real.toLargeInt IEEEReal.TO_ZERO r handle (Domain | Overflow) => raise (InvalidArg $ "BaseLargeInt.fromReal " ^ Real.toString r ^ " is out of range or NaN")

	fun op// (a, b) = toReal a / toReal b

	fun fromInt32 n = Int32.toLarge n
	fun toInt32 n = Int32.fromLarge n handle Overflow => raise (InvalidArg $ "BaseLargeInt.toInt32 " ^ toString n ^ " is out of range")

	fun fromInt64 n = Int64.toLarge n
	fun toInt64 n = Int64.fromLarge n handle Overflow => raise (InvalidArg $ "BaseLargeInt.toInt64 " ^ toString n ^ " is out of range")

	fun fromLargeInt n = n

	fun toLargeInt n = n

	val abs = LargeInt.abs

	fun succ n = n + one

	fun pred n = n - one

	fun decr r = r := pred (!r)

	fun incr r = r := succ (!r)

	val pow = IntInf.pow

	val op** = pow

	val op+ = op LargeInt.+
	val op- = op LargeInt.-
	val op* = op LargeInt.*

	val op~ = op LargeInt.~
	val neg = op LargeInt.~

	val op/% = LargeInt.quot
	val op% = LargeInt.rem
	val op div = op LargeInt.div
	val op mod = op LargeInt.mod

	structure Comparable = BaseComparable_Make(
		struct
			type comparable = t

			val compare = LargeInt.compare

			val toSExp = toSExp
		end)
	open Comparable
end