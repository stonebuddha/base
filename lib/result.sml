structure BaseResult : BASE_RESULT =
struct
	datatype ('ok, 'err) t = OK of 'ok | ERROR of 'err

	fun compare cmpOk cmpErr a b =
		case (a, b) of
			(OK a, OK b) => cmpOk a b
		| (OK _, _) => ~1
		| (_, OK _) => 1
		| (ERROR a, ERROR b) => cmpErr a b

	structure Monad = BaseMonad.Make2(
		struct
			type ('a, 'e) t = ('a, 'e) t

			fun bind f (OK x) = f x
				| bind f (x as (ERROR _)) = x

			fun return x = OK x
		end)
end