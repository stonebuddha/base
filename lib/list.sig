signature BASE_LIST =
sig
	type 'a t = 'a list

	val compare : ('a * 'a -> int) -> 'a t -> 'a t -> int

	(** {2 SExpable API} *)

	include BASE_SEXPABLE_S1 where type 'a sexpable = 'a t

	(** {2 Container API} *)

	include BASE_CONTAINER_S1 where type 'a container = 'a t

	(** {2 Monad API} *)

	include BASE_MONAD_S1 where type 'a monad = 'a t

	(** {2 List-Specific API} *)

	(** [OrUnequalLengths] is used for functions that take more than one lists and only make sense if all the lists have the same length. *)
	structure OrUnequalLengths :
	sig
		datatype 'a t = OK of 'a | UNEQUAL_LENGTHS

		val compare : ('a * 'a -> int) -> 'a t -> 'a t -> int
		val toSExp : ('a -> SExp.value) -> 'a t -> SExp.value
	end

	val ofList : 'a t -> 'a t
	(** [ofList] is the identity function. *)

	val nth : 'a t -> int -> 'a option

	val nthExn : 'a t -> int -> 'a
	(** Returns the n-th element of the list, or raises if the list is too short. *)

	val rev : 'a t -> 'a t
	(** List reversal. *)

	val revAppend : 'a t -> 'a t -> 'a t
	(** [revAppend l1 l2] reverses [l1] and concatenates it to [l2]. *)

	val unorderedAppend : 'a t -> 'a t -> 'a t
	(** [unorderedAppend l1 l2] has the same elements as [l1 @ l2], but in some unspecified order. *)

	val revMap : ('a -> 'b) -> 'a t -> 'b t
	(** [revMap f l] gives the same result as [List.rev (List.map f l)]. *)

	val iter2Exn : ('a * 'b -> unit) -> 'a t -> 'b t -> unit
	(** [iter2 f [a1, ..., an] [b1, ..., bn]] calls in turn [f (a1, b1), ..., f (an, bn)]. The exn version will raise if two lists have different lengths. *)

	val iter2 : ('a * 'b -> unit) -> 'a t -> 'b t -> unit OrUnequalLengths.t

	val revMap2Exn : ('a * 'b -> 'c) -> 'a t -> 'b t -> 'c t
	(** [revMap2Exn f l1 l2] gives the same result as [List.rev (List.map2Exn f l1 l2)]. *)

	val revMap2 : ('a * 'b -> 'c) -> 'a t -> 'b t -> 'c t OrUnequalLengths.t

	val fold2Exn : 'accum -> ('accum * 'a * 'b -> 'accum) -> 'a t -> 'b t -> 'accum
	(** [fold2 init f [b1, ..., bn] [c1, ..., cn]] is [f (... f (f (f (init, b1, c1), b2, c2), b3, c3) ..., bn, cn)]. The exn version will raise if two lists have different lengths. *)

	val fold2 : 'accum -> ('accum * 'a * 'b -> 'accum) -> 'a t -> 'b t -> 'accum OrUnequalLengths.t

	val foralli : (int * 'a -> bool) -> 'a t -> bool
	(** Like [List.forall], but passes the index as an argument. *)

	val forall2Exn : ('a * 'b -> bool) -> 'a t -> 'b t -> bool
	(** Like [List.forall], but for a two-argument predicate. *)

	val forall2 : ('a * 'b -> bool) -> 'a t -> 'b t -> bool OrUnequalLengths.t

	val existsi : (int * 'a -> bool) -> 'a t -> bool
	(** Like [List.exists], but passes the index as an argument. *)

	val exists2Exn : ('a * 'b -> bool) -> 'a t -> 'b t -> bool
	(** Like [List.exists], but for a two-argument preducate. *)

	val exists2 : ('a * 'b -> bool) -> 'a t -> 'b t -> bool OrUnequalLengths.t

	val filter : ('a -> bool) -> 'a t -> 'a t
	(** [filter f l] returns all the elements of the list [l] tat satisfy the predicate. *)

	val revFilter : ('a -> bool) -> 'a t -> 'a t
	(** Like [List.filter], but reverses the order of the result. *)

	val filteri : (int * 'a -> bool) -> 'a t -> 'a t

	val partitionMap : ('a -> ('b, 'c) BaseUtils.sum) -> 'a t -> ('b t * 'c t)
	(** [partitionMap f t] partitions [t] according to the 2-classifier. *)

	(** [partition3Map] *)

	val partitionTF : ('a -> bool) -> 'a t -> ('a t * 'a t)
	(** Reimplementation of the standard [List.partition] function. *)

	val partitionResult : ('ok, 'error) BaseResult.t t -> ('ok t * 'error t)
	(** [partitionResult l] returns a pair of lists [(l1, l2)] where [l1] is the list of all [OK] and [l2] is the list of all [ERROR]. *)

	val splitN : int -> 'a t -> ('a t * 'a t)

	val sort : ('a * 'a -> int) -> 'a t -> 'a t
	(** [sort] is currently [stableSort]. TODO: implement an efficient sort, e.g., std::sort in C++. *)

	val stableSort : ('a * 'a -> int) -> 'a t -> 'a t
	(** [stableSort] is a wrapper of [ListMergeSort.sort] in SML/NJ libraries. *)

	val merge : ('a * 'a -> int) -> 'a t -> 'a t -> 'a t
	(** Merges two sorted lists. *)

	val hd : 'a t -> 'a option
	val tl : 'a t -> 'a t option

	val hdExn : 'a t -> 'a
	(** Returns the first element, or raises if the list is empty. *)

	val tlExn : 'a t -> 'a t
	(** Returns the list without its first element, or raises if the list is empty. *)

	val findi : (int * 'a -> bool) -> 'a t -> (int * 'a) option
	(** [findi] *)

	val findExn : ('a -> bool) -> 'a t -> 'a
	(** [findExn f t] returns the first element of [t] that satisfies the predicate. It reaises [NotFound] if there is no such element. *)

	val findMapExn : ('a -> 'b option) -> 'a t -> 'b
	(** Like [findMap], but raises [NotFound] if there is no element that satisfies the predicate. *)

	val findMapi : (int * 'a -> 'b option) -> 'a t -> 'b option
	(** Like [findMap], but passes the index as an argument. *)

	val findMapiExn : (int * 'a -> 'b option) -> 'a t -> 'b
	(** [findMapiExn] *)

	val append : 'a t -> 'a t -> 'a t
	(** E.g., [append [1, 2] [3, 4, 5]] is [[1, 2, 3, 4, 5]]. *)

	(** [foldingMap] *)

	(** [foldingMapi] *)

	(** [foldMap] *)

	(** [foldMapi] *)

	val concatMap : ('a -> 'b t) -> 'a t -> 'b t
	(** [concatMap f t] is [concat (map f t)], except that there is no guarantee about the order in which [f] is applied to the elements of [t]. *)

	val concatMapi : (int * 'a -> 'b t) -> 'a t -> 'b t
	(** Like [concatMap], but passes the index as an argument. *)

	val map2Exn : ('a * 'b -> 'c) -> 'a t -> 'b t -> 'c t
	(** [map2 f [a1, ..., an] [b1, ..., bn]] is [[f (a1, b1), ..., f (an, bn)]]. The exn version will raise if the two lists have diffrent lengths. *)

	val map2 : ('a * 'b -> 'c) -> 'a t -> 'b t -> 'c t OrUnequalLengths.t

	(** [revMap3Exn] *)

	(** [revMap3] *)

	(** [map3Exn] *)

	(** [map3] *)

	val revMapAppend : ('a -> 'b) -> 'a t -> 'b t -> 'b t
	(** [revMapAppend f l1 l2] maps [f] over each element, and appends the reversed result to the front of [l2]. *)

	val foldRight : 'accum -> ('a * 'accum -> 'accum) -> 'a t -> 'accum
	(** Reimplementation of the standard [List.foldr] function. *)

	val foldLeft : 'accum -> ('accum * 'a -> 'accum) -> 'a t -> 'accum
	(** Alias of [fold]. *)

	val unzip : ('a * 'b) t -> 'a t * 'b t
	(** Alias of the standard [ListPair.unzip] function. *)

	(** [unzip3] *)

	val zip : 'a t -> 'b t -> ('a * 'b) t OrUnequalLengths.t

	val zipExn : 'a t -> 'b t -> ('a * 'b) t

	val mapi : (int * 'a -> 'b) -> 'a t -> 'b t
	(** Like [map], but passes the index as an argument. *)

	val revMapi : (int * 'a -> 'b) -> 'a t -> 'b t

	val iteri : (int * 'a -> unit) -> 'a t -> unit
	(** Like [List.iter], but passes the index as an argument. *)

	val foldi : 'accum -> (int * 'accum * 'a -> 'accum) -> 'a t -> 'accum
	(** Like [List.fold], but passes the index as an argument. *)

	(** [reduceExn] *)

	(** [reduce] *)

	(** [reduceBalanced] *)

	(** [reduceBalancedExn] *)

	(** [group] *)

	(** [groupi] *)

	(** [chunksOf] *)

	val last : 'a list -> 'a option
	(** The final element of list. The exn version will raise if the list is empty. *)

	val lastExn : 'a list -> 'a
	(** [lastExn] *)

	(** [isPrefix] *)

	(** [findConsecutiveDuplicates] *)

	(** [removeConsecutiveDuplicates] *)

	val dedupAndSort : ('a * 'a -> int) -> 'a t -> 'a t
	(** Returns the given list with duplicates removed and in sorted order. *)

	(** [findADup] *)

	(** [containsDup] *)

	(** [findAllDups] *)

	val counti : (int * 'a -> bool) -> 'a t -> int
	(** Like [count], but passes the index as an argument. *)

	(** [range] *)

	(** [range'] *)

	val init : (int -> 'a) -> int -> 'a t
	(** Wrapper of the standard [List.tabulate] function. *)

	val revFilterMap : ('a -> 'b option) -> 'a t -> 'b t

	val revFilterMapi : (int * 'a -> 'b option) -> 'a t -> 'b t

	val filterMap : ('a -> 'b option) -> 'a t -> 'b t

	val filterMapi : (int * 'a -> 'b option) -> 'a t -> 'b t

	val filterOpt : 'a option t -> 'a t
	(** [filterOpt l] is the sublist of [l] containing only elements which are [SOME]. *)

	(** [sub] *)

	val take : int -> 'a t -> 'a t

	val drop : int -> 'a t -> 'a t

	val takeWhile : ('a -> bool) -> 'a t -> 'a t

	val dropWhile : ('a -> bool) -> 'a t -> 'a t

	val splitWhile : ('a -> bool) -> 'a t -> 'a t * 'a t

	(** [dropLast] *)

	(** [dropLastExn] *)

	val concat : 'a t t -> 'a t
	(** Concatenates a list of lists. *)

	val concatNoOrder : 'a t t -> 'a t
	(** Like [concat], but faster and without preserving any ordering. *)

	val cons : 'a -> 'a t -> 'a t

	(** [cartesianProduct] *)

	(** [permute] *)

	(** [randomElement] *)

	(** [randomElementExn] *)

	val isSorted : ('a * 'a -> int) -> 'a t -> bool
	(** [isSorted cmp t] returns [true] iff all adjacent [a1, a2] in [t], [cmp (a1, a2) <= 0]. *)

	val isSortedStrictly : ('a * 'a -> int) -> 'a t -> bool
	(** [isSortedStrictly] is similar to [isSorted], but requires [<] instead of [<=]. *)

	val equal : ('a * 'a -> bool) -> 'a t -> 'a t -> bool

	structure Infix :
	sig
		val @ : 'a t * 'a t -> 'a t
	end

	(** [transpose] *)

	(** [transposeExn] *)

	(** [intersperse] *)
end