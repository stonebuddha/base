local

signature BASIC =
sig
	type 'a t

	val bind : ('a -> 'b t) -> 'a t -> 'b t

	val return : 'a -> 'a t
end

funsig MAKE (X : BASIC) =
sig
	val >>= : ('a X.t * ('a -> 'b X.t)) -> 'b X.t

	val >>| : ('a X.t * ('a -> 'b)) -> 'b X.t

	val bind : ('a -> 'b X.t) -> 'a X.t -> 'b X.t

	val return : 'a -> 'a X.t

	val map : ('a -> 'b) -> 'a X.t -> 'b X.t

	val join : 'a X.t X.t -> 'a X.t

	val ignoreM : 'a X.t -> unit X.t

	val all : 'a X.t list -> 'a list X.t

	val allUnit : unit X.t list -> unit X.t
end

signature BASIC2 =
sig
	type ('a, 'e) t

	val bind: ('a -> ('b, 'e) t) -> ('a, 'e) t -> ('b, 'e) t

	val return : 'a -> ('a, 'e) t
end

funsig MAKE2 (X : BASIC2) =
sig
	val >>= : (('a, 'e) X.t * ('a -> ('b, 'e) X.t)) -> ('b, 'e) X.t

	val >>| : (('a, 'e) X.t * ('a -> 'b)) -> ('b, 'e) X.t

	val bind : ('a -> ('b, 'e) X.t) -> ('a, 'e) X.t -> ('b, 'e) X.t

	val return : 'a -> ('a, 'e) X.t

	val map : ('a -> 'b) -> ('a, 'e) X.t -> ('b, 'e) X.t

	val join : (('a, 'e) X.t, 'e) X.t -> ('a, 'e) X.t

	val ignoreM : ('a, 'e) X.t -> (unit, 'e) X.t

	val all : ('a, 'e) X.t list -> ('a list, 'e) X.t

	val allUnit : (unit, 'e) X.t list -> (unit, 'e) X.t
end

signature BASIC_GENERAL =
sig
	type ('a, 'd, 'e) t

	val bind : ('a -> ('b, 'd, 'e) t) -> ('a, 'd, 'e) t -> ('b, 'd, 'e) t

	val return: 'a -> ('a, 'd, 'e) t
end

functor MakeGeneral (M : BASIC_GENERAL) =
struct
	val bind = M.bind

	val return = M.return

	fun map f ma = M.bind (fn a => M.return (f a)) ma

	fun op>>= (t, f) = bind f t

	fun op>>| (t, f) = map f t

	infix 0 >>= >>|

	fun join t = t >>= (fn t' => t')

	fun ignoreM t = t >>| (fn _ => ())

	fun all ts =
		let
			fun loop vs [] = return (List.rev vs)
				| loop vs (t :: ts) = t >>= (fn v => loop (v :: vs) ts)
		in
			loop [] ts
		end

	fun allUnit [] = return ()
		| allUnit (t :: ts) = t >>= (fn () => allUnit ts)
end

in

signature BASE_MONAD =
sig
	functor Make : MAKE

	functor Make2 : MAKE2
end

structure BaseMonad : BASE_MONAD =
struct
	functor Make (M : BASIC) =
		MakeGeneral(
			struct
				type ('a, 'd, 'e) t = 'a M.t
				val bind = M.bind
				val return = M.return
			end)

	functor Make2 (M : BASIC2) =
		MakeGeneral(
			struct
				type ('a, 'd, 'e) t = ('a, 'd) M.t
				val bind = M.bind
				val return = M.return
			end)
end

end