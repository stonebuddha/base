signature BASE_FLOATABLE =
sig
	type floatable

	val fromReal : real -> floatable
	val toReal : floatable -> real
end