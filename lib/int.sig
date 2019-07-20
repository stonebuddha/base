signature BASE_INT_S_COMMON =
sig
	type t


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S0 where type sexpable = t
end

signature BASE_INT_S =
sig
	include BASE_INT_S_COMMON
end

signature BASE_INT =
sig
	include BASE_INT_S where type t = int
end