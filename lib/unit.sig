signature BASE_UNIT =
sig
	type t = unit


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S0 where type sexpable = t


	(** {2 Comparable API} *)

	include BASE_COMPARABLE where type comparable = t


	(** {2 Stringable API} *)

	include BASE_STRINGABLE where type stringable = t
end