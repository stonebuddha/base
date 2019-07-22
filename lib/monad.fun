signature BASE_MONAD_BASIC1 =
sig
	type 'a monad

	val bind : ('a -> 'b monad) -> 'a monad -> 'b monad
	val return : 'a -> 'a monad
	val mapCustom : (('a -> 'b) -> 'a monad -> 'b monad) option
end

signature BASE_MONAD_S1 =
sig
	type 'a monad

	val >>= : ('a monad * ('a -> 'b monad)) -> 'b monad
	val >>| : ('a monad * ('a -> 'b)) -> 'b monad
	val bind : ('a -> 'b monad) -> 'a monad -> 'b monad
	val return : 'a -> 'a monad
	val map : ('a -> 'b) -> 'a monad -> 'b monad
	val join : 'a monad monad -> 'a monad
	val ignoreM : 'a monad -> unit monad
	val all : 'a monad list ->'a list monad
	val allUnit : unit monad list -> unit monad
end

signature BASE_MONAD_BASIC2 =
sig
	type ('a, 'e) monad

	val bind : ('a -> ('b, 'e) monad) -> ('a, 'e) monad -> ('b, 'e) monad
	val return : 'a -> ('a, 'e) monad
	val mapCustom : (('a -> 'b) -> ('a, 'e) monad -> ('b, 'e) monad) option
end

signature BASE_MONAD_S2 =
sig
	include BASE_MONAD_BASIC2

	val >>= : (('a, 'e) monad * ('a -> ('b, 'e) monad)) -> ('b, 'e) monad
	val >>| : (('a, 'e) monad * ('a -> 'b)) -> ('b, 'e) monad
	val map : ('a -> 'b) -> ('a, 'e) monad -> ('b, 'e) monad
	val join : (('a, 'e) monad, 'e) monad -> ('a, 'e) monad
	val ignoreM : ('a, 'e) monad -> (unit, 'e) monad
	val all : ('a, 'e) monad list -> ('a list, 'e) monad
	val allUnit : (unit, 'e) monad list -> (unit, 'e) monad
end

signature BASE_MONAD_BASIC_GENERAL =
sig
	type ('a, 'd, 'e) monad

	val bind : ('a -> ('b, 'd, 'e) monad) -> ('a, 'd, 'e) monad -> ('b, 'd, 'e) monad
	val return : 'a -> ('a, 'd, 'e) monad
	val mapCustom : (('a -> 'b) -> ('a, 'd, 'e) monad -> ('b, 'd, 'e) monad) option
end

signature BASE_MONAD_S_GENERAL =
sig
	include BASE_MONAD_BASIC_GENERAL

	val >>= : (('a, 'd, 'e) monad * ('a -> ('b, 'd, 'e) monad)) -> ('b, 'd, 'e) monad
	val >>| : (('a, 'd, 'e) monad * ('a -> 'b)) -> ('b, 'd, 'e) monad
	val map : ('a -> 'b) -> ('a, 'd, 'e) monad -> ('b, 'd, 'e) monad
	val join : (('a, 'd, 'e) monad, 'd, 'e) monad -> ('a, 'd, 'e) monad
	val ignoreM : ('a, 'd, 'e) monad -> (unit, 'd, 'e) monad
	val all : ('a, 'd, 'e) monad list -> ('a list, 'd, 'e) monad
	val allUnit : (unit, 'd, 'e) monad list -> (unit, 'd, 'e) monad
end

functor BaseMonad_MakeGeneral (X : BASE_MONAD_BASIC_GENERAL) : BASE_MONAD_S_GENERAL where type ('a, 'd, 'e) monad = ('a, 'd, 'e) X.monad =
struct
	open X

	fun mapViaBind f m = bind (fn a => return (f a)) m

	fun map f m =
			case X.mapCustom of
				NONE => mapViaBind f m
			| SOME map => map f m

	fun op>>= (t, f) = bind f t

	fun op>>| (t, f) = map f t

	infix 1 >>= >>|

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

functor BaseMonad_Make1 (X : BASE_MONAD_BASIC1) : BASE_MONAD_S1 where type 'a monad = 'a X.monad =
	let
		structure G = BaseMonad_MakeGeneral(
			struct
				open X
				type ('a, 'd, 'e) monad = 'a X.monad
			end)
	in
		struct
			open G
			type 'a monad = 'a X.monad
		end
	end

functor BaseMonad_Make2 (X : BASE_MONAD_BASIC2) : BASE_MONAD_S2 where type ('a, 'e) monad = ('a, 'e) X.monad =
	let
		structure G = BaseMonad_MakeGeneral(
			struct
				open X
				type ('a, 'd, 'e) monad = ('a, 'd) X.monad
			end)
	in
		struct
			open G
			type ('a, 'e) monad = ('a, 'e) X.monad
		end
	end