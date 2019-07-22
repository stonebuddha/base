structure BaseOption : BASE_OPTION =
struct
	open Utils BaseExn
	infixr 0 $

	type 'a t = 'a option

	fun compare cmp (a, b) =
			if Cont.phyEq (a, b) then EQUAL
			else
				case (a, b) of
					(NONE, NONE) => EQUAL
				| (NONE, _) => LESS
				| (_, NONE) => GREATER
				| (SOME a, SOME b) => cmp (a, b)

	type 'a equable = 'a t

	fun equal equal (a, b) =
			case (a, b) of
				(NONE, NONE) => true
			| (SOME x, SOME y) => equal (x, y)
			| _ => false

	type 'a sexpable = 'a t

	fun toSExp _ NONE = SExp.SYMBOL (Atom.atom "NONE")
		| toSExp forContent (SOME x) = SExp.LIST [SExp.SYMBOL (Atom.atom "SOME"), forContent x]

	fun fromSExp forContent sexp =
			case sexp of
				SExp.SYMBOL tag => if Atom.toString tag = "NONE" then NONE else raise (InvalidArg "BaseOption.fromSExp")
			| SExp.LIST [SExp.SYMBOL tag, sexpOfContent] =>
				if Atom.toString tag = "SOME" then SOME (forContent sexpOfContent)
				else raise (InvalidArg "BaseOption.fromSExp")
			| _ => raise (InvalidArg "BaseOption.fromSExp")

	structure Monad = BaseMonad_Make1(
		struct
			type 'a monad = 'a t

			fun bind _ NONE = NONE
				| bind f (SOME x) = f x

			fun return x = SOME x

			val mapCustom = SOME (fn f => fn m => case m of NONE => NONE | SOME x => SOME (f x))
		end)
	open Monad

	type 'a container = 'a t

	fun mem equal t a =
			case t of
				NONE => false
			| SOME b => equal (a, b)

	fun length NONE = 0
		| length (SOME _) = 1

	fun isEmpty NONE = true
		| isEmpty (SOME _) = false

	fun iter _ NONE = ()
		| iter f (SOME x) = f x

	fun fold init f t =
			case t of
				NONE => init
			| SOME x => f (init, x)

	fun foldResult init f t = BaseContainer.foldResult fold init f t

	fun foldUntil init f t = BaseContainer.foldUntil fold init f t

	fun exists _ NONE = false
		| exists f (SOME x) = f x

	fun forall _ NONE = true
		| forall f (SOME x) = f x

	fun count _ NONE = 0
		| count f (SOME x) = if f x then 1 else 0

	fun sum {zero, + = _} f t =
			case t of
				NONE => zero
			| SOME x => f x

	fun find _ NONE = NONE
		| find f (SOME x) = if f x then SOME x else NONE

	fun findMap _ NONE = NONE
		| findMap f (SOME x) = f x

	fun toList NONE = []
		| toList (SOME x) = [x]

	fun toArray t = Array.fromList $ toList t

	fun minElt _ t = t

	fun maxElt _ t = t

	val isNone = isEmpty

	fun isSome NONE = false
		| isSome (SOME _) = true

	val some = SOME

	fun valueMap default f t =
			case t of
				NONE => default
			| SOME x => f x

	fun call f x =
			case f of
				NONE => ()
			| SOME f => f x

	fun value default t =
			case t of
				NONE => default
			| SOME x => x

	fun valueExn (SOME x) = x
		| valueExn NONE = raise (InvalidArg "BaseOption.valueExn")

	fun both (SOME a) (SOME b) = SOME (a, b)
		| both _ _ = NONE

	fun tryWith f = SOME (f ()) handle _ => NONE

	fun filter _ NONE = NONE
		| filter f (SOME x) = if f x then SOME x else NONE
end