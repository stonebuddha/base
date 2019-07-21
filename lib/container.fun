structure ContinueOrStop =
struct
	datatype ('a, 'b) t = CONTINUE of 'a | STOP of 'b
end

signature BASE_CONTAINER_S0 =
sig
	type container
	type container_elt

	val mem : container -> container_elt -> bool
	(** Checks whether the provided element is in the container. *)

	val length : container -> int
	val isEmpty : container -> bool

	val iter : (container_elt -> unit) -> container -> unit

	val fold : 'accum -> ('accum * container_elt -> 'accum) -> container -> 'accum
	(** [fold init f t] returns [f (... f (f (f (init, e1), e2), e3) ..., en)], where [e1 ... en] are the elements of t. *)

	val foldResult : 'accum -> ('accum * container_elt -> ('accum, 'e) BaseResult.t) -> ('accum, 'e) BaseResult.t
	(** [foldResult init f t] is a short-circuiting version of [fold] that runs in the [Result] monad. *)

	val foldUntil : 'accum -> ('accum * container_elt -> ('accum, 'final) ContinueOrStop.t) -> ('accum -> 'final) -> container -> 'final
	(** [foldUntil init f finish t] is a short-circuiting version of [fold]. *)

	val exists : (container_elt -> bool) -> container -> bool
	(** Returns [true] iff there exists an element that satisfies the predicate. *)

	val forall : (container_elt -> bool) -> container -> bool
	(** Returns [true] iff all elements satisfy the predicate. *)

	val count : (container_elt -> bool) -> container -> int
	(** Returns the number of elements that satisfy the predicate. *)

	val sum : {zero : 'sum, + : 'sum * 'sum -> 'sum} -> (container_elt -> 'sum) -> 'sum
	(** Returns the sum of the transformed elements. *)

	val find : (container_elt -> bool) -> container -> container_elt option
	(** Returns as an option the first element that satisfies the predicate. *)

	val findMap : (container_elt -> 'a option) -> container -> 'a option
	(** Returns the first evaluation of the predicate that returns SOME. *)

	val toList : container -> container_elt list
	val toArray : container -> container_elt array

	val minElt : (container_elt * container_elt -> int) -> container -> container_elt option
	(** Returns a minimum (maximum, resp.) element or [NONE] if the collection is empty. *)

	val maxElt : (container_elt * container_elt -> int) -> container -> container_elt option
end

signature BASE_CONTAINER_S1 =
sig
	type 'a container

	val mem : ('a * 'a -> bool) -> 'a container -> 'a -> bool
	(** Checks whether the provided element is in the container. *)

	val length : 'a container -> int
	val isEmpty : 'a container -> bool
	val iter : ('a -> unit) -> 'a container -> unit

	val fold : 'accum -> ('accum * 'a -> 'accum) -> 'a container -> 'accum
	(** [fold init f t] returns [f (... f (f (f (init, e1), e2), e3) ..., en)], where [e1 ... en] are the elements of t. *)

	val foldResult : 'accum -> ('accum * 'a -> ('accum, 'e) BaseResult.t) -> 'a container -> ('accum, 'e) BaseResult.t
	(** [foldResult init f t] is a short-circuiting version of [fold] that runs in the [Result] monad. *)

	val foldUntil : 'accum -> ('accum * 'a -> ('accum, 'final) ContinueOrStop.t) -> ('accum -> 'final) -> 'a container -> 'final
	(** [foldUntil init f finish t] is a short-circuiting version of [fold]. *)

	val exists : ('a -> bool) -> 'a container -> bool
	(** Returns [true] iff there exists an element that satisfies the predicate. *)

	val forall : ('a -> bool) -> 'a container -> bool
	(** Returns [true] iff all elements satisfy the predicate. *)

	val count : ('a -> bool) -> 'a container -> int
	(** Returns the number of elements that satisfy the predicate. *)

	val sum : {zero : 'sum, + : 'sum * 'sum -> 'sum} -> ('a -> 'sum) -> 'a container -> 'sum
	(** Returns the sum of the transformed elements. *)

	val find : ('a -> bool) -> 'a container -> 'a option
	(** Returns as an option the first element that satisfies the predicate. *)

	val findMap : ('a -> 'b option) -> 'a container -> 'b option
	(** Returns the first evaluation of the predicate that returns SOME. *)

	val toList : 'a container -> 'a list
	val toArray : 'a container -> 'a array

	val minElt : ('a * 'a -> int) -> 'a container -> 'a option
	(** Returns a minimum (maximum, resp.) element or [NONE] if the collection is empty. *)

	val maxElt : ('a * 'a -> int) -> 'a container -> 'a option
end

signature BASE_CONTAINER =
sig
	structure ContinueOrStop :
	sig
		datatype ('a, 'b) t = CONTINUE of 'a | STOP of 'b
	end

	type ('t, 'a, 'accum) fold = 'accum -> ('accum * 'a -> 'accum) -> 't -> 'accum
	type ('t, 'a) iter = ('a -> unit) -> 't -> unit
	type 't length = 't -> int

	(** Generic deinitions of container operations in terms of [fold]. *)
	val iter : ('t, 'a, unit) fold -> ('t, 'a) iter
	val count : ('t, 'a, int) fold -> ('a -> bool) -> 't -> int
	val minElt : ('t, 'a, 'a option) fold -> ('a * 'a -> int) -> 't -> 'a option
	val maxElt : ('t, 'a, 'a option) fold -> ('a * 'a -> int) -> 't -> 'a option
	val length : ('t, 'a, int) fold -> 't -> int
	val toList : ('t, 'a, 'a list) fold -> 't -> 'a list
	val sum : ('t, 'a, 'sum) fold -> {zero : 'sum, + : 'sum * 'sum -> 'sum} -> ('a -> 'sum) -> 't -> 'sum
	val foldResult : ('t, 'a, 'b) fold -> 'b -> ('b * 'a -> ('b , 'e) BaseResult.t) -> 't -> ('b, 'e) BaseResult.t
	val foldUntil : ('t, 'a, 'b) fold -> 'b -> ('b * 'a -> ('b, 'final) ContinueOrStop.t) -> ('b -> 'final) -> 't -> 'final

	(** Generic definitions of container operations in terms of [iter] and [length]. *)
	val isEmpty : ('t, 'a) iter -> 't -> bool
	val exists : ('t, 'a) iter -> ('a -> bool) -> 't -> bool
	val forall : ('t, 'a) iter -> ('a -> bool) -> 't -> bool
	val find : ('t, 'a) iter -> ('a -> bool) -> 't -> 'a option
	val findMap : ('t, 'a) iter -> ('a -> 'b option) -> 't -> 'b option
	val toArray: 't length -> ('t, 'a) iter -> 't -> 'a array
end

structure BaseContainer : BASE_CONTAINER =
struct
	open Utils
	infixr 0 $

	structure ContinueOrStop = ContinueOrStop

	type ('t, 'a, 'accum) fold = 'accum -> ('accum * 'a -> 'accum) -> 't -> 'accum
	type ('t, 'a) iter = ('a -> unit) -> 't -> unit
	type 't length = 't -> int

	fun iter fold f t = fold () (fn ((), a) => f a) t

	fun count fold f t = fold 0 (fn (n, a) => if f a then n + 1 else n) t

	fun sum fold {zero, +} f t = fold zero (fn (n, a) => n + (f a)) t

	fun foldResult fold init f t =
			Cont.callcc (fn ret =>
					BaseResult.OK $
					fold init (fn (acc, item) =>
							case f (acc, item) of
								BaseResult.OK x => x
							| (e as BaseResult.ERROR _) => Cont.throw ret e) t)

	fun foldUntil fold init f finish t =
			Cont.callcc (fn ret =>
					finish $ fold init (fn (acc, item) =>
							case f (acc, item) of
								ContinueOrStop.CONTINUE x => x
							| ContinueOrStop.STOP x => Cont.throw ret x) t)

	fun minElt fold cmp t = fold NONE (fn (acc, elt) =>
					case acc of
						NONE => SOME elt
					| SOME min => if cmp (min, elt) > 0 then SOME elt else acc) t

	fun maxElt fold cmp t = fold NONE (fn (acc, elt) =>
					case acc of
						NONE => SOME elt
					| SOME max => if cmp (max, elt) < 0 then SOME elt else acc) t

	fun length fold c = fold 0 (fn (acc, _) => acc + 1) c

	fun isEmpty (iter : ('t, 'a) iter) c =
			Cont.callcc(fn ret => (iter (fn _ => Cont.throw ret true) c; true))

	fun exists (iter : ('t, 'a) iter) f c =
			Cont.callcc (fn ret => (iter (fn x => if f x then Cont.throw ret true else ()) c; false))

	fun forall (iter : ('t, 'a) iter) f c =
			Cont.callcc (fn ret => (iter (fn x => if not (f x) then Cont.throw ret false else ()) c; true))

	fun find (iter : ('t, 'a) iter) f c =
			Cont.callcc (fn ret => (iter (fn x => if f x then Cont.throw ret (SOME x) else ()) c; NONE))

	fun findMap (iter : ('t, 'a) iter) f c =
			Cont.callcc (fn ret => (iter (fn x => case f x of NONE => () | (res as SOME _) => Cont.throw ret res) c; NONE))

	fun toList fold c = List.rev $ (fold [] (fn (acc, x) => x :: acc) c)

	fun toArray length (iter : ('t, 'a) iter) c =
			let
				val arr = ref NONE
				val idx = ref 0
			in
				iter (fn x =>
						let in
							if !idx = 0 then	arr := SOME (Array.array (length c, x)) else ();
							Array.update (Option.valOf $ !arr, !idx, x);
							idx := !idx + 1
						end) c;
				Option.valOf $ !arr
			end
end