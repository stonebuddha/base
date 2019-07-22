structure BaseResult : BASE_RESULT =
struct
	open Utils BaseExn
	infixr 0 $

	datatype ('ok, 'err) t = OK of 'ok | ERROR of 'err

	fun compare cmpOk cmpErr (a, b) =
			if Cont.phyEq (a, b) then EQUAL
			else
				case (a, b) of
					(OK a, OK b) => cmpOk (a, b)
				| (OK _, _) => LESS
				| (_, OK _) => GREATER
				| (ERROR a, ERROR b) => cmpErr (a, b)

	type ('ok, 'err) sexpable = ('ok, 'err) t

	fun fromSExp forOk forErr sexp =
			case sexp of
				SExp.LIST [SExp.SYMBOL tag, sexp'] =>
					if Atom.toString tag = "OK" then OK (forOk sexp')
					else if Atom.toString tag = "ERROR" then ERROR (forErr sexp')
						else raise (InvalidArg "BaseResult.fromSExp")
			| _ => raise (InvalidArg "BaseResult.fromSExp")

	fun toSExp forOk forErr t =
			case t of
				OK x =>
					let
						val sexpOfX = forOk x
					in
						SExp.LIST [SExp.SYMBOL (Atom.atom "OK"), sexpOfX]
					end
			| ERROR e =>
				let
					val sexpOfE = forErr e
				in
					SExp.LIST [SExp.SYMBOL (Atom.atom "ERROR"), sexpOfE]
				end

	structure Monad = BaseMonad_Make2(
		struct
			type ('a, 'e) monad = ('a, 'e) t

			fun bind f (OK x) = f x
				| bind _ (ERROR e) = ERROR e

			fun return x = OK x

			val mapCustom = SOME (fn f => fn m => case m of OK x => OK (f x) | ERROR e => ERROR e)
		end)
	open Monad

	fun fail e = ERROR e

	fun isOk (OK _) = true
		| isOk (ERROR _) = false

	fun isError (OK _) = false
		| isError (ERROR _) = true

	fun ok (OK x) = SOME x
		| ok (ERROR _) = NONE

	fun okExn (OK x) = x
		| okExn (ERROR e) = raise e

	fun okOrFail (OK x) = x
		| okOrFail (ERROR msg) = raise (Fail msg)

	fun error (OK _) = NONE
		| error (ERROR e) = SOME e

	fun ofOption _ (SOME x) = OK x
		| ofOption e NONE = ERROR e

	fun iter f (OK x) = f x
		| iter _ (ERROR _) = ()

	fun iterError _ (OK _) = ()
		| iterError f (ERROR e) = f e

	fun mapError _ (OK x) = OK x
		| mapError f (ERROR e) = ERROR (f e)

	fun combine cmbOk cmbErr t1 t2 =
			case (t1, t2) of
				((OK _, ERROR e) | (ERROR e, OK _)) => ERROR e
			| (OK x1, OK x2) => OK (cmbOk (x1, x2))
			| (ERROR e1, ERROR e2) => ERROR (cmbErr (e1, e2))

	fun tryWith f =
			OK (f ()) handle exn => ERROR exn

	fun toEither (OK x) = BaseEither.FIRST x
		| toEither (ERROR e) = BaseEither.SECOND e
end