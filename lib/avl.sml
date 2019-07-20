structure BaseAvl : BASE_AVL =
struct
	open Utils
	infixr 0 $

	datatype ('k, 'v) t =
		EMPTY
	| NODE of { left : ('k, 'v) t ref, key : 'k, value : 'v ref, height : int ref, right : ('k, 'v) t ref }
	| LEAF of { key : 'k, value : 'v ref }

	val empty = EMPTY

	fun isEmpty EMPTY = true
		| isEmpty _ = false

	fun height EMPTY = 0
		| height (LEAF _) = 1
		| height (NODE {height, ...}) = !height

	fun invariant cmp =
		let
			fun legalLeftKey _ EMPTY = ()
				| legalLeftKey key (LEAF {key = leftKey, ...} | NODE {key=leftKey, ...}) = assert (cmp (leftKey, key) < 0)
			fun legalRightKey _ EMPTY = ()
				| legalRightKey key (LEAF {key = rightKey, ...} | NODE {key=rightKey, ...}) = assert (cmp (rightKey, key) > 0)
			fun inv (EMPTY | LEAF _) = ()
				| inv (NODE {left, key = k, height = h, right, ...}) =
					let
						val hl = height $ !left
						val hr = height $ !right
					in
						inv $ !left;
						inv $ !right;
						legalLeftKey k $ !left;
						legalRightKey k $ !right;
						assert (!h = Int.max (hl, hr) + 1);
						assert (Int.abs (hl - hr) <= 2)
					end
		in
			inv
		end

	fun updateHeights (EMPTY | LEAF _) = raise BadImplementation
		| updateHeights (NODE {left, height = oldHeight, right, ...}) =
			let
				val newHeight = Int.max (height $ !left, height $ !right) + 1
			in
				if newHeight <> !oldHeight then oldHeight := newHeight else ()
			end

	fun balance (t as (EMPTY | LEAF _)) = t
		| balance (t as (NODE {left, right, ...})) =
			let
				val hl = height $ !left
				val hr = height $ !right
			in
				if hl > hr + 2 then
					case !left of
						(EMPTY | LEAF _) => raise BadImplementation
					| NODE {left = leftLeft, right = leftRight, ...} =>
						if (height $ !leftLeft) >= (height $ !leftRight) then
							let
								val () = left := !leftRight
								val () = leftRight := t
								val () = updateHeights t
								val () = updateHeights $ !left
							in
								!left
							end
						else
							case !leftRight of
								(EMPTY | LEAF _) => raise BadImplementation
							| NODE {left = lrLeft, right = lrRight, ...} =>
								let
									val () = leftRight := !lrLeft
									val () = left := !lrRight
									val () = lrRight := t
									val () = lrLeft := !left
									val () = updateHeights $ !left
									val () = updateHeights t;
									val () = updateHeights $ !leftRight
								in
									!leftRight
								end
				else if hr > hl + 2 then
					case !right of
						(EMPTY | LEAF _) => raise BadImplementation
					| NODE {left = rightLeft, right = rightRight, ...} =>
						if (height $ !rightRight) >= (height $ !rightLeft) then
							let
								val () = right := !rightLeft
								val () = rightLeft := t
								val () = updateHeights t
								val () = updateHeights $ !right
							in
								!right
							end
						else
							case !rightLeft of
								(EMPTY | LEAF _) => raise BadImplementation
							| NODE {left = rlLeft, right = rlRight, ...} =>
								let
									val () = rightLeft := !rlRight
									val () = right := !rlLeft
									val () = rlLeft := t
									val () = rlRight := !right
									val () = updateHeights $ !right
									val () = updateHeights t
									val () = updateHeights $ !rightLeft
								in
									!rightLeft
								end
				else
					let
						val () = updateHeights t
					in
						t
					end
			end

	fun setLeft node tree =
		let
			val tree = balance tree
		in
			case node of
				(EMPTY | LEAF _) => raise BadImplementation
			| NODE {left, ...} =>
				(if Cont.phyEq (!left, tree) then () else left := tree; updateHeights node)
		end

	fun setRight node tree =
		let
			val tree = balance tree
		in
			case node of
				(EMPTY | LEAF _) => raise BadImplementation
			| NODE {right, ...} =>
				(if Cont.phyEq (!right, tree) then () else right := tree; updateHeights node)
		end

	fun add {replace, cmp, added} k v t =
		let
			fun aux EMPTY =
					let
						val () = added := true
					in
						LEAF {key = k, value = ref v}
					end
				| aux (t as (LEAF {key = k', value = v'})) =
					let
						val c = cmp (k', k)
					in
						if c = 0 then
							let
								val () = added := false
								val () = if replace then v' := v else ()
							in
								t
							end
						else
							let
								val () = added := true
							in
								if c < 0 then
									NODE { left = ref t, key = k, value = ref v, height = ref 2, right = ref EMPTY }
								else
									NODE { left = ref EMPTY, key = k, value = ref v, height = ref 2, right = ref t }
							end
					end
				| aux (t as (NODE {left, key = k', value = v', right, ...})) =
					let
						val c = cmp (k, k')
					in
						if c = 0 then (added := false; if replace then v' := v else ())
						else if c < 0 then setLeft t (aux $ !left)
						else setRight t (aux $ !right);
						t
					end
		in
			let
				val t = aux t
			in
				if !added then balance t else t
			end
		end

	fun remove {removed, cmp} k t = raise BadImplementation
end