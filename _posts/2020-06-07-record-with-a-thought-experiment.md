---
layout: post
title: Record#with - a thought experiment
date: 2020-06-07 16:22 +0200
categories: [Java, Project Amber]
tags: [Records]
---
Recently, there were some interesting discussions about `Record#copy()` and `Record#with(...)` on the `amber-spec-experts`
mailing list ([1], [2]) which has lead me to implement both methods with a very clear & typesafe way, which I'd like to 
discuss below. The code demonstrated below is available as [Gist].

What led me to start this experiment was the following quote:

> the idea is to add a method `Record with(Object... componentValuePairs)` in `java.lang.Record`, and ask the 
> compiler to verify that the even arguments (0, 2, 4, etc) are constant strings
> 
> Proposed syntax:
>
> 	var otherPerson = person.with("name", "John", "age", 17);

I thought this *had* to be easier and be possible in a typesafe way. So here is my suggestion:

	var otherPerson = person.with(Person::name, "John").with(Person::age, 17);

What do we get? Type saftey. Better, easier to read syntax.

# Can we pull this off?

## Yes

It turns out, its actually possible to pull this off just as written there. Yes, `Person::name` is an accessor method
and doesn't allow us to set anything irectly - but we already know how the component of the record is called when we
look at that -- and we also know the type.

The question is, can we get this information from the lambda? 
[Turns out we can](https://stackoverflow.com/a/35223119/1360803).
````java
/**
 * c.f. https://stackoverflow.com/a/35223119/1360803
 */
private static SerializedLambda getSerializedLambda(Serializable lambda)
		throws NoSuchMethodException, SecurityException,
		IllegalAccessException, IllegalArgumentException,
		InvocationTargetException {
	final Method method = lambda.getClass()
			.getDeclaredMethod("writeReplace");
	method.setAccessible(true);
	return (SerializedLambda) method.invoke(lambda);
}
````

We can use this to extract everything we need:
````java
public static <T, F extends Serializable & Function<R, T>> void with(F param) {
	var lambda = getSerializedLambda(param);
	var name = lambda.getImplMethodName();
	var signature = lambda.getImplMethodSignature();
	// get descriptor, strip () of input
	var typeDescriptor = signature.substring(2, signature.length());
	System.out.println(name + ":" + typeDescriptor);
	// if we call this with with(Person::name), we get `name:Ljava/lang/String;`
}
````

We get the type signature and the name of the accessor method, which is the same as the field. We strip the `()` from
the method signature to get the return type.

Putting it all together, we get this nice method:

````java
@SuppressWarnings("unchecked")
public default <T, F extends Serializable & Function<R, T>> R with(F param, T val) {
	try {
		// get name & type of the changing parameter
		var lambda = getSerializedLambda(param);
		var name = lambda.getImplMethodName();
		var signature = lambda.getImplMethodSignature();
		// get descriptor, strip () of input
		var typeDescriptor = signature.substring(2, signature.length());

		// get record components & replace the value
		var components = getClass().getRecordComponents();
		var params = new Object[components.length];
		for (int i = 0; i < components.length; i++) {
			var component = components[i];
			if (isCompatible(component, name, typeDescriptor))
				params[i] = val;
			else {
				params[i] = component.getAccessor().invoke(this);
				// accessor might modify data, so circumvent accessor
				// but records don't expose their fields :(
				//params[i] = getClass().getField(component.getName()).get(this);
			}
		}
		// create new record
		return (R) getClass().getConstructors()[0].newInstance(params);
	} catch (NoSuchMethodException | SecurityException
			| IllegalAccessException | IllegalArgumentException
			| InvocationTargetException e) {
		throw new RuntimeException(e);
	} catch (InstantiationException e) {
		throw new RuntimeException(e);
	} /*catch (NoSuchFieldException e) {
		throw new RuntimeException(e);
	}*/
}
````

The full code is available as [Gist]. I've created an interface with this method as only default method, which
can be implemented by any record.

And it actually works as advertised:

````java
public static record Person(String name) implements CopyableRecord<Person> {}

var guruJava = new Person("Brian Goetz");
var guruCSharp = guruJava.with(Person::name, "Eric Lippert");
````

## But with a few drawbacks.

The first and most obvious drawback: This only works with method references like `Person::firstName`. Which is fair, I
guess. This doesn't work:

````java
var original = new Person("Brian", "Goetz");
var copy = original.with(p -> p.firstName(), "Eric"); // nope
````

In fact, my current implementation silently ignores this (which is ok for a thought experiment, not so much for
production code).

Furthermore, the method I have presented above has a few commented-out lines.

````java
params[i] = component.getAccessor().invoke(this);
// accessor might modify data, so circumvent accessor
// but records don't expose their fields :(
//params[i] = getClass().getField(component.getName()).get(this);
````

These also lead to the commented-out `NoSuchFieldException` catch-block.

So whats the problem? Accessors can change the data. I'm not sure it would be a good or often used design feature a 
programmer would *want* to use to return data that is invalid, instead of just some wrappers around data like 
`Collections#unmodifieableList`, but it can happen.

Lets look at an -- arguably contrived -- example:

````java
public static record Doubling (int n, int m) implements RecordTransform<Doubling> {
	public int n() { return 2 * n; }
	public int m() { return 2 * m; }
}

var original = new Doubling(2, 3); // Doubling[n=2, m=3]
var copy = original.with(Doubling::n, 5); // Doubling[n=5, m=6]
````

So yeah. By using the accessor we double the data every time we copy the record.

## Is this really a problem?

I'm not so sure. Lets say that we use libraries like ASM to access the underlying fields directly. We can still
trivially easy break copying:

````java
public static record Doubling (int n, int m) implements RecordTransform<Doubling> {
	public Doubling {
		n = 2 * n;
		m = 2 * m;
	}
}
````

If we copy the value of the fields, we still double them every time. And circumventing the constructor seems to be a
*bad* idea. If someone wants to alter drastically different data in the accessor or mutate it this way in their 
constructors, why net let them? Sure, copying then has side-effects that might be surprising on the first glance, but
are actually quite logical on second glance.

Whats actually more upsetting in my opinion is that `Record#toString` doesn't use the accessor methods and thus
displays values you can never extract from the record. It will be interesting to see how that plays out with 
deconstruction patterns.  
If you implement a DoublingRecord like above, what do you expect to happen when you the following?

````java
var original = new Doubling(2,3);
let Doubling(int m, int n) = original;
var copy = Doubling(m, n);
````

The problems you are facing with a `Record#with` or `Record#copy` method are exactly the same that emerge when talking
about deconstruction. Whatever solution is chosen for deconstruction will also be applicable for those both methods.

<small>Personally, I'd think this is a non-issue. If someone wants to implement their records that way, let them and
let them deal with the fallout themselves.</small>

My point is: If I'm able to pull this off, I'm sure the Java architects will find a way to implement
`Record#with` in a much better way than by using strings to look up values and completely circumventing the type system.
It can be done inside the type system, with type safety & compiler support, and probably a lot more elegant than what
I've cobbled up here.

**Disclaimer**

This is a thought experiment. Do not use this in production. I've not benchmarked it, it doesn't use
`MethodHandle`/`VarHandle` and is probably not suitable en masse.

[Gist]: https://gist.github.com/NetzwergX/4ebba8ea36d0663f2a540d0f71f16e49
[1]: https://mail.openjdk.java.net/pipermail/amber-spec-experts/2020-May/002217.html
[2]: https://mail.openjdk.java.net/pipermail/amber-spec-experts/2020-May/002221.html
