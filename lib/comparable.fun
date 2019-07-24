signature BASE_COMPARABLE_INFIX =
sig
	type comparable

	val >= : comparable * comparable -> bool
	val <= : comparable * comparable -> bool
	val == : comparable * comparable -> bool
	val > : comparable * comparable -> bool
	val < : comparable * comparable -> bool
	val != : comparable * comparable -> bool
end

signature BASE_COMPARABLE =
sig
	include BASE_COMPARABLE_INFIX

	val equal : comparable * comparable -> bool
	val compare : comparable * comparable -> order

	val min : comparable -> comparable -> comparable
	val max: comparable -> comparable -> comparable

	val comparator : {compare : comparable * comparable -> order, toSExp : comparable -> SExp.value}
end

functor BaseComparable_Make (T :
	sig
		type comparable

		val compare : comparable * comparable -> order
		val toSExp : comparable -> SExp.value
	end) : BASE_COMPARABLE where type comparable = T.comparable =
struct
	open T

	fun op> (a, b) = compare (a, b) = GREATER
	fun op< (a, b) = compare (a, b) = LESS
	fun op>= (a, b) = compare (a, b) <> LESS
	fun op<= (a, b) = compare (a, b) <> GREATER
	fun op== (a, b) = compare (a, b) = EQUAL
	fun op!= (a, b) = compare (a, b) <> EQUAL
	val equal = op==
	fun min t t' = if t <= t' then t else t'
	fun max t t' = if t >= t' then t else t'
	val comparator = {compare = compare, toSExp = toSExp}
end