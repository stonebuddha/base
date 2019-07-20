signature BASE_SEXPABLE_S0 =
sig
	type sexpable

	val fromSExp : SExp.value -> sexpable
	val toSExp : sexpable -> SExp.value
end

signature BASE_SEXPABLE_S1 =
sig
	type 'a sexpable

	val fromSExp : (SExp.value -> 'a) -> SExp.value -> 'a sexpable
	val toSExp : ('a -> SExp.value) -> 'a sexpable -> SExp.value
end

signature BASE_SEXPABLE_S2 =
sig
	type ('a, 'b) sexpable

	val fromSExp : (SExp.value -> 'a) -> (SExp.value -> 'b) -> SExp.value -> ('a, 'b) sexpable
	val toSExp : ('a -> SExp.value) -> ('b -> SExp.value) -> ('a, 'b) sexpable -> SExp.value
end

signature BASE_SEXPABLE_S3 =
sig
	type ('a, 'b, 'c) sexpable

	val fromSExp : (SExp.value -> 'a) -> (SExp.value -> 'b) -> (SExp.value -> 'c) -> SExp.value -> ('a, 'b, 'c) sexpable
	val toSExp : ('a -> SExp.value) -> ('b -> SExp.value) -> ('c -> SExp.value) -> ('a, 'b, 'c) sexpable -> SExp.value
end