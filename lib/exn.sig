signature BASE_EXN =
sig
	exception BadImplementation
	exception InvalidArg of string
	exception NotFound of string

	val toSExp : exn -> SExp.value
end