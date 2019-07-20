signature BASE_OPTION =
sig
	type 'a t = 'a option

	val equal : ('a * 'a -> bool) -> 'a t * 'a t -> bool


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S1 where type 'a sexpable = 'a t
end