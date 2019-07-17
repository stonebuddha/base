structure Base : BASE =
struct
	fun addition (a, b) = a + b

	fun subtraction (a, b) = a - b

	structure List = BaseList
end
