---
layout: post
title: Failure Modes
date: 2020-05-07
categories: [Java]
tags: [exception-handling]
---
Programs often have to deal with less then ideal conditions -- intermittent internet connections, hardware dropping in 
and out, user input not being reliable, files being corrupted, and many, many more scenarios in which failure is not 
only a possibility, but to a certain has to be expected and worked with without fatally crashing the application,
but instead gracefully resuming and informing the user of the problems and allowing them to fix them.  
In this article, I’ll talk about the following three ways to handle failure modes.

# Failure modes

1. Return `true`, `false`, `NULL` or another *magic* value
2. Use `void`, throw a (checked) exception
3. Return an intermediate result object

Each of these modes is discussed below, with examples of their usage, strengths and weaknesses.

# Return `true`, `false` or `NULL`

This is used in some older, mostly C-style APIs. Today, we can for example find it quite often in the 
PHP standard library, leading to code like this:

~~~PHP
if ($data = xyz_parse($data) === FALSE)
	$error = xyz_last_error();
~~~

Obviously this only works in languages like PHP because there is no static typing and in C due to being able to cast 
values this way. In Java, the only way to signal failure would be to return `null` or another magic value 
(via the NULL-Object pattern).

The downsides to this approach are (not exhaustive):

* It is not clear from the method signature what the magic values are
* Without a-priory knowledge about the magic values, checking for them and interpreting them correctly is impossible
* *No compiler support*, forcing the caller to correctly handle all scenarios by themselves, making errors easy

In multi-threaded contexts, this approach is even worse. In between parsing and retrieving the error, 
another thread might parse something, overwriting the stored errors.
Synchronizing such access is easily forgotten or a performance nightmare.

Therefore, this approach has largely fallen out of favor, especially in programming languages that offer useful alternatives.

We can sometimes see a similar approach being used in Java where no return value is expected and instead a boolean
is returned to indicate failure and success, e.g. in `Collection#add`. The disadvatange is that we do not get any
information about the kind of failure and have no way to query what went wrong. 

And in case of `Collections.unmodifiable[Collection|List|Set|Map]`, we get a runtime exception (`UnsupportedOperationException)`, 
which by necessity is unchecked. This defeats all the help the compiler could give us and makes unmodifiable collections
prone to let exceptions bubble up the stack without being handled at the proper level.

# Throw (checked) exceptions

Checked exceptions are a more elegant way to signal potential failure modes and forcing the caller to handle them. 
Since *failure is to be expected* for certain operations, checked exceptions an be leverage to enforce error handling
by the caller. Java for example uses checked exceptions when dealing with sockets.
The basic assumption is that a call should succeed, but certain operations are known to be unreliable.
Socket connections are among them. So the caller gets forced to handle the failure.

~~~java
try {
	socket.open();
} catch (IOException e) {
	// deal with the failure, e.g. display error message
}
~~~

# Return result object

Another way to handle expected failure is to return an immediate result object that holds information about 
the operation. In modern Java, `Optional<E>` could also be used to signal values that might or might not be present 
(e.g. a valid parsing result).

~~~java
ValidationResult result = parser.validate(rawData);
if (result.isValid()) {
	var data = result.getData();
	// process data
}
else {
	var error = result.getValidationError();
	// optional error handling
}
~~~

Nice, clean logic for the caller. In Java, `ValidationResult#getData` could return `Optional<BusinessData>` to 
communicate to the caller that the data might or might not be present and to ensure compiler support for missing values.

## Leveraging sealed classes and interfaces (algebraic types)

With [JEP 360] [considered for Java 15][RFR-JEP360-Java15],
we might get yet another way to create intermediate result objects that sits somewhere in between checked exceptions
and a result object - algebraic types! These are formed with [Sealed Types] and [Records][JEP 359].

Suppose we create a type `Result<S, E> = Success<S> | Error<E>`, which we could do In Java 15 with

~~~java
sealed interface Result<S,E> permits Success<S, E>, Error<S, E> {
	record Success<S, E> (S result) implements Result<S, E> {}
	record Error<S, E> (E error) implements Result<S, E> {}
}
~~~

Unfortunately, we can not specify a "don't care" generic wildcard, so a bit repetition is needed there. But now, instead of
indicating to a caller the possibility of errorneos execution via `throws`, we can indicate this via the result type:

~~~java
class Parser {
	
	public Result<Data, InvalidFormatException> parse(String raw) {
		// [...]
	}
}
~~~

A caller is then forced to examine the type, either via `instanceof` ([JEP 305]) or leveraging `switch` expressions ([JEP 325]),
potentially even leveraging pattern-matching with deconstruction patterns inside of any of those ([JEP Draft], [Pattern Matching]).

An example call could look like this:

~~~java
switch(parser.parse(input)) {
	case Result(Data data) -> process(data);
	case Error(InvalidFormatException e) -> displayError(e);
}
~~~

We might even use a more general exception and switch more fine-grained on the exception type 
(potentially forgoing exhaustiveness checks and necessitating a `default` clause).


# Conclusion

Failure modes can be handled in different ways depending on wether failure is expected or unexpected. Shown here are
four ways of handling them, and which one to choose depends on the nature of the problem and the context
in which it might occur.

There is a (sometimes) heated debate going on when to use (checked) exceptions and when to use other approaches.
A statement that I found very reasonable wrt. exceptions is the following:

> Checked exceptions are for environment problems. Unchecked exceptions are programming errors.  
> --- Elliotte Rusty Harold, *Exceptions: I'm Telling You For The Last Time*


[Sealed Types]: https://cr.openjdk.java.net/~briangoetz/amber/datum.html
[Pattern Matching]: https://cr.openjdk.java.net/~briangoetz/amber/pattern-match.html
[JEP Draft]: https://openjdk.java.net/jeps/8213076
[JEP 305]: https://openjdk.java.net/jeps/305
[JEP 325]: https://openjdk.java.net/jeps/325
[JEP 359]: https://openjdk.java.net/jeps/359
[JEP 360]: https://openjdk.java.net/jeps/360
[RFR-JEP360-Java15]: https://mail.openjdk.java.net/pipermail/amber-dev/2020-April/005784.html

