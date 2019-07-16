structure SUnit =
struct
  infixr 0 $

  fun op$ (f, x) = f x

  exception SUnit_failure of string

  type test_fun = unit -> unit

  datatype test = TestCase of test_fun
                | TestList of test list
                | TestLabel of string * test

  fun assert_equal cmp printer_opt (expected, actual) =
    if cmp (expected, actual) then
      ()
    else
      let
        val msg =
          case printer_opt of
               SOME printer => "expected: "
               ^ (printer expected)
               ^ " but got: "
               ^ (printer actual)
             | NONE => "not equal"
      in
        raise (SUnit_failure msg)
      end

  val op>: = TestLabel

  fun op>:: (label, test_fun) = TestLabel (label, TestCase test_fun)

  fun op>::: (label, tests) = TestLabel (label, TestList tests)

  fun time_fun f x =
    let
      fun now () = Time.now ()
    in
      let
        val begin_time = now ()
        val res = f x
      in
        (Time.toReal $ Time.- (now (), begin_time), res)
      end
    end
end
