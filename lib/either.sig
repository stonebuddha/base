signature BASE_EITHER =
sig
	datatype ('f, 's) t = FIRST of 'f | SECOND of 's

	val compare : ('f * 'f -> order) -> ('s * 's -> order) -> ('f, 's) t * ('f, 's) t -> order


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S2 where type ('f, 's) sexpable = ('f, 's) t


	(** {2 Equable API} *)

	include BASE_EQUABLE_S2 where type ('f, 's) equable = ('f, 's) t
end