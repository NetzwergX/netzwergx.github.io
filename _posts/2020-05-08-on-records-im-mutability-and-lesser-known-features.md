---
layout: post
title: On records & (im-) mutability
date: 2020-05-08 21:24 +0200
categories: [Java]
tags: [Records]
---

Unfortunately, "records are immutable" is a false truth that gets repeated all too often. 
Looking at the JEP, we see them being called "shallowly-immutable". That is an important distinction.
A record can still be changed in a multitude of ways, and this article sheds some light on the strategies one
can employ to ensure records actually are immutable.

Records will be re-previewed in Java 15 without any changes as part of [JEP 384] 
and are expected to become a regular feature of the language in Java 16.

Lets start with a simple example and how it can be shown to be not immutable:

~~~ java
public static record NaiveRecord(String name, List<Date> values) { }
~~~

We can show that this record is mutable by simply adding to or removing from the list as returned by `values()`:

~~~ java
var naive = new NaiveRecord("naive", new ArrayList<>());
System.out.println(naive);
//prints NaiveRecord[name=naive, values=[]]
naive.values().add(new Date(99, 01, 01));
System.out.println(naive);
// prints NaiveRecord[name=naive, values=[Mon Feb 01 00:00:00 CET 1999]]
~~~

How can we do it better? We can adress the above problem by making the list immutable,
leveraging the canonical constructor without using a formal paremeter list:

~~~ java
public static record BetterRecord(String name, List<Date> values) {
	public BetterRecord {
		values = Collections.unmodifiableList(values);
	}
};
~~~
Now, changes to the record via `record.values().add/remove()` aren't possible anymore, 
as they'd throw an `UnsupportedOperationException`. 
Unfortunately, changes to the record are still possible by writing to the underlying list directly. 
If that has escaped or be given away, the record can still experience changes in state (and thus, `hashCode()`).

~~~ java
var original = new ArrayList<Date>();
original.add(new Date(99, 01, 01));
var better = new BetterRecord("better", original);
System.out.println("%s hash=%s".formatted(better, better.hashCode()));
// BetterRecord[name=better, values=[Mon Feb 01 00:00:00 CET 1999]] hash=-1516124796
original.add(new Date(102, 01, 01));
System.out.println("%s hash=%s".formatted(better, better.hashCode()));
// BetterRecord[name=better, values=[Mon Feb 01 00:00:00 CET 1999, Fri Feb 01 00:00:00 CET 2002]] hash=1357225607
System.out.println("-----");
~~~

The solution to that particular problem is to defensively copy the whole list, and then wrapping it into an unmodifiable one.

~~~ java
public static record EvenBetterRecord(String name, List<Date> values) {
	public EvenBetterRecord { 
		values = Collections.unmodifiableList(new ArrayList<>(values));
	}
};
~~~

But still, this record remains vulnerable if the data type stored in the list is mutable, as is the case for `java.util.Date`:

~~~ java
var original = new ArrayList<Date>();
var someDay  = new Date(100, 01, 01);
original.add(someDay);
var evenBetter = new EvenBetterRecord("even better", original);
System.out.println("%s hash=%s".formatted(evenBetter, evenBetter.hashCode()));
// EvenBetterRecord[name=even better, values=[Tue Feb 01 00:00:00 CET 2000]] hash=-1168472954

someDay.setYear(99);
System.out.println("%s hash=%s".formatted(evenBetter, evenBetter.hashCode()));
// EvenBetterRecord[name=even better, values=[Mon Feb 01 00:00:00 CET 1999]] hash=1655265406
~~~

We can address this by also creating a deep copy of each element of the list.
This is where having a copy constructor comes in very handy. Unfortunately, `java.util.Date` doesn't have one.
But it *does* implement `Cloneable` & has a `public clone()` method.

~~~ java
public static record ImmutableRecord(String name, List<Date> values) {
	public ImmutableRecord {
		values = values.stream()
				.map(Date::clone)
				.map(Date.class::cast)
				.collect(Collectors.toUnmodifiableList());
	}
}
~~~

Here we take the values, clone them, cast them back from `Object` to `Date` (as `Date#clone` returns `Object`)
and then collect them all into an unmodifiable list.

This list is not modifiable by any of the tricks shown so far.
We can of course still do shenanigans involving `Unsafe` or serialization, but this is the kind of record I'd consider 
*reasonably immutable*. If you are not using `java.util.Date`, you might need to make sure that you are actually doing 
a deep copy of the object, as a shallow copy might have leaked references through which it can be manipulated, too.

Note that only nesting records is no defense again mutation, either. 
If the nested record is mutable, e.g. by having an improperly treated collection, the holding record becomes mutable, too.

## Recap

Records are not immutable, they are only "shallowly-immutable". We can break immutability in three ways:

* Adding to or removing from the list returned by `values()`  
	(addressed by wrapping it into an unmodifiable list)
* Adding or removing from the original list if we still have a reference to it  
	(addressed by copying the list)
* Mutating an element in the list mutates the record  
	(addressed by deep copying the elements of the list)

In fact, we can easily devise unit-tests for all three of these properties.
The following gist contains a JUnit 5 test case, with unit tests called  
* `canNotChangeThroughGetter`, 
* `canNotChangeThroughOriginalList` and
* `canNotChangeThroughOriginalObject`.
 
In order to execute each of these tests with each record, I have added a common interface `RecordWithList` to all four 
of these records and execute the tests with each type of record.
Not all records pass all tests, which was expected in this case.

<details class="github-gist" data-url="https://gist.github.com/NetzwergX/e0e09f3a10f40bdae7fac643193b8d0e">
<summary>Show Gist</summary>
{% gist e0e09f3a10f40bdae7fac643193b8d0e %}
</details>
    
# Conclusion

Using the canonical constructor without formal parameter list can be quite powerful. 
Using `this.x` inside such a constructor is not needed and actively discouraged to the point 
that the Java architects are considering disallowing such access altogether. 

Using a formal parameter list on the constructor allows programmers to place annotations there. 
With such a constructor, some libraries, most notably Jackson, can be made to work with constructors easily.

Records are only "shallowly-immutable". If one wants to leverage the beneficial properties of immutable types, 
great care has to be taken to ensure that the record actually is immutable, and not only appears that way at first glance.

# Related reading:

* [Records & their constructors]()

[Jackson]: https://github.com/FasterXML/jackson-future-ideas/issues/46
[JEP 384]: https://openjdk.java.net/jeps/384
[JEP 359]: https://openjdk.java.net/jeps/359