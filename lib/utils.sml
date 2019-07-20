structure Utils =
struct
	datatype ('a, 'b) sum = INL of 'a | INR of 'b

	fun op$ (f, x) = f x
end