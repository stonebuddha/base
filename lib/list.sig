signature BASE_LIST =
sig
	type 'a t = 'a list

	val compare : ('a * 'a -> int) -> 'a t -> 'a t -> int

	(** {2 Container API} *)

	include BASE_CONTAINER_S1 where type 'a container = 'a t

	(** {2 Monad API} *)

	include BASE_MONAD_S where type 'a monad = 'a t

	(** {2 List-Specific API} *)

	(** [OrUnequalLengths] is used for functions that take more than one lists and only make sense if all the lists have the same length. *)
	structure OrUnequalLengths :
	sig
		datatype 'a t = OK of 'a | UNEQUAL_LENGTHS

		val compare : ('a * 'a -> int) -> 'a t -> 'a t -> int
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

	(** [iter2Exn] *)

	(** [iter2] *)

	(** [revMap2Exn] *)

	(** [revMap2] *)

	(** [fold2Exn] *)

	(** [fold2] *)

	(** [foralli] *)

	(** [forall2Exn] *)

	(** [forall2] *)

	(** [existsi] *)

	(** [exists2Exn] *)

	(** [exists2] *)

	(** [filter] *)

	(** [revFilter] *)

	(** [filteri] *)

	(** [partitionMap] *)

	(** [partition3Map] *)

	(** [partitionTF] *)

	(** [partitionResult] *)

	(** [splitN] *)

	(** [sort] *)

	(** [stableSort] *)

	(** [merge] *)

	val hd : 'a t -> 'a option
	val tl : 'a t -> 'a t option

	val hdExn : 'a t -> 'a
	(** Returns the first element, or raises if the list is empty. *)

	val tlExn : 'a t -> 'a t
	(** Returns the list without its first element, or raises if the list is empty. *)

	(** [findi] *)

	(** [findExn] *)

	(** [findMapExn] *)

	(** [findMapi] *)

	(** [findMapiExn] *)

	val append : 'a t -> 'a t -> 'a t
	(** E.g., [append [1, 2] [3, 4, 5]] is [[1, 2, 3, 4, 5]]. *)

	(** [foldingMap] *)

	(** [foldingMapi] *)

	(** [foldMap] *)

	(** [foldMapi] *)

	val concatMap : ('a -> 'b t) -> 'a t -> 'b t
	(** [concatMap f t] is [concat (map f t)], except that there is no guarantee about the order in which [f] is applied to the elements of [t]. *)

	(** [concatMapi] *)

	(** [map2Exn] *)

	(** [map2] *)

	(** [revMap3Exn] *)

	(** [revMap3] *)

	(** [map3Exn] *)

	(** [map3] *)

	(** [revMapAppend] *)

	(** [foldRight] *)

	(** [foldLeft] *)

	(** [unzip] *)

	(** [unzip3] *)

	(** [zip] *)

	(** [zipExn] *)

	(** [mapi] *)

	(** [revMapi] *)

	(** [iteri] *)

	(** [foldi] *)

	(** [reduceExn] *)

	(** [reduce] *)

	(** [reduceBalanced] *)

	(** [reduceBalancedExn] *)

	(** [group] *)

	(** [groupi] *)

	(** [chunksOf] *)

	(** [last] *)

	(** [lastExn] *)

	(** [isPrefix] *)

	(** [findConsecutiveDuplicates] *)

	(** [removeConsecutiveDuplicates] *)

	(** [dedupAndSort] *)

	(** [findADup] *)

	(** [containsDup] *)

	(** [findAllDups] *)

	(** [counti] *)

	(** [range] *)

	(** [range'] *)

	(** [init] *)

	(** [revFilterMap] *)

	(** [revFilterMapi] *)

	(** [filterMap] *)

	(** [filterMapi] *)

	(** [filterOpt] *)

	(** [sub] *)

	(** [take] *)

	(** [drop] *)

	(** [takeWhile] *)

	(** [dropWhile] *)

	(** [splitWhile] *)

	(** [dropLast] *)

	(** [dropLastExn] *)

	(** [concat] *)

	(** [concatNoOrder] *)

	(** [cons] *)

	(** [cartesianProduct] *)

	(** [permute] *)

	(** [randomElement] *)

	(** [randomElementExn] *)

	(** [isSorted] *)

	(** [isSortedStrictly] *)

	(** [equal] *)

	structure Infix :
	sig
		val @ : 'a t * 'a t -> 'a t
	end

	(** [transpose] *)

	(** [transposeExn] *)

	(** [intersperse] *)
end