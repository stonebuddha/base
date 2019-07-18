structure BaseList : BASE_LIST =
struct
	open BaseUtils
	infixr 0 $

	type 'a t = 'a list

	fun compare cmp a b =
		case (a, b) of
			([], []) => 0
		| ([], _) => ~1
		| (_, []) => 1
		| (x :: xs, y :: ys) =>
			let
				val n = cmp (x, y)
			in
				if n = 0 then compare cmp xs ys else n
			end

	type 'a container = 'a t

	fun mem equal t a =
		let
			fun loop [] = false
				| loop (b :: bs) = equal (a, b) orelse loop bs
		in
			loop t
		end

	val length = List.length

	val isEmpty = List.null

	val iter = List.app

	fun fold init f t = List.foldl (fn (e, acc) => f (acc, e)) init t

	val exists = List.exists

	fun forall _ [] = true
		| forall p (x :: xs) = (p x) andalso (forall p xs)

	val find = List.find

	fun findMap f t =
		let
			fun loop [] = NONE
				| loop (x :: xs) =
					case f x of
						NONE => loop xs
					| r as SOME _ => r
		in
			loop t
		end

	fun toList t = t

	val toArray = Array.fromList

	fun count f t = BaseContainer.count fold f t

	fun sum m f t = BaseContainer.sum fold m f t

	fun minElt cmp t = BaseContainer.minElt fold cmp t

	fun maxElt cmp t = BaseContainer.maxElt fold cmp t

	fun foldResult init f t = BaseContainer.foldResult fold init f t

	fun foldUntil init f finish t = BaseContainer.foldUntil fold init f finish t

	structure OrUnequalLengths =
	struct
		datatype 'a t = OK of 'a | UNEQUAL_LENGTHS

		fun compare cmp a b =
			case (a, b) of
				(OK a, OK b) => cmp (a, b)
			| (OK _, _) => ~1
			| (_, OK _) => 1
			| (UNEQUAL_LENGTHS, UNEQUAL_LENGTHS) => 0
	end

	fun ofList l = l

	fun nth l n = SOME $ List.nth (l, n) handle Empty => NONE

	fun nthExn l n = List.nth (l, n) handle Empty => raise Fail ("List.nthExn " ^ Int.toString n ^ " called on list of length " ^ Int.toString (length l))

	fun rev (r as ([] | [_])) = r
		| rev (x :: y :: rest) = List.revAppend (rest, [y, x])

	fun revAppend l1 l2 = List.revAppend (l1, l2)

	fun unorderedAppend [] l = l
		| unorderedAppend l [] = l
		| unorderedAppend l1 l2 = revAppend l1 l2

	fun revMap f l =
		let
			fun aux acc [] = acc
				| aux acc (x :: xs) = aux (f x :: acc) xs
		in
			aux [] l
		end

	fun hd [] = NONE
		| hd (x :: _) = SOME x

	fun tl [] = NONE
		| tl (_ :: xs) = SOME xs

	val hdExn = List.hd

	val tlExn = List.tl

	fun slowAppend l1 l2 = revAppend (rev l1) l2

	fun countAppend l1 l2 count =
		case l2 of
			[] => l1
		| _ :: _ =>
			case l1 of
				[] => l2
			| [x1] => x1 :: l2
			| [x1, x2] => x1 :: x2 :: l2
			| [x1, x2, x3] => x1 :: x2 :: x3 :: l2
			| [x1, x2, x3, x4] => x1 :: x2 :: x3 :: x4 :: l2
			| x1 :: x2 :: x3 :: x4 :: x5 :: tl =>
				x1 :: x2 :: x3 :: x4 :: x5 :: (if count > 1000 then slowAppend tl l2 else countAppend tl l2 (count + 1))

	fun append l1 l2 = countAppend l1 l2 0

	fun slowMap f l = rev (revMap f l)

	fun countMap f l count =
		case l of
			[] => []
		| [x1] => [f x1]
		| [x1, x2] => [f x1, f x2]
		| [x1, x2, x3] => [f x1, f x2, f x3]
		| [x1, x2, x3, x4] => [f x1, f x2, f x3, f x4]
		| x1 :: x2 :: x3 :: x4 :: x5 :: tl =>
			f x1 :: f x2 :: f x3 :: f x4 :: f x5 :: (if count > 1000 then slowMap f tl else countMap f tl (count + 1))

	fun map f l = countMap f l 0

	fun concatMap f l =
		let
			fun aux acc [] = rev acc
				| aux acc (hd :: tl) = aux (revAppend (f hd) acc) tl
		in
			aux [] l
		end

	structure Monad = BaseMonad_Make(
		struct
			type 'a monad = 'a t

			fun bind f x = concatMap f x

			fun return x = [x]
		end)
	type 'a monad = 'a Monad.monad
	val op>>= = Monad.>>=
	val op>>| = Monad.>>|
	val bind = Monad.bind
	val return = Monad.return
	val join = Monad.join
	val ignoreM = Monad.ignoreM
	val all = Monad.all
	val allUnit = Monad.allUnit

	structure Infix =
	struct
		fun op@ (l1, l2) = append l1 l2
	end
end