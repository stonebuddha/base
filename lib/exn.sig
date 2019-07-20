signature BASE_EXN =
sig
	exception InvalidArg of string
	exception NotFound of string

	val toSExp : exn -> SExp.value
end