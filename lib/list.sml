structure BaseList : BASE_LIST =
struct
	open Utils BaseExn
	infixr 0 $

	type 'a t = 'a list

	fun compare cmp (a, b) =
			case (a, b) of
				([], []) => EQUAL
			| ([], _) => LESS
			| (_, []) => GREATER
			| (x :: xs, y :: ys) =>
				let
					val n = cmp (x, y)
				in
					if n = EQUAL then compare cmp (xs, ys) else n
				end

	type 'a equable = 'a t

	fun equal equal (t1, t2) =
			let
				fun loop [] [] = true
					| loop (x :: xs) (y :: ys) = equal (x, y) andalso loop xs ys
					| loop _ _ = false
			in
				loop t1 t2
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

	val forall = List.all

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

		fun compare cmp (a, b) =
				if Cont.phyEq (a, b) then 0
				else
					case (a, b) of
						(OK a, OK b) => cmp (a, b)
					| (OK _, _) => ~1
					| (_, OK _) => 1
					| (UNEQUAL_LENGTHS, UNEQUAL_LENGTHS) => 0

		fun toSExp forOk (OK x) = SExp.LIST [SExp.SYMBOL (Atom.atom "OK"), forOk x]
			| toSExp _ UNEQUAL_LENGTHS = SExp.SYMBOL (Atom.atom "UNEQUAL_LENGTHS")
	end

	fun nth l n = SOME $ List.nth (l, n) handle Subscript => NONE

	fun nthExn l n = List.nth (l, n) handle Subscript => raise InvalidArg ("BaseList.nthExn " ^ Int.toString n ^ " called on list of length " ^ Int.toString (length l))

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

	fun checkLength2 f l1 l2 =
			if length l1 <> length l2 then OrUnequalLengths.UNEQUAL_LENGTHS else OrUnequalLengths.OK (f l1 l2)

	fun checkLength2Exn name l1 l2 =
			let
				val n1 = length l1
				val n2 = length l2
			in
				if n1 <> n2 then
					raise (InvalidArg $ "length mismatch in BaseList." ^ name ^ ": " ^ Int.toString n1 ^ " <> " ^ Int.toString n2)
				else
					()
			end

	fun iter2Ok _ [] [] = ()
		| iter2Ok f (x :: xs) (y :: ys) = let val () = f (x, y) in iter2Ok f xs ys end
		| iter2Ok _ _ _ = raise BadImplementation

	fun iter2 f l1 l2 = checkLength2 (iter2Ok f) l1 l2

	fun iter2Exn f l1 l2 = (checkLength2Exn "iter2Exn" l1 l2; iter2Ok f l1 l2)

	fun revMap2Ok f l1 l2 =
			let
				fun loop acc [] [] = acc
					| loop acc (x :: xs) (y :: ys) = loop (f (x, y) :: acc) xs ys
					| loop _ _ _ = raise BadImplementation
			in
				loop [] l1 l2
			end

	fun revMap2 f l1 l2 = checkLength2 (revMap2Ok f) l1 l2

	fun revMap2Exn f l1 l2 = (checkLength2Exn "revMap2Exn" l1 l2; revMap2Ok f l1 l2)

	fun fold2Ok init f l1 l2 =
			let
				fun aux acc [] [] = acc
					| aux acc (x :: xs) (y :: ys) = aux (f (acc, x, y)) xs ys
					| aux _ _ _ = raise BadImplementation
			in
				aux init l1 l2
			end

	fun fold2 init f l1 l2 = checkLength2 (fold2Ok init f) l1 l2

	fun fold2Exn init f l1 l2 = (checkLength2Exn "fold2Exn" l1 l2; fold2Ok init f l1 l2)

	fun foralli f t =
			let
				fun loop _ [] = true
					| loop i (x :: xs) = f (i, x) andalso loop (i + 1) xs
			in
				loop 0 t
			end

	fun existsi f t =
			let
				fun loop _ [] = false
					| loop i (x :: xs) = f (i, x) orelse loop (i + 1) xs
			in
				loop 0 t
			end

	fun forall2Ok _ [] [] = true
		| forall2Ok f (x :: xs) (y :: ys) = f (x, y) andalso forall2Ok f xs ys
		| forall2Ok _ _ _ = raise BadImplementation

	fun forall2 f l1 l2 = checkLength2 (forall2Ok f) l1 l2

	fun forall2Exn f l1 l2 = (checkLength2Exn "forall2Exn" l1 l2; forall2Ok f l1 l2)

	fun exists2Ok _ [] [] = false
		| exists2Ok f (x :: xs) (y :: ys) = f (x, y) orelse exists2Ok f xs ys
		| exists2Ok _ _ _ = raise BadImplementation

	fun exists2 f l1 l2 = checkLength2 (exists2Ok f) l1 l2

	fun exists2Exn f l1 l2 = (checkLength2Exn "exists2Exn" l1 l2; exists2Ok f l1 l2)

	fun revFilter f t =
			let
				fun loop acc [] = acc
					| loop acc (x :: xs) = if f x then loop (x :: acc) xs else loop acc xs
			in
				loop [] t
			end

	fun filter f t = rev (revFilter f t)

	fun iteri f l =
			let
				val _ = fold 0 (fn (i, x) => let val () = f (i, x) in i + 1 end) l
			in
				()
			end

	fun foldi init f t =
			#2 (fold (0, init) (fn ((i, acc), v) => (i + 1, f (i, acc, v))) t)

	fun filteri f l = rev $ foldi [] (fn (pos, acc, x) => if f (pos, x) then x :: acc else acc) l

	fun partitionMap f t =
			let
				fun loop fst snd [] = (rev fst, rev snd)
					| loop fst snd (x :: xs) =
						case f x of
							BaseEither.FIRST y => loop (y :: fst) snd xs
						| BaseEither.SECOND y => loop fst (y :: snd) xs
			in
				loop [] [] t
			end

	fun partitionTF f t = partitionMap (fn x => if f x then BaseEither.FIRST x else BaseEither.SECOND x) t

	fun partitionResult t = partitionMap (fn BaseResult.OK v => BaseEither.FIRST v | BaseResult.ERROR e => BaseEither.SECOND e) t

	fun splitN n l =
			if n <= 0 then ([], l)
			else
				let
					fun loop n acc t =
							if n = 0 then (rev acc, t)
							else
								case t of
									[] => (l, [])
								| x :: xs => loop (n - 1) (x :: acc) xs
				in
					loop n [] l
				end

	fun take n l =
			if n <= 0 then []
			else
				let
					fun loop n acc t =
							if n = 0 then rev acc
							else
								case t of
									[] => l
								| x :: xs => loop (n - 1) (x :: acc) xs
				in
					loop n [] l
				end

	fun drop n t =
			case t of
				_ :: tl => if n > 0 then drop (n - 1) tl else t
			| _ => t

	fun splitWhile f xs =
			let
				fun loop acc l =
						case l of
							hd :: tl => if (f hd) then loop (hd :: acc) tl else (rev acc, l)
						| _ => (rev acc, l)
			in
				loop [] xs
			end

	fun takeWhile f xs =
			let
				fun loop acc l =
						case l of
							hd :: tl => if (f hd) then loop (hd :: acc) tl else rev acc
						| _ => rev acc
			in
				loop [] xs
			end

	fun dropWhile f t =
			case t of
				hd :: tl => if f hd then dropWhile f tl else t
			| _ => t

	fun stableSort cmp l =
			ListMergeSort.sort (fn (a, b) => cmp (a, b) = GREATER) l

	val sort = stableSort

	fun merge cmp l1 l2 =
			let
				fun loop acc [] l2 = revAppend acc l2
					| loop acc l1 [] = revAppend acc l1
					| loop acc (x :: xs) (y :: ys) =
						if cmp (x, y) <> GREATER then
							loop (x :: acc) xs l2
						else
							loop (y :: acc) l1 ys
			in
				loop [] l1 l2
			end

	fun hd [] = NONE
		| hd (x :: _) = SOME x

	fun tl [] = NONE
		| tl (_ :: xs) = SOME xs

	fun hdExn l = List.hd l handle Empty => raise (InvalidArg "BaseList.hdExn")

	fun tlExn l = List.tl l handle Empty => raise (InvalidArg "BaseList.tlExn")

	fun findi f t =
			let
				fun aux _ [] = NONE
					| aux i (x :: xs) = if f (i, x) then SOME (i, x) else aux (i + 1) xs
			in
				aux 0 t
			end

	fun findExn _ [] = raise (NotFound "BaseList.findExn: not found")
		| findExn f (x :: xs) = if f x then x else findExn f xs

	fun findMapExn f t =
			case findMap f t of
				NONE => raise (NotFound "BaseList.findMapExn: not found")
			| SOME x => x

	fun findMapi f t =
			let
				fun loop _ [] = NONE
					| loop i (x :: xs) =
						case f (i, x) of
							NONE => loop (i + 1) xs
						| res as SOME _ => res
			in
				loop 0 t
			end

	fun findMapiExn f t =
			case findMapi f t of
				NONE => raise (NotFound "BaseList.findMapiExn: not found")
			| SOME res => res

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

	fun op>>| (l, f) = map f l

	fun concatMap f l =
			let
				fun aux acc [] = rev acc
					| aux acc (hd :: tl) = aux (revAppend (f hd) acc) tl
			in
				aux [] l
			end

	fun concatMapi f l =
			let
				fun aux _ acc [] = rev acc
					| aux i acc (hd :: tl) = aux (i + 1) (revAppend (f (i, hd)) acc) tl
			in
				aux 0 [] l
			end

	fun map2Ok f l1 l2 = rev (revMap2Ok f l1 l2)

	fun map2 f l1 l2 = checkLength2 (map2Ok f) l1 l2

	fun map2Exn f l1 l2 = (checkLength2Exn "map2Exn" l1 l2; map2Ok f l1 l2)

	structure Monad = BaseMonad_Make1(
		struct
			type 'a monad = 'a t

			fun bind f x = concatMap f x

			fun return x = [x]

			val mapCustom = SOME map
		end)
	type 'a monad = 'a Monad.monad
	val op>>= = Monad.>>=
	val bind = Monad.bind
	val return = Monad.return
	val join = Monad.join
	val ignoreM = Monad.ignoreM
	val all = Monad.all
	val allUnit = Monad.allUnit

	fun revMapAppend f l1 l2 =
			case l1 of
				[] => l2
			| h :: t => revMapAppend f t (f h :: l2)

	val foldLeft = fold

	fun foldRight init _ [] = init
		| foldRight init f l = fold init (fn (a, b) => f (b, a)) (rev l)

	val unzip = ListPair.unzip

	fun zip l1 l2 = map2 (fn (a, b) => (a, b)) l1 l2

	fun zipExn l1 l2 = (checkLength2Exn "zipExn" l1 l2; map2Ok (fn (a, b) => (a, b)) l1 l2)

	fun revMapi f l =
			let
				fun loop _ acc [] = acc
					| loop i acc (h :: t) = loop (i + 1) (f (i, h) :: acc) t
			in
				loop 0 [] l
			end

	fun mapi f l = rev (revMapi f l)

	fun lastExn [x] = x
		| lastExn (_ :: tl) = lastExn tl
		| lastExn [] = raise (InvalidArg "BaseList.lastExn")

	fun last [x] = SOME x
		| last (_ :: tl) = last tl
		| last [] = NONE

	fun dedupAndSort cmp l = ListMergeSort.uniqueSort cmp l

	fun counti f t =
			foldi 0 (fn (idx, cnt, a) => if f (idx, a) then cnt + 1 else cnt) t

	fun init f n = List.tabulate (n, f) handle Size => raise (InvalidArg $ "BaseList.init " ^ Int.toString n)

	fun revFilterMap f l =
			let
				fun loop acc [] = acc
					| loop acc (x :: xs) =
						case f x of
							NONE => loop acc xs
						| SOME y => loop (y :: acc) xs
			in
				loop [] l
			end

	fun filterMap f l = rev (revFilterMap f l)

	fun revFilterMapi f l =
			let
				fun loop _ acc [] = acc
					| loop i acc (x :: xs) =
						case f (i, x) of
							NONE => loop (i + 1) acc xs
						| SOME y => loop (i + 1) (y :: acc) xs
			in
				loop 0 [] l
			end

	fun filterMapi f l = rev (revFilterMapi f l)

	fun filterOpt l = filterMap (fn x => x) l

	fun concat l = foldRight [] (fn (t, acc) => append t acc) l

	fun concatNoOrder l = fold [] (fn (acc, l) => revAppend l acc) l

	fun cons x l = x :: l

	fun isSorted cmp l =
			ListMergeSort.sorted (fn (a, b) => cmp (a, b) = GREATER) l

	fun isSortedStrictly cmp l =
			ListMergeSort.sorted (fn (a, b) => cmp (a, b) <> LESS) l

	structure Infix =
	struct
		fun op@ (l1, l2) = append l1 l2
	end

	type 'a sexpable = 'a t

	fun fromSExp forElt sexp =
			case sexp of
				SExp.LIST sexps => map forElt sexps
			| _ => raise (InvalidArg "BaseList.fromSExp")

	fun toSExp forElt l = SExp.LIST $ map forElt l

	fun dropLast l =
			case rev l of
				[] => NONE
			| _ :: tl => SOME (rev tl)

	fun dropLastExn l =
			case dropLast l of
				SOME l => l
			| NONE => raise (InvalidArg "BaseList.dropLastExn: empty list")

	structure Assoc =
	struct
		type ('a, 'b) t = ('a * 'b) list

		type ('a, 'b) sexpable = ('a, 'b) t

		val toSExp = fn forA => fn forB => fn t => toSExp (fn (a, b) => SExp.LIST [forA a, forB b]) t

		val fromSExp = fn forA => fn forB => fn sexp => fromSExp (fn (SExp.LIST [a, b]) => (forA a, forB b) | _ => raise (InvalidArg "BaseList.Assoc.fromSExp")) sexp

		val find = fn equal => fn t => fn key =>
						case find (fn (key', _) => equal (key, key')) t of
							NONE => NONE
						| SOME x => SOME (#2 x)

		fun findExn equal t key =
				case find equal t key of
					SOME v => v
				| NONE => raise (NotFound "BaseList.Assoc.findExn: not found")

		fun mem equal t key = Option.isSome $ find equal t key

		fun remove equal t key = filter (fn (key', _) => not (equal (key, key'))) t

		fun add equal t key value = (key, value) :: remove equal t key

		fun inverse t = map (fn (x, y) => (y, x)) t

		val map = fn f => fn t => map (fn (key, value) => (key, f value)) t
	end
end