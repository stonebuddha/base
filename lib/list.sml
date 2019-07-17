structure BaseList : BASE_LIST =
struct
	infixr 0 $
	fun op$ (f, x) = f x

	type 'a t = 'a list

	fun compare cmp a b =
		case (a, b) of
			([], []) => 0
		| ([], _) => ~1
		| (_, []) => 1
		| (x :: xs, y :: ys) =>
			let
				val n = cmp x y
			in
				if n = 0 then compare cmp xs ys else n
			end

	fun mem equal t a =
		let
			fun loop [] = false
				| loop (b :: bs) = equal a b orelse loop bs
		in
			loop t
		end

	val length = List.length

	val isEmpty = List.null

	val iter = List.app

	fun fold init f t = List.foldl (fn (e, acc) => f acc e) init t

	val exists = List.exists

	fun forall p [] = true
		| forall p (x :: xs) = (p x) andalso (forall p xs)

	fun count p [] = 0
		| count p (x :: xs) =
			let
				val cx = if p x then 1 else 0
				val cxs = count p xs
			in
				cx + cxs
			end

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

	fun minElt cmp t =
		let
			fun f acc e =
				case acc of
					NONE => SOME e
				| r as SOME e' => if cmp e e' < 0 then SOME e else r
		in
			fold NONE f t
		end

	fun maxElt cmp t =
		let
			fun f acc e =
				case acc of
					NONE => SOME e
				| r as SOME e' => if cmp e e' > 0 then SOME e else r
		in
			fold NONE f t
		end

	structure OrUnequalLengths =
	struct
		datatype 'a t = OK of 'a | UNEQUAL_LENGTHS

		fun compare cmp a b =
			case (a, b) of
				(OK a, OK b) => cmp a b
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

	fun hd [] = NONE
		| hd (x :: _) = SOME x

	fun tl [] = NONE
		| tl (_ :: xs) = SOME xs

	val hdExn = List.hd

	val tlExn = List.tl
end