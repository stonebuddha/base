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

	fun assertEqualForIntList (expected, actual) =
			assertEqual (BList.equal op=) (SOME (printerForSExp o BList.toSExp BInt.toSExp)) (expected, actual)

	fun assertEqualForIntOption (expected, actual) =
			assertEqual (BOption.equal op=) (SOME (printerForSExp o BOption.toSExp BInt.toSExp)) (expected, actual)

	fun assertEqualForBool (expected, actual) =
			assertEqual op= (SOME (fn true => "true" | false => "false")) (expected, actual)

	structure ListTest =
	struct
		val long1 = BList.init (fn i => i + 1) 100000

		val long2 = BList.init (fn i => i + 2) 100000

		val l1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

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
					fun test l1 l2 = BList.revAppend l1 l2
				in
					assertEqualForIntList ([3, 2, 1, 4, 5, 6], test [1, 2, 3] [4, 5, 6]);
					assertEqualForIntList ([4, 5, 6], test [] [4, 5, 6]);
					assertEqualForIntList ([3, 2, 1], test [1, 2, 3] []);
					assertEqualForIntList ([1, 2, 3], test [1] [2, 3]);
					assertEqualForIntList ([2, 1, 3], test [1, 2] [3]);
					let val _ = test long1 long1 handle _ => assertFailure "Stack overflow" in () end
				end

		fun testMap () =
				let in
					assertEqualForIntList (long2, (BList.map (fn x => x + 1) long1) handle _ => assertFailure "Stack overflow");
					assertEqualForIntList (long1, (BList.map (fn x => x) long1) handle _ => assertFailure "Stack overflow");
					assertEqualForIntList (l1, BList.map (fn x => x) l1);
					assertEqualForIntList ([], BList.map (fn x => x) [])
				end

		fun testForall2Exn () =
				let
					val _ = BList.forall2Exn (fn _ => assertFailure "Bad implementation") [] []
				in
					()
				end

		fun testFindMapi () =
				let
					fun test l = BList.findMapi (fn (i, x) => if i = x then SOME (i + x) else NONE) l
				in
					assertEqualForIntOption (SOME 0, test [0, 5, 2, 1, 4]);
					assertEqualForIntOption (SOME 4, test [3, 5, 2, 1, 4]);
					assertEqualForIntOption (SOME 8, test [3, 5, 1, 1, 4]);
					assertEqualForIntOption (NONE, test [3, 5, 1, 1, 2])
				end

		fun testForalli () =
				let
					fun test1 l = BList.foralli (fn _ => false) l
					fun test2 l = BList.foralli (fn (i, x) => i = x) l
				in
					assertEqualForBool (true, test1 []);
					assertEqualForBool (true, test2 [0, 1, 2, 3]);
					assertEqualForBool (false, test2 [0, 1, 3, 3])
				end

		fun testExistsi () =
				let
					fun test1 l = BList.existsi (fn _ => true) l
					fun test2 l = BList.existsi (fn (i, x) => i <> x) l
				in
					assertEqualForBool (false, test1 []);
					assertEqualForBool (false, test2 [0, 1, 2, 3]);
					assertEqualForBool (true, test2 [0, 1, 3, 3])
				end

		fun testAppend () =
				let
					fun test l1 l2 = BList.append l1 l2
				in
					assertEqualForIntList ([1, 2, 3, 4, 5, 6], test [1, 2, 3] [4, 5, 6]);
					assertEqualForIntList ([4, 5, 6], test [] [4, 5, 6]);
					assertEqualForIntList ([1, 2, 3], test [1, 2, 3] []);
					assertEqualForIntList ([1, 2, 3], test [1] [2, 3]);
					assertEqualForIntList ([1, 2, 3], test [1, 2] [3]);
					let val _ = test long1 long1 handle _ => assertFailure "Stack overflow" in () end
				end

		val suite = "List" >::: [
				"findExn" >:: testFindExn,
				"revAppend" >:: testRevAppend,
				"map" >:: testMap,
				"forall2Exn" >:: testForall2Exn,
				"findMapi" >:: testFindMapi,
				"foralli" >:: testForalli,
				"existsi" >:: testExistsi,
				"append" >:: testAppend
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