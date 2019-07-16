structure SUnit =
struct
  infixr 0 $

  fun op$ (f, x) = f x

  exception SUnit_failure of string

  type test_fun = unit -> unit

  datatype test =
    TestCase of test_fun
  | TestList of test list
  | TestLabel of string * test

  fun assert_equal cmp printer_opt (expected, actual) =
    if cmp (expected, actual) then
      ()
    else
      let
        val msg =
          case printer_opt of
            SOME printer => "expected: " ^ (printer expected) ^ " but got: " ^ (printer actual)
          | NONE => "not equal"
      in
        raise (SUnit_failure msg)
      end

  val op>: = TestLabel

  fun op>:: (label, test_fun) = TestLabel (label, TestCase test_fun)

  fun op>::: (label, tests) = TestLabel (label, TestList tests)

  datatype node = ListItem of int | Label of string

  type path = node list

  datatype result =
    RSuccess
  | RFailure of path * string

  type runner = (path * test_fun) list -> result list

  fun sequential_runner test_cases =
    let
      fun runner (path, f) =
        let
          val () = f ()
        in
          RSuccess
        end
        handle SUnit_failure msg => RFailure (path, msg)
    in
      List.map runner test_cases
    end

  fun perform_test runner test =
    let
      fun flatten_test (path, acc) test =
        case test of
          TestCase f => (path, f) :: acc
        | TestList tests => #2 $ List.foldl (fn (t, (cnt, acc)) => (cnt + 1, flatten_test (ListItem cnt :: path, acc) t)) (0, acc) tests
        | TestLabel (label, t) => flatten_test (Label label :: path, acc) t

      val test_cases = List.rev $ flatten_test ([], []) test
    in
      runner test_cases
    end

  fun run_test_tt_main suite =
    let
      val test_results = perform_test sequential_runner suite
      val printer_node = fn ListItem cnt => Int.toString cnt | Label label => label
      fun printer_path [] = "[]"
        | printer_path path =
          let
            val str = List.foldl (fn (node, acc) => printer_node node ^ "." ^ acc) (printer_node (List.hd path)) (List.tl path)
          in
            "[" ^ str ^ "]"
         end
    in
      List.app (fn RSuccess => () | RFailure (path, msg) => print $ (printer_path path) ^ ": " ^ msg ^ "\n") test_results
    end
end
