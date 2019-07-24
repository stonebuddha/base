signature BASE_BOOL =
sig
	type t = bool


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S0 where type sexpable = t


	(** {2 Comprable API} *)

	include BASE_COMPARABLE where type comparable = t


	(** {2 Stringable API} *)

	include BASE_STRINGABLE where type stringable = t


	(** {2 Intable API} *)

	include BASE_INTABLE where type intable = t
end