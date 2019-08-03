signature BASE_AVL_TREE =
sig
	type ('k, 'v) t

	val empty : ('k, 'v) t
	val isEmpty : ('k, 'v) t -> bool

	val invariant : ('k * 'k -> order) -> ('k, 'v) t -> unit

	val add : {replace : bool, cmp : 'k * 'k -> order, added : bool ref} -> 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t
end