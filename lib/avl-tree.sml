structure BaseAvlTree : BASE_AVL_TREE =
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
					| legalLeftKey key (LEAF {key = leftKey, ...} | NODE {key = leftKey, ...}) = assert (cmp (leftKey, key) = LESS)
				fun legalRightKey _ EMPTY = ()
					| legalRightKey key (LEAF {key = rightKey, ...} | NODE {key = rightKey, ...}) = assert (cmp (rightKey, key) = GREATER)
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
							let in
								left := !leftRight;
								leftRight := t;
								updateHeights t;
								updateHeights $ !left;
								!left
							end
						else
							case !leftRight of
								(EMPTY | LEAF _) => raise BadImplementation
							| NODE {left = lrLeft, right = lrRight, ...} =>
								let in
									leftRight := !lrLeft;
									left := !lrRight;
									lrRight := t;
									lrLeft := !left;
									updateHeights $ !left;
									updateHeights t;
									updateHeights $ !leftRight;
									!leftRight
								end
				else if hr > hl + 2 then
						case !right of
							(EMPTY | LEAF _) => raise BadImplementation
						| NODE {left = rightLeft, right = rightRight, ...} =>
							if (height $ !rightRight) >= (height $ !rightLeft) then
								let in
									right := !rightLeft;
									rightLeft := t;
									updateHeights t;
									updateHeights $ !right;
									!right
								end
							else
								case !rightLeft of
									(EMPTY | LEAF _) => raise BadImplementation
								| NODE {left = rlLeft, right = rlRight, ...} =>
									let in
										rightLeft := !rlRight;
										right := !rlLeft;
										rlLeft := t;
										rlRight := !right;
										updateHeights $ !right;
										updateHeights t;
										updateHeights $ !rightLeft;
										!rightLeft
									end
					else
						let in
							updateHeights t;
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
						let in
							added := true;
							LEAF {key = k, value = ref v}
						end
					| aux (t as (LEAF {key = k', value = v'})) =
						let
							val c = cmp (k', k)
						in
							if c = EQUAL then
								let in
									added := false;
									if replace then v' := v else ();
									t
								end
							else
								let in
									added := true;
									if c = LESS then
										NODE { left = ref t, key = k, value = ref v, height = ref 2, right = ref EMPTY }
									else
										NODE { left = ref EMPTY, key = k, value = ref v, height = ref 2, right = ref t }
								end
						end
					| aux (t as (NODE {left, key = k', value = v', right, ...})) =
						let
							val c = cmp (k, k')
						in
							if c = EQUAL then (added := false; if replace then v' := v else ())
							else if c = LESS then setLeft t (aux $ !left)
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
end