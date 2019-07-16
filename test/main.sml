structure Main : MAIN =
struct
  open SUnit
  infix 9 >: >:: >:::

  fun assert_equal_int (expected, actual) =
    assert_equal op= (SOME Int.toString) (expected, actual)

  fun test_addition () =
    assert_equal_int (Base.addition (1, 2), 3)

  fun test_subtraction () =
    assert_equal_int (Base.subtraction (6, 2), 5)

  fun main (arg0, argv) =
    let
      val () = Base.say_hello ()
      val suite = "BaseTest" >::: ["Addition" >:: test_addition, "Subtraction"
      >:: test_subtraction]
    in
      OS.Process.success
    end
end
