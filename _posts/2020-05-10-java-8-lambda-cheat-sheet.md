---
layout: post
title: Java 8 Lambda Cheat Sheet
date: 2020-05-06
---

Even though Java 8 is just a little over six years old and brought a tremendous revolution to Java, 
adoption of lambdas and functional approaches to programming problems is still an ongoing process.  
I have introduced numerous people to functional-style programming & lambdas,
and at one point came up with the idea of a small "cheat sheet" only one or two DIN A4 pages in size that you could have 
in hand when thinking about functional stuff. This is by no means meant to be a comprehensive introduction, 
but a small reference document, and has been received very well, so I thought I'd share it here.
{: .no-print}

Interface<br/>& Method | Type | Example
--------- | --------- | ------------ |
[`Supplier<E>`](https://docs.oracle.com/javase/8/docs/api/java/util/function/Supplier.html) <br/> `E get()`| `() -> E` | `Supplier<List> factory = ArrayList::new;`<br/>`stream.collect(Collectors.toList(factory));`
[`Consumer<E>`](https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html) <br/>`void accept(E e)` | `E -> ()`| `list.foreach(e -> e.frobnicate())`
[`Runnable`](https://docs.oracle.com/javase/8/docs/api/java/lang/Runnable.html) <br/> `void run()`| `() -> ()` | `new Thread(() -> System.sleep(10000)).run();`
[`Function<T,R>`](https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html)<br/>`R apply(T t)` | `T -> R` | `stream.map(t -> new R(t));`
[`BiFunction<T,U,R>`](https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html)<br/>`R apply(T t, U u)` | `(T, U) -> R` | `stream.reduce(start, accumulator, merge`)
[`Predicate<E>`](https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html) <br/>`boolean test(E e)`| `E -> boolean` | `Function<E, Boolean>` but with primitive `boolean`

# When to use

Use                    | When                              | Related concept
---------------------- | --------------------------------- | ------------
`Supplier<E>`          | If it takes nothing               | Factory
`Consumer<E>`          | If it returns nothing             | Listener, Callback
`Runnable`             | If it does neither                | Task
`Function<F, T>`       | If it does both                   | Callback
`BiFunction<T, U , R>` | If it takes two and returns one   |
`Predicate<E>`         | To check semantic properties      | Condition

# MapReduce<br/><small>Important stream operations</small>

*As always, `A = B` is permissible!* 

Operation |  Type            | Input       | Output      | See also
----------| ---------------- | ----------- | ----------- | ----
`map`     | `A -> B`         | `Stream<A>` | `Stream<B>` | `flatMap`
`filter`  | `A -> bool`      | `Stream<A>` | `Stream<A>` | `takeWhile`
`reduce`  | `(B, ((B, A) -> B), ((B, B) -> B)) -> B` | `Stream<A>`  | `B`         | `collect` is `reduce`

# When to use

Use      | When
---------| -
`map`    | transforming one Stream into another Stream
`filter` | excluding elements from one stream based on a condition (predicate)
`reduce` | making the stream "smaller" (reducing it), e.g. <br/> - collecting *multiple* elements into *one* list<br/>- taking a sum, maximum or minimum<br/>- or otherwise reducing multiple elements to one element

