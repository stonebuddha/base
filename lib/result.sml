structure BaseResult : BASE_RESULT =
struct
	datatype ('ok, 'err) t = OK of 'ok | ERROR of 'err

	fun compare cmpOk cmpErr a b =
		case (a, b) of
			(OK a, OK b) => cmpOk a b
		| (OK _, _) => ~1
		| (_, OK _) => 1
		| (ERROR a, ERROR b) => cmpErr a b

	structure Monad = BaseMonad_Make2(
		struct
			type ('a, 'e) monad = ('a, 'e) t

			fun bind f (OK x) = f x
				| bind _ (ERROR e) = ERROR e

			fun return x = OK x
		end)
	open Monad

	fun fail e = ERROR e

	fun isOK (OK _) = true
		| isOK (ERROR _) = false

	fun isERROR (OK _) = false
		| isERROR (ERROR _) = true

	fun getOK (OK x) = SOME x
		| getOK (ERROR _) = NONE

	fun getOKExn (OK x) = x
		| getOKExn (ERROR e) = raise e

	fun getOKOrFail (OK x) = x
		| getOKOrFail (ERROR msg) = raise (Fail msg)

	fun getERROR (OK _) = NONE
		| getERROR (ERROR e) = SOME e

	fun ofOption _ (SOME x) = OK x
		| ofOption e NONE = ERROR e

	fun iterOK f (OK x) = f x
		| iterOK _ (ERROR _) = ()

	fun iterERROR _ (OK _) = ()
		| iterERROR f (ERROR e) = f e

	fun mapOK f (OK x) = OK (f x)
		| mapOK _ (ERROR e) = ERROR e

	fun mapERROR _ (OK x) = OK x
		| mapERROR f (ERROR e) = ERROR (f e)

	fun combine cmbOk cmbErr t1 t2 =
		case (t1, t2) of
			((OK _, ERROR e) | (ERROR e, OK _)) => ERROR e
		| (OK x1, OK x2) => OK (cmbOk x1 x2)
		| (ERROR e1, ERROR e2) => ERROR (cmbErr e1 e2)
end