signature BASE_OPTION =
sig
	type 'a t = 'a option

	val compare : ('a * 'a -> order) -> 'a t * 'a t -> order


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S1 where type 'a sexpable = 'a t


	(** {2 Container API} *)

	include BASE_CONTAINER_S1 where type 'a container = 'a t


	(** {2 Equable API} *)

	include BASE_EQUABLE_S1 where type 'a equable = 'a t


	(** {2 Monad API} *)

	include BASE_MONAD_S1 where type 'a monad = 'a t


	(** {2 Option-Specific API} *)

	val isNone : 'a t -> bool
	val isSome : 'a t -> bool

	val some : 'a -> 'a t
	val both : 'a t -> 'b t -> ('a * 'b) t

	val valueMap : 'b -> ('a -> 'b) -> 'a t -> 'b
	(** [valueMap default f] is the same as function [SOME x => f x | NONE => default]. *)

	val value : 'a -> 'a t -> 'a
	(** [value default] is the same as function [SOME x => x | NONE => default]. *)
	val valueExn : 'a t -> 'a

	val call : ('a -> unit) t -> 'a -> unit
	(** [call f x] runs an optional function [f] on the argument. *)

	val filter : ('a -> bool) -> 'a t -> 'a t

	val tryWith : (unit -> 'a) -> 'a t
	(** [tryWith f] returns [SOME x] if [f] returns [x], or [NONE] if [f] raises an exception. *)
end