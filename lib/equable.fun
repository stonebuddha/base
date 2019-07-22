signature BASE_EQUABLE_S0 =
sig
	type equable

	val equal : equable * equable -> bool
end

signature BASE_EQUABLE_S1 =
sig
	type 'a equable

	val equal : ('a * 'a -> bool) -> 'a equable * 'a equable -> bool
end

signature BASE_EQUABLE_S2 =
sig
	type ('a, 'b) equable

	val equal : ('a * 'a -> bool) -> ('b * 'b -> bool) -> ('a, 'b) equable * ('a, 'b) equable -> bool
end