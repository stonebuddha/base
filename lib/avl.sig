signature BASE_AVL =
sig
	type ('k, 'v) t

	val empty : ('k, 'v) t
	val isEmpty : ('k, 'v) t -> bool

	val invariant : ('k * 'k -> int) -> ('k, 'v) t -> unit

	val add : {replace : bool, cmp : 'k * 'k -> int, added : bool ref} -> 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t

	(* val remove : {removed : bool ref, cmp : 'k * 'k -> int} -> 'k -> ('k, 'v) t -> ('k, 'v) t *)
end