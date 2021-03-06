signature SUNIT =
sig
	exception SUnitFailure of string

	type test_fun = unit -> unit

	datatype test =
		TEST_CASE of test_fun
	| TEST_LIST of test list
	| TEST_LABEL of string * test

	val assertFailure : string -> 'a
	val assertEqual : ('a * 'a -> bool) -> ('a -> string) option -> 'a * 'a -> unit

	val >: : string * test -> test
	val >:: : string * test_fun -> test
	val >::: : string * test list -> test

	datatype node = LIST_ITEM of int | LABEL of string

	type path = node list

	datatype result =
		R_SUCCESS
	| R_FAILURE of path * string

	type runner = (path * test_fun) list -> result list

	val runTestMain : runner option -> test -> unit
end

structure SUnit :> SUNIT =
struct
	fun op$ (f, x) = f x
	infixr 0 $

	exception SUnitFailure of string

	type test_fun = unit -> unit

	datatype test =
		TEST_CASE of test_fun
	| TEST_LIST of test list
	| TEST_LABEL of string * test

	fun assertFailure msg = raise (SUnitFailure msg)

	fun assertEqual equal printerOpt (expected, actual) =
			if equal (expected, actual) then
				()
			else
				let
					val msg =
						case printerOpt of
							SOME printer => "expected: " ^ (printer expected) ^ " but got: " ^ (printer actual)
						| NONE => "not equal"
				in
					raise (SUnitFailure msg)
				end

	val op>: = TEST_LABEL

	fun op>:: (label, testFun) = TEST_LABEL (label, TEST_CASE testFun)

	fun op>::: (label, tests) = TEST_LABEL (label, TEST_LIST tests)

	datatype node = LIST_ITEM of int | LABEL of string

	type path = node list

	datatype result =
		R_SUCCESS
	| R_FAILURE of path * string

	type runner = (path * test_fun) list -> result list

	fun sequentialRunner testCases =
			let
				fun runner (path, f) =
						let
							val () = f ()
						in
							R_SUCCESS
						end
						handle SUnitFailure msg => R_FAILURE (path, msg)
			in
				List.map runner testCases
			end

	fun performTest runner test =
			let
				fun flattenTest (path, acc) test =
						case test of
							TEST_CASE f => (path, f) :: acc
						| TEST_LIST tests => #2 $ List.foldl (fn (t, (cnt, acc)) => (cnt + 1, flattenTest (LIST_ITEM cnt :: path, acc) t)) (0, acc) tests
						| TEST_LABEL (label, t) => flattenTest (LABEL label :: path, acc) t

				val testCases = List.rev $ flattenTest ([], []) test
			in
				runner testCases
			end

	fun runTestMain runnerOpt suite =
			let
				val testResults = performTest (case runnerOpt of SOME runner => runner | NONE => sequentialRunner) suite
				val printerForNode = fn LIST_ITEM cnt => Int.toString cnt | LABEL label => label
				fun printerForPath [] = "[]"
					| printerForPath path =
						let
							val str = List.foldl (fn (node, acc) => printerForNode node ^ ":" ^ acc) (printerForNode (List.hd path)) (List.tl path)
						in
							"[" ^ str ^ "]"
						end
			in
				List.app (fn R_SUCCESS => () | R_FAILURE (path, msg) => print $ (printerForPath path) ^ ": " ^ msg ^ "\n") testResults
			end
end