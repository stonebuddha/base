structure Cont =
struct
	structure M = SMLofNJ.Cont

	fun callcc f = M.callcc f

	fun throw k v = M.throw k v

	fun phyEq (a, b) =
		let
			val pa : Unsafe.Pointer.t = Unsafe.cast a
			val pb : Unsafe.Pointer.t = Unsafe.cast b
		in
			Unsafe.Pointer.compare (pa, pb) = EQUAL
		end
end