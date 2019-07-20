signature BASE_EITHER =
sig
	datatype ('f, 's) t = FIRST of 'f | SECOND of 's
end