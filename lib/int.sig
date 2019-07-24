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
end

signature BASE_INT_S =
sig
	include BASE_INT_S_COMMON
end

signature BASE_INT =
sig
	include BASE_INT_S where type t = int
end