structure Cont =
struct
	fun callcc f = SMLofNJ.Cont.callcc f

	fun throw k v = SMLofNJ.Cont.throw k v

	fun phyEq (a, b) =
		let
			val pa : Unsafe.Pointer.t = Unsafe.cast a
			val pb : Unsafe.Pointer.t = Unsafe.cast b
		in
			Unsafe.Pointer.compare (pa, pb) = EQUAL
		end
end