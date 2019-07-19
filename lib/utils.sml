structure BaseUtils =
struct
	exception BadImplementation
	exception InvalidArg of string
	exception NotFound of string

	datatype ('a, 'b) sum = INL of 'a | INR of 'b

	fun op$ (f, x) = f x
end