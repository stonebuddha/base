structure BaseEither : BASE_EITHER =
struct
	datatype ('f, 's) t = FIRST of 'f | SECOND of 's
end