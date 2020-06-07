---
layout: post
title: 'Exception handling with union types: Either<L, R>'
tagline: 'An ADT working well with streams'
date: 2020-05-24 13:42 +0200
categories: [Java, Project Amber]
tags: [Java, Records, ADT, Either, Exception]
series: Records-2020
---

In [Failure Modes](http://localhost:4000/blog/failure-modes-2020), I talked about way to indicate failure (ecxeptions) in the form of a type
`Result<D, E extends Throwable> = Success<D> | Failure<E>` in order to model failure without resorting to exceptions,
magic values or other intermediate result objects, like `ParserResult`. In this article I'll explore another alternative
design and its benefits, especially in stream contets: A union type `Either<L, R>`, leveraging sealed interfaces & pattern
matching.

# Recap: Result

With [Project Amber] (Java 15 ff) we can leverage records & sealing in order to gain many useful features such as 
pattern matching and exhaustveness checks in switch (expressions). The `Result` metioned therein would probably look
a lot like this in a future Java version (I avoid :

````java
public sealed interface Result<D, E> permits Success<D, E>, Error<D, E> {
	public record Success<D, E>(D data) implements Result<D, E> {};
	public record Failure<D, E>(E error) implements Result<D, E> {};
}
````

This would allow us to re-phrase methods that can throw exceptions. The following exaple function is heavily inspired
by [this DZONE article](https://dzone.com/articles/how-to-handle-checked-exception-in-lambda-expressi):

````java
private void save(URL url) throws IOException {
	String uuid = UUID.randomUUID().toString();
	InputStream inputStream = url.openConnection().getInputStream();
	Files.copy(inputStream, Paths.get(uuid + ".txt"), StandardCopyOption.REPLACE_EXISTING);
}
````

This method is definitely not friendly to streams. Using it in a stream would be rather cumbersome:

````java
var urls = List.of("www.google.com", "example.org");
urls.stream()
	.map(URL::new)			// Unhandled exception type MalformedURLException
	.forEach(this::save);	// Unhandled exception type IOException
````

The expansion of this to include `try-catch` blcoks would be rather unwiedly and extremely hard to read.

Fortunately, we can make use of our newly introduced `Result` object.

````java
private Result<Void, IOException> save(URL url) {
	try {
		String uuid = UUID.randomUUID().toString();
		InputStream inputStream = url.openConnection().getInputStream();
		Files.copy(inputStream, Paths.get(uuid + ".txt"), StandardCopyOption.REPLACE_EXISTING);
		return new Result.Success<>(null);
	} catch (IOException e) {
		return new Result.Failure<>(e);
	}
}
````

Now, we replace the `forEach` in our stream with `map` and end up with a nice `Stream<Result>` which we can further
process -- e.g. logging why stuff failed or re-trying the operation.

````java
urls.stream()
	.map(URL::new)			// Unhandled exception type MalformedURLException
	.map(this::save)		// Stream<Result>
````

Unfortunately, Java does *not* play well with heterogenous streams. Instead of logging, for this example we'll try
to just dump the stack traces via 'IOException#printStackTrace':

````java
urls.stream()
	.map(URL::new)			// Unhandled exception type MalformedURLException
	.map(this::save)		// Stream<Result>
	.filter(result -> result instanceof Failure<Void, IOException>)
	.map(Failure.class::cast)		// need to cast it again - this is why pattern matching in instanceof is coming
	.map(Failure::error)			// extract the error
	.map(IOException.class::cast)	// oops, we have erased the type
	.forEach(IOException::printStackTrace); // finally
````

Five lines are a bit overkill for this, but unfortunately this is how type erasure works. Fortunately, [JEP 301] *might*
come to the rescure in the future and [bring sharper raw types][Enhanced Enums].

But we can still do better with what we already have in the language right now.

# Introducing a union type: Either<L, R> = Left\<L\> | Right\<R\>

The `Result` type I have shown above is nothing more than a union type for the types `Failure` and `Success`.
By recognizing this generalization we can come up with an even better type that embeds much more nicely into streams.

We'll leverage the improved `Optional<E>` implementation called `Maybe<E>` (inspired by the Haskell type) introduced in
[Maybe: An improvement to Optional with pattern matching](./blog/maybe-e-an-improvement-to-optional-e-with-pattern-matching-2020).
If you haven't read that post its highly encouraged that you do, although the type is designed fairly intuitively and
the method names are (hopefully) self-explaining.




data Either a b = Left a | Right b

[JEP 301]: https://openjdk.java.net/jeps/301
[Project Amber]: https://cr.openjdk.java.net/~briangoetz/amber/datum.html
[Enhanced Enums]: http://cr.openjdk.java.net/~mcimadamore/amber/enhanced-enums.html