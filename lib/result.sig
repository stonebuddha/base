signature BASE_RESULT =
sig
	datatype ('ok, 'err) t = OK of 'ok | ERROR of 'err

	val compare : ('ok * 'ok -> int) -> ('err * 'err -> int) -> ('ok, 'err) t * ('ok, 'err) t -> int


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S2 where type ('ok, 'err) sexpable = ('ok, 'err) t


	(** {2 Monad API} *)

	include BASE_MONAD_S2 where type ('a, 'e) monad = ('a, 'e) t


	(** {2 Result-Specific API} *)

	val fail : 'err -> ('ok, 'err) t

	val isOK : ('ok, 'err) t -> bool
	val isERROR : ('ok, 'err) t -> bool
	val getOK : ('ok, 'err) t -> 'ok option
	val getOKExn : ('ok, exn) t -> 'ok
	val getOKOrFail : ('ok, string) t -> 'ok
	val getERROR : ('ok, 'err) t -> 'err option
	val ofOption : 'err -> 'ok option -> ('ok, 'err) t
	val iterOK : ('ok -> unit) -> ('ok, 'err) t -> unit
	val iterERROR : ('err -> unit) -> ('ok, 'err) t -> unit
	val mapOK : ('ok -> 'c) -> ('ok, 'err) t -> ('c, 'err) t
	val mapERROR : ('err -> 'c) -> ('ok, 'err) t -> ('ok, 'c) t

	val combine : ('ok1 * 'ok2 -> 'ok3) -> ('err * 'err -> 'err) -> ('ok1, 'err) t -> ('ok2, 'err) t -> ('ok3, 'err) t
	(** Returns [OK] if both are [OK]. *)

	val tryWith : (unit -> 'a) -> ('a, exn) t
end