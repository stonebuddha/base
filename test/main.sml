structure Main : MAIN =
struct
  open SUnit
  infix 9 >: >:: >:::

  fun assertEqualForInt (expected, actual) =
    assertEqual op= (SOME Int.toString) (expected, actual)

  fun testAddition () =
    assertEqualForInt (Base.addition (1, 2), 3)

  fun testSubtraction () =
    assertEqualForInt (Base.subtraction (6, 2), 4)

  fun main (_, _) =
    let
      val suite = "BaseTest" >::: ["Addition" >:: testAddition, "Subtraction" >:: testSubtraction]
      val () = runTestMain suite
    in
      OS.Process.success
    end
end
