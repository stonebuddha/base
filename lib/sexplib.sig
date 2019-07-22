signature BASE_SEXP_LIB =
sig
	val compare : SExp.value * SExp.value -> order
	val equal : SExp.value * SExp.value -> bool
	val toString : SExp.value -> string
end