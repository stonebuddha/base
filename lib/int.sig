signature BASE_INT_S_COMMON =
sig
	type t


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S0 where type sexpable = t


	(** {2 Intable API} *)

	include BASE_INTABLE where type intable = t


	(** {2 Stringable API} *)

	include BASE_STRINGABLE where type stringable = t


	(** {2 Comparable API} *)

	include BASE_COMPARABLE where type comparable = t


	(** {2 Floatable API} *)

	include BASE_FLOATABLE where type floatable = t


	(** {2 Infix Operators & Constants} *)

	val zero : t
	val one : t
	val minusOne : t
	val + : t * t -> t
	val - : t * t -> t
	val * : t * t -> t

	val pow : t * t -> t
	val ** : t * t -> t
	(** Integer exponentiation. *)

	val neg : t -> t
	val ~ : t -> t

	val /% : t * t -> t
	val % : t * t -> t
	val div : t * t -> t
	val mod : t * t -> t

	val // : t * t -> real


	(** {2 Other Common Functions} *)

	val abs : t -> t

	val succ : t -> t
	val pred : t -> t

	val decr : t ref -> unit
	val incr : t ref -> unit


	(** {2 Conversion Functions} *)

	val fromInt32 : Int32.int -> t
	val toInt32 : t -> Int32.int
	val fromInt64 : Int64.int -> t
	val toInt64 : t -> Int64.int
	val fromLargeInt : LargeInt.int -> t
	val toLargeInt : t -> LargeInt.int
end

signature BASE_INT_S =
sig
	include BASE_INT_S_COMMON

	val numBits : int

	val maxValue : t
	val minValue : t
end