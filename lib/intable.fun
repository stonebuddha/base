signature BASE_INTABLE =
sig
	type intable

	val fromInt : int -> intable
	val toInt : intable -> int
end