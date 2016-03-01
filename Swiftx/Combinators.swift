//
//  Functions.swift
//  Swiftx
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// The identity function.
public func identity<A>(a : A) -> A {
	return a
}

/// The constant combinator ignores its second argument and always returns its first argument.
public func const<A, B>(x : A) -> B -> A {
	return { _ in x }
}

/// Flip a function's arguments
public func flip<A, B, C>(f : ((A, B) -> C), b : B, a : A) -> C {
	return f(a, b)
}

/// Flip a function's arguments and return a function that takes the arguments in flipped order.
public func flip<A, B, C>(f : (A, B) -> C)(b : B, a : A) -> C {
	return f(a, b)
}

/// Flip a function's arguments and return a curried function that takes
/// the arguments in flipped order.
public func flip<A, B, C>(f : A -> B -> C) -> B -> A -> C {
	return { b in { a in f(a)(b) } }
}

/// The fixpoint (or Y) combinator computes the least fixed point of an equation. That is, the first
/// point at which further application of x to a function is the same x.
///
///     x = f(x)
public func fix<A, B>(f : (A -> B) -> A -> B) -> A -> B {
	return { x in f(fix(f))(x) }
}

/// The fixpoint (or Y) combinator computes the least fixed point of an equation. That is, the first
/// point at which further application of x to a function is the same x.
///
/// `fixt` is the exception-enabled version of fix.
public func fixt<A, B>(f : (A throws -> B) throws -> (A throws -> B)) rethrows -> A throws -> B {
	return { x in try f(fixt(f))(x) }
}

/// On | Applies the function on its right to both its arguments, then applies the function on its
/// left to the result of both prior applications.
///
///    (+) |*| f = { x in { y in f(x) + f(y) } }
public func on<A, B, C>(o : B -> B -> C) -> (A -> B) -> A -> A -> C {
	return { f in { x in { y in o(f(x))(f(y)) } } }
}

/// On | Applies the function on its right to both its arguments, then applies the function on its
/// left to the result of both prior applications.
///
///    (+) |*| f = { x, y in f(x) + f(y) }
public func on<A, B, C>(o : (B, B) -> C) -> (A -> B) -> A -> A -> C {
	return { f in { x in { y in o(f(x), f(y)) } } }
}

/// Applies a function to an argument until a given predicate returns true.
public func until<A>(p : A -> Bool) -> (A -> A) -> A -> A {
	return { f in { x in p(x) ? x : until(p)(f)(f(x)) } }
}
