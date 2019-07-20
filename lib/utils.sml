structure Utils =
struct
	exception BadImplementation

	fun op$ (f, x) = f x

	fun assert b = if b then () else raise BadImplementation
end