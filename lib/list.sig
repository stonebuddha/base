signature BASE_LIST =
sig
	type 'a t = 'a list

	val compare : ('a * 'a -> order) -> 'a t * 'a t -> order

	structure Infix :
	sig
		val @ : 'a t * 'a t -> 'a t
	end


	(** {2 Equable API} *)

	include BASE_EQUABLE_S1 where type 'a equable = 'a t


	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S1 where type 'a sexpable = 'a t


	(** {2 Container API} *)

	include BASE_CONTAINER_INDEXED_S1 where type 'a container = 'a t


	(** {2 Monad API} *)

	include BASE_MONAD_S1 where type 'a monad = 'a t


	(** {2 Constructors & Accessors} *)

	val init : (int -> 'a) -> int -> 'a t
	(** Wrapper of the standard [List.tabulate] function. *)

	val cons : 'a -> 'a t -> 'a t

	val nth : 'a t -> int -> 'a option
	val nthExn : 'a t -> int -> 'a
	(** Returns the n-th element of the list, or raises if the list is too short. *)

	val hd : 'a t -> 'a option
	val hdExn : 'a t -> 'a
	(** Returns the first element, or raises if the list is empty. *)

	val tl : 'a t -> 'a t option
	val tlExn : 'a t -> 'a t
	(** Returns the list without its first element, or raises if the list is empty. *)

	val last : 'a list -> 'a option
	(** The final element of list. The exn version will raise if the list is empty. *)
	val lastExn : 'a list -> 'a


	(** {2 Basic Operations} *)

	val revAppend : 'a t -> 'a t -> 'a t
	(** [revAppend l1 l2] reverses [l1] and concatenates it to [l2]. *)

	val rev : 'a t -> 'a t
	(** List reversal. *)

	val foldLeft : 'accum -> ('accum * 'a -> 'accum) -> 'a t -> 'accum
	(** Alias of [fold]. *)
	val foldRight : 'accum -> ('a * 'accum -> 'accum) -> 'a t -> 'accum
	(** Reimplementation of the standard [List.foldr] function. *)

	val mapi : (int * 'a -> 'b) -> 'a t -> 'b t
	(** Like [map], but passes the index as an argument. *)

	val revMap : ('a -> 'b) -> 'a t -> 'b t
	(** [revMap f l] gives the same result as [List.rev (List.map f l)]. *)
	val revMapi : (int * 'a -> 'b) -> 'a t -> 'b t

	val append : 'a t -> 'a t -> 'a t
	(** E.g., [append [1, 2] [3, 4, 5]] is [[1, 2, 3, 4, 5]]. *)

	val filter : ('a -> bool) -> 'a t -> 'a t
	(** [filter f l] returns all the elements of the list [l] tat satisfy the predicate. *)
	val filteri : (int * 'a -> bool) -> 'a t -> 'a t

	val revFilter : ('a -> bool) -> 'a t -> 'a t
	(** Like [List.filter], but reverses the order of the result. *)

	val findExn : ('a -> bool) -> 'a t -> 'a
	(** [findExn f t] returns the first element of [t] that satisfies the predicate. It reaises [NotFound] if there is no such element. *)

	val findMapExn : ('a -> 'b option) -> 'a t -> 'b
	(** Like [findMap], but raises [NotFound] if there is no element that satisfies the predicate. *)
	val findMapiExn : (int * 'a -> 'b option) -> 'a t -> 'b

	val revFilterMap : ('a -> 'b option) -> 'a t -> 'b t
	val revFilterMapi : (int * 'a -> 'b option) -> 'a t -> 'b t

	val filterMap : ('a -> 'b option) -> 'a t -> 'b t
	val filterMapi : (int * 'a -> 'b option) -> 'a t -> 'b t

	val filterOpt : 'a option t -> 'a t
	(** [filterOpt l] is the sublist of [l] containing only elements which are [SOME]. *)

	val revMapAppend : ('a -> 'b) -> 'a t -> 'b t -> 'b t
	(** [revMapAppend f l1 l2] maps [f] over each element, and appends the reversed result to the front of [l2]. *)

	val unorderedAppend : 'a t -> 'a t -> 'a t
	(** [unorderedAppend l1 l2] has the same elements as [l1 @ l2], but in some unspecified order. *)

	val concat : 'a t t -> 'a t
	(** Concatenates a list of lists. *)

	val concatNoOrder : 'a t t -> 'a t
	(** Like [concat], but faster and without preserving any ordering. *)

	val concatMap : ('a -> 'b t) -> 'a t -> 'b t
	(** [concatMap f t] is [concat (map f t)], except that there is no guarantee about the order in which [f] is applied to the elements of [t]. *)
	val concatMapi : (int * 'a -> 'b t) -> 'a t -> 'b t
	(** Like [concatMap], but passes the index as an argument. *)


	(** {2 Partition, Merge, Sort} *)

	val take : int -> 'a t -> 'a t
	val drop : int -> 'a t -> 'a t
	val splitN : int -> 'a t -> ('a t * 'a t)

	val takeWhile : ('a -> bool) -> 'a t -> 'a t
	val dropWhile : ('a -> bool) -> 'a t -> 'a t
	val splitWhile : ('a -> bool) -> 'a t -> 'a t * 'a t

	val dropLast : 'a t -> 'a t option
	(** [dropLast l] drops the last element of [l], returning [NONE] if [l] is empty. *)
	val dropLastExn : 'a t -> 'a t

	val partitionMap : ('a -> ('b, 'c) BaseEither.t) -> 'a t -> ('b t * 'c t)
	(** [partitionMap f t] partitions [t] according to the 2-classifier. *)

	val partitionTF : ('a -> bool) -> 'a t -> ('a t * 'a t)
	(** Reimplementation of the standard [List.partition] function. *)

	val partitionResult : ('ok, 'error) BaseResult.t t -> ('ok t * 'error t)
	(** [partitionResult l] returns a pair of lists [(l1, l2)] where [l1] is the list of all [OK] and [l2] is the list of all [ERROR]. *)

	val merge : ('a * 'a -> order) -> 'a t -> 'a t -> 'a t
	(** Merges two sorted lists. *)

	val sort : ('a * 'a -> order) -> 'a t -> 'a t
	(** [sort] is currently [stableSort]. TODO: implement an efficient sort, e.g., std::sort in C++. *)

	val stableSort : ('a * 'a -> order) -> 'a t -> 'a t
	(** [stableSort] is a wrapper of [ListMergeSort.sort] in SML/NJ libraries. *)

	val dedupAndSort : ('a * 'a -> order) -> 'a t -> 'a t
	(** Returns the given list with duplicates removed and in sorted order. *)

	val isSorted : ('a * 'a -> order) -> 'a t -> bool
	(** [isSorted cmp t] returns [true] iff all adjacent [a1, a2] in [t], [cmp (a1, a2) <= 0]. *)

	val isSortedStrictly : ('a * 'a -> order) -> 'a t -> bool
	(** [isSortedStrictly] is similar to [isSorted], but requires [<] instead of [<=]. *)


	(** {2 Operations on Two Lists} *)

	(** [OrUnequalLengths] is used for functions that take more than one lists and only make sense if all the lists have the same length. *)
	structure OrUnequalLengths :
	sig
		datatype 'a t = OK of 'a | UNEQUAL_LENGTHS

		val compare : ('a * 'a -> int) -> 'a t * 'a t -> int
		val toSExp : ('a -> SExp.value) -> 'a t -> SExp.value
	end

	val iter2 : ('a * 'b -> unit) -> 'a t -> 'b t -> unit OrUnequalLengths.t
	val iter2Exn : ('a * 'b -> unit) -> 'a t -> 'b t -> unit
	(** [iter2 f [a1, ..., an] [b1, ..., bn]] calls in turn [f (a1, b1), ..., f (an, bn)]. The exn version will raise if two lists have different lengths. *)

	val revMap2 : ('a * 'b -> 'c) -> 'a t -> 'b t -> 'c t OrUnequalLengths.t
	val revMap2Exn : ('a * 'b -> 'c) -> 'a t -> 'b t -> 'c t
	(** [revMap2Exn f l1 l2] gives the same result as [List.rev (List.map2Exn f l1 l2)]. *)

	val fold2 : 'accum -> ('accum * 'a * 'b -> 'accum) -> 'a t -> 'b t -> 'accum OrUnequalLengths.t
	val fold2Exn : 'accum -> ('accum * 'a * 'b -> 'accum) -> 'a t -> 'b t -> 'accum
	(** [fold2 init f [b1, ..., bn] [c1, ..., cn]] is [f (... f (f (f (init, b1, c1), b2, c2), b3, c3) ..., bn, cn)]. The exn version will raise if two lists have different lengths. *)

	val forall2 : ('a * 'b -> bool) -> 'a t -> 'b t -> bool OrUnequalLengths.t
	val forall2Exn : ('a * 'b -> bool) -> 'a t -> 'b t -> bool
	(** Like [List.forall], but for a two-argument predicate. *)

	val exists2 : ('a * 'b -> bool) -> 'a t -> 'b t -> bool OrUnequalLengths.t
	val exists2Exn : ('a * 'b -> bool) -> 'a t -> 'b t -> bool
	(** Like [List.exists], but for a two-argument preducate. *)

	val map2 : ('a * 'b -> 'c) -> 'a t -> 'b t -> 'c t OrUnequalLengths.t
	val map2Exn : ('a * 'b -> 'c) -> 'a t -> 'b t -> 'c t
	(** [map2 f [a1, ..., an] [b1, ..., bn]] is [[f (a1, b1), ..., f (an, bn)]]. The exn version will raise if the two lists have diffrent lengths. *)


	(** {2 Lists of Pairs} *)

	val unzip : ('a * 'b) t -> 'a t * 'b t
	(** Alias of the standard [ListPair.unzip] function. *)

	val zip : 'a t -> 'b t -> ('a * 'b) t OrUnequalLengths.t
	val zipExn : 'a t -> 'b t -> ('a * 'b) t

	structure Assoc :
	sig
		type ('a, 'b) t = ('a * 'b) list

		include BASE_SEXPABLE_S2 where type ('a, 'b) sexpable = ('a, 'b) t

		val add : ('a * 'a -> bool) -> ('a, 'b) t -> 'a -> 'b -> ('a, 'b) t

		val find : ('a * 'a -> bool) -> ('a, 'b) t -> 'a -> 'b option

		val findExn : ('a * 'a -> bool) -> ('a, 'b) t -> 'a -> 'b

		val mem : ('a * 'a -> bool) -> ('a, 'b) t -> 'a -> bool

		val remove : ('a * 'a -> bool) -> ('a, 'b) t -> 'a -> ('a, 'b) t

		val map : ('b -> 'c) -> ('a, 'b) t -> ('a, 'c) t

		val inverse : ('a, 'b) t -> ('b, 'a) t
		(** Bijectivity is not guaranteed. *)
	end
end