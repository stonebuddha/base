structure Main : MAIN =
struct
	open SUnit
	infix 9 >: >:: >:::

	fun printerForSExp sexp =
		let
			fun printerForList [] = "()"
				| printerForList [sexp] = "(" ^ printerForVal sexp ^ ")"
				| printerForList (hd :: tl) = (List.foldl (fn (sexp, acc) => acc ^ " " ^ printerForVal sexp) ("(" ^ printerForVal hd) tl) ^ ")"
			and printerForVal sexp =
				case sexp of
					SExp.SYMBOL a => Atom.toString a
				| SExp.LIST sexps => printerForList sexps
				| SExp.BOOL b => if b then "#t" else "#f"
				| SExp.INT i => IntInf.toString i
				| SExp.FLOAT r => Real.toString r
				| SExp.STRING s => "\"" ^ s ^ "\""
		in
			printerForVal sexp
		end

	fun assertEqualForSExp (expected, actual) =
		assertEqual SExp.same (SOME printerForSExp) (expected, actual)

	structure ListTest =
	struct
		fun testFindExn () =
			let
				fun printer res = BResult.toSExp BInt.toSExp BExn.toSExp res
				fun test list =
					printer (BResult.tryWith (fn () => BList.findExn (fn x => x < 0) list))
			in
				assertEqualForSExp (printer (BResult.ERROR (BExn.NotFound "BaseList.findExn: not found")), test []);
				assertEqualForSExp (printer (BResult.ERROR (BExn.NotFound "BaseList.findExn: not found")), test [1, 2, 3]);
				assertEqualForSExp (printer (BResult.OK ~1), test [~1, ~2, ~3]);
				assertEqualForSExp (printer (BResult.OK ~2), test [1, ~2, ~3])
			end

		fun testRevAppend () =
			let
				fun printer res = BList.toSExp BInt.toSExp res
			in
				assertEqualForSExp (printer [3, 2, 1, 4, 5, 6], printer (BList.revAppend [1, 2, 3] [4, 5, 6]));
				assertEqualForSExp (printer [4, 5, 6], printer (BList.revAppend [] [4, 5, 6]));
				assertEqualForSExp (printer [3, 2, 1], printer (BList.revAppend [1, 2, 3] []));
				assertEqualForSExp (printer [1, 2, 3], printer (BList.revAppend [1] [2, 3]));
				assertEqualForSExp (printer [2, 1, 3], printer (BList.revAppend [1, 2] [3]))
			end

		val suite = "List" >::: [
			"findExn" >:: testFindExn,
			"revAppend" >:: testRevAppend
		]
	end

	fun main (_, _) =
		let
			val suite = "Base" >::: [
				ListTest.suite
			]
		in
			runTestMain NONE suite;
			OS.Process.success
		end
end