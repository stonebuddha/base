signature BASE =
sig
	exception InvalidArg of string
	exception NotFound of string

	structure Container : BASE_CONTAINER
	structure Int : BASE_INT
	structure List : BASE_LIST
	structure Result : BASE_RESULT
	structure SExpUtils : BASE_SEXP_UTILS
end
