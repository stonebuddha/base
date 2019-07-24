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


	(** {2 Infix Operators & Constants} *)

	val zero : t
	val one : t
	val + : t * t -> t
	val - : t * t -> t
	val * : t * t -> t

	(* val pow : t * t -> t
	val ** : t * t -> t *)
	(** Integer exponentiation. *)

	val neg : t -> t
	val ~ : t -> t

	val /% : t * t -> t
	val % : t * t -> t
	val div : t * t -> t
	val mod : t * t -> t

	val // : t * t -> real

	(* val land : t * t -> t
	val lor : t * t -> t
	val lxor : t * t -> t
	val lsl : t * int -> t
	val asr : t * int -> t *)


	(** {2 Other Common Functions} *)

	(* val abs : t -> t

	val succ : t -> t
	val pred : t -> t

	val decr : t ref -> unit
	val incr : t ref -> unit *)


	(** {2 Bitwise Logical Operations} *)

	(* val bitAnd : t * t -> t
	val bitOr : t * t -> t
	val bitXor : t * t -> t
	val bitNot : t -> t
	val popcount : t -> int *)


	(** {2 Bit-Shifting Operations} *)

	(* val shiftLeft : t * int -> t
	val shiftRight : t * int -> t *)
end

signature BASE_INT_S =
sig
	include BASE_INT_S_COMMON

	val numBits : int

	(* val maxValue : t
	val minValue : t

	val lsr : t * int -> t
	val shiftRightLogical : t * int -> t *)
end

signature BASE_INT =
sig
	include BASE_INT_S where type t = int
end