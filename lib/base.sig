signature BASE =
sig
	val addition : int * int -> int
	val subtraction : int * int -> int

	exception BadImplementation
	exception InvalidArg of string

	structure Container : BASE_CONTAINER
	structure List : BASE_LIST
	structure Result : BASE_RESULT
end
