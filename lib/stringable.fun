signature BASE_STRINGABLE =
sig
	type stringable

	val fromString : string -> stringable
	val toString : stringable -> string
end