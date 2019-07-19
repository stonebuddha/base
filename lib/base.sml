structure Base : BASE =
struct
	fun addition (a, b) = a + b

	fun subtraction (a, b) = a - b

	open BaseUtils

	structure Container = BaseContainer
	structure List = BaseList
	structure Result = BaseResult
end
