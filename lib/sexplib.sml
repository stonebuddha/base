structure BaseSExpLib : BASE_SEXP_LIB =
struct
	fun compare (a, b) =
			if Cont.phyEq (a, b) then EQUAL
			else
				case (a, b) of
					(SExp.SYMBOL a, SExp.SYMBOL b) => Atom.compare (a, b)
				| (SExp.SYMBOL _, _) => LESS
				| (_, SExp.SYMBOL _) => GREATER
				| (SExp.LIST a, SExp.LIST b) => BaseList.compare compare (a, b)
				| (SExp.LIST _, _) => LESS
				| (_, SExp.LIST _) => GREATER
				| (SExp.BOOL a, SExp.BOOL b) => BaseBool.compare (a, b)
				| (SExp.BOOL _, _) => LESS
				| (_, SExp.BOOL _) => GREATER
				| (SExp.INT a, SExp.INT b) => IntInf.compare (a, b)
				| (SExp.INT _, _) => LESS
				| (_, SExp.INT _) => GREATER
				| (SExp.FLOAT a, SExp.FLOAT b) => (* BaseFloat.compare (a, b) *) Real.compare (a, b)
				| (SExp.FLOAT _, _) => LESS
				| (_, SExp.FLOAT _) => GREATER
				| (SExp.STRING a, SExp.STRING b) => (* BaseString.compare (a, b) *) String.compare (a, b)

	fun equal (a, b) = SExp.same (a, b)

	fun toString sexp =
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
end