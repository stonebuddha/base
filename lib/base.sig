signature BASE =
sig
	val addition : int * int -> int
	val subtraction : int * int -> int

	structure List : BASE_LIST
	structure Monad : BASE_MONAD
	structure Result : BASE_RESULT
end
