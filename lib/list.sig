signature BASE_LIST =
sig
	type 'a t = 'a list

	val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int

	(** {2 Container API} *)

	val mem : ('a -> 'a -> bool) -> 'a t -> 'a -> bool
	(** Checks whether the provided element is in the container. *)

	val length : 'a t -> int

	val isEmpty : 'a t -> bool

	val iter : ('a -> unit) -> 'a t -> unit

	val fold : 'accum -> ('accum -> 'a -> 'accum) -> 'a t -> 'accum
	(** [fold init f t] returns [f (... f (f (f (init, e1), e2), e3) ..., en)], where [e1 ... en] are the elements of t. *)

	(** [foldResult init f t] is a short-circuiting version of [fold] that runs in the [Result] monad. *)

	(** [foldUntil init f finish t] is a short-circuiting version of [fold]. *)

	val exists : ('a -> bool) -> 'a t -> bool
	(** Returns [true] iff there exists an element that satisfies the predicate. *)

	val forall : ('a -> bool) -> 'a t -> bool
	(** Returns [true] iff all elements satisfy the predicate. *)

	val count : ('a -> bool) -> 'a t -> int
	(** Returns the number of elements that satisfy the predicate. *)

	(** Returns the sum of the transformed elements. *)

	val find : ('a -> bool) -> 'a t -> 'a option
	(** Returns as an option the first element that satisfies the predicate. *)

	val findMap : ('a -> 'b option) -> 'a t -> 'b option
	(** Returns the first evaluation of the predicate that returns SOME. *)

	val toList : 'a t -> 'a list

	val toArray: 'a t -> 'a array

	val minElt : ('a -> 'a -> int) -> 'a t -> 'a option
	(** Returns a minimum (maximum, resp.) element or [NONE] if the collection is empty. *)

	val maxElt : ('a -> 'a -> int) -> 'a t -> 'a option

	(** {2 Standard API} *)

	(** [OrUnequalLengths] is used for functions that take more than one lists and only make sense if all the lists have the same length. *)
	structure OrUnequalLengths :
	sig
		datatype 'a t = OK of 'a | UNEQUAL_LENGTHS

		val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
	end

	val ofList : 'a t -> 'a t

	val nth : 'a t -> int -> 'a option

	val nthExn : 'a t -> int -> 'a
	(** Returns the n-th element of the list, or raises if the list is too short. *)

	val rev : 'a t -> 'a t
	(** List reversal. *)

	val revAppend : 'a t -> 'a t -> 'a t
	(** [revAppend l1 l2] reverses [l1] and concatenates it to [l2]. *)

	val unorderedAppend : 'a t -> 'a t -> 'a t
	(** [unorderedAppend l1 l2] has the same elements as [l1 @ l2], but in some unspecified order. *)

	(** [revMap f l] gives the same result as [List.rev (List.map f l)]. *)

	val hd : 'a t -> 'a option

	val tl : 'a t -> 'a t option

	val hdExn : 'a t -> 'a
	(** Returns the first element, or raises if the list is empty. *)

	val tlExn : 'a t -> 'a t
	(** Returns the list without its first element, or raises if the list is empty. *)
end