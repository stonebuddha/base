structure Main : MAIN =
struct
	open SUnit
	infix 9 >: >:: >:::

	open Base

	fun assertEqualForSExp (expected, actual) =
		assertEqual SExpUtils.equal (SOME SExpUtils.printer) (expected, actual)

	structure ListTest =
	struct
		fun testFindExn () =
			let
				fun printer res = Result.toSExp Int.toSExp SExpUtils.fromExn res
				fun test list =
					printer (Result.tryWith (fn () => List.findExn (fn x => x < 0) list))
			in
				assertEqualForSExp (printer (Result.ERROR (NotFound "BaseList.findExn: not found")), test []);
				assertEqualForSExp (printer (Result.ERROR (NotFound "BaseList.findExn: not found")), test [1, 2, 3]);
				assertEqualForSExp (printer (Result.OK ~1), test [~1, ~2, ~3]);
				assertEqualForSExp (printer (Result.OK ~2), test [1, ~2, ~3])
			end

		val suite = "List" >::: [
			"findExn" >:: testFindExn
		]
	end

	fun main (_, _) =
		let
			val suite = "Base" >::: [
				ListTest.suite
			]
			val () = runTestMain suite
		in
			OS.Process.success
		end
end