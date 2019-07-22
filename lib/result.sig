signature BASE_RESULT =
sig
	datatype ('ok, 'err) t = OK of 'ok | ERROR of 'err

	val compare : ('ok * 'ok -> order) -> ('err * 'err -> order) -> ('ok, 'err) t * ('ok, 'err) t -> order


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S2 where type ('ok, 'err) sexpable = ('ok, 'err) t


	(** {2 Monad API} *)

	include BASE_MONAD_S2 where type ('a, 'e) monad = ('a, 'e) t


	(** {2 Result-Specific API} *)

	val fail : 'err -> ('ok, 'err) t

	val isOk : ('ok, 'err) t -> bool
	val isError : ('ok, 'err) t -> bool
	val ok : ('ok, 'err) t -> 'ok option
	val okExn : ('ok, exn) t -> 'ok
	val okOrFail : ('ok, string) t -> 'ok
	val error : ('ok, 'err) t -> 'err option
	val ofOption : 'err -> 'ok option -> ('ok, 'err) t
	val iter : ('ok -> unit) -> ('ok, 'err) t -> unit
	val iterError : ('err -> unit) -> ('ok, 'err) t -> unit
	(* val map : ('ok -> 'c) -> ('ok, 'err) t -> ('c, 'err) t *)
	val mapError : ('err -> 'c) -> ('ok, 'err) t -> ('ok, 'c) t

	val combine : ('ok1 * 'ok2 -> 'ok3) -> ('err * 'err -> 'err) -> ('ok1, 'err) t -> ('ok2, 'err) t -> ('ok3, 'err) t
	(** Returns [OK] if both are [OK]. *)

	val toEither : ('ok, 'err) t -> ('ok, 'err) BaseEither.t
	(** [toEither] is useful with [BaseList.partitionMap]. *)

	val tryWith : (unit -> 'a) -> ('a, exn) t
end