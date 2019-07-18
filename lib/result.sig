signature BASE_RESULT =
sig
	datatype ('ok, 'err) t = OK of 'ok | ERROR of 'err

	val compare : ('ok -> 'ok -> int) -> ('err -> 'err -> int) -> ('ok, 'err) t -> ('ok, 'err) t -> int

	(** {2 Monad API} *)
end