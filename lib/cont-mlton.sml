structure Cont =
struct
	fun callcc f = MLton.Cont.callcc f

	fun throw k v = MLton.Cont.throw (k, v)

	val phyEq = MLton.eq
end