signature BASE_LIST =
sig
	type 'a t = 'a list

	val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int

	(** Checks whether the provided element is in the container. *)
	val mem : ('a -> 'a -> bool) -> 'a t -> 'a -> bool

	val length : 'a t -> int

	val isEmpty : 'a t -> bool

	val iter : ('a -> unit) -> 'a t -> unit

	(** [fold init f t] returns [f (... f (f (f (init, e1), e2), e3) ..., en)], where [e1 ... en] are the elements of t. *)
	val fold : 'accum -> ('accum -> 'a -> 'accum) -> 'a t -> 'accum

	(** [foldResult init f t] is a short-circuiting version of [fold] that runs in the [Result] monad. *)

	(** [foldUntil init f finish t] is a short-circuiting version of [fold]. *)

	(** Returns [true] iff there exists an element that satisfies the predicate. *)
	val exists : ('a -> bool) -> 'a t -> bool

	(** Returns [true] iff all elements satisfy the predicate. *)
	val forall : ('a -> bool) -> 'a t -> bool

	(** Returns the number of elements that satisfy the predicate. *)
	val count : ('a -> bool) -> 'a t -> int

	(** Returns the sum of the transformed elements. *)

	(** Returns as an option the first element that satisfies the predicate. *)
	val find : ('a -> bool) -> 'a t -> 'a option

	(** Returns the first evaluation of the predicate that returns SOME. *)
	val findMap : ('a -> 'b option) -> 'a t -> 'b option

	val toList : 'a t -> 'a list

	val toArray: 'a t -> 'a array

	(** Returns a minimum (maximum, resp.) element or [NONE] if the collection is empty. *)
	val minElt : ('a -> 'a -> int) -> 'a t -> 'a option

	val maxElt : ('a -> 'a -> int) -> 'a t -> 'a option

	(** [OrUnequalLengths] is used for functions that take more than one lists and only make sense if all the lists have the same length. *)
	structure OrUnequalLengths :
	sig
		datatype 'a t = OK of 'a | UNEQUAL_LENGTHS

		val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
	end

	val ofList : 'a t -> 'a t

	val nth : 'a t -> int -> 'a option

	(** Returns the n-th element of the list, or raises if the list is too short. *)
	val nthExn : 'a t -> int -> 'a

	(** List reversal. *)
	val rev : 'a t -> 'a t

	(** [revAppend l1 l2] reverses [l1] and concatenates it to [l2]. *)
	val revAppend : 'a t -> 'a t -> 'a t

	(** [unorderedAppend l1 l2] has the same elements as [l1 @ l2], but in some unspecified order. *)
	val unorderedAppend : 'a t -> 'a t -> 'a t

	(** [revMap f l] gives the same result as [List.rev (List.map f l)]. *)

	val hd : 'a t -> 'a option

	val tl : 'a t -> 'a t option

	(** Returns the first element, or raises if the list is empty. *)
	val hdExn : 'a t -> 'a

	(** Returns the list without its first element, or raises if the list is empty. *)
	val tlExn : 'a t -> 'a t
end