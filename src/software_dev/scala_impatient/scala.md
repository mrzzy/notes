# Scala Notes
References _Scala for the Impatient_ Book and [Twitter's Scala School](https://twitter.github.io/scala_school/)
Rights and Credits belong to their respective authors

## SBT - Simple Built Tool
References [SBT: The Missing Tutorial](https://github.com/shekhargulati/52-technologies-in-2016/blob/master/02-sbt/README.md)

SBT is scala's project build tool:
- `sbt` on the project directory to start sbt shell
- `sbt new scala/hello-world.g8` to create a new scala project with the hello-world template.
- place `~` before `sbt` sub command to make the subcommand to automatically run on code changes
- join subcommands with `:`  (ie `compile:run`)
- place project source in `src/main/scala/`
- place test cases in `src/test/scala/`

Commands that can be used in `sbt`:
- `console` starts the scala REPL.
- `update` downloads the library dependencies as defined in `build.sbt`
- `compile` - compiles the current project
- `run` - runs the current project

### build.sbt file
Config scala version and other project metadata  in `build.sbt` located at the base directory:
- See [Keys.scala](https://www.scala-sbt.org/0.13/sxr/sbt/Keys.scala.html) for a list of all configuration keys
```scala
name := "testing"
version := "0.1.0"
scalaVersion := "2.11.6"
```
- Reload changes in `build.sbt` using  `reload` subcommand.

#### Project Dependencies
Add project dependencies to `build.sbt` using the follow format:

```scala
// libraryDependencies += groupID % artifactID % version % configuration
libraryDependencies += "org.scalatest" % "scalatest_2.11" % "2.2.6" % "test"
```

#### Custom Tasks
Add custom tasks to `sbt` via `build.sbt`:
```scala
val gitCommitCountTask = taskKey[String]("Prints commit count of the current branch")

gitCommitCountTask := {
  val branch = scala.sys.process.Process("git symbolic-ref -q HEAD").lines.head.replace("refs/heads/","")
  val commitCount = scala.sys.process.Process(s"git rev-list --count \$branch").lines.head
  println(s"total number of commits on [\$branch]: \$\$commitCount")
  commitCount
}
```

#### Plugins
Add plugins to `build.sbt`, such as stylecheckers like `scalastyle`:
- Plugins add additional `sbt` tasks (ie `scalastyle` task from the scala plugin)
```scala
addSbtPlugin("org.scalastyle" %% "scalastyle-sbt-plugin" % "0.8.0")
```

## Scala Basics
### Hello World
Print `Hello, World!` in Scala:
- body of `Main` object used as main method when it extends `App`
```scala
object Main extends App {
  println("Hello, World!")
}
```

### Types
Basic types similar to `java`: `Int`, `Byte`, `Char`, `Short`, `Float`, `Double`
- except there is no distinction between primitives and class types:
- large numeric types types: `BigInt` and `BigDecimal` for numbers that might overflow primitives.

> Underneath the hood, Scala automatically[converts primitive types to their rich equivalents](https://stackoverflow.com/questions/29655076/why-are-there-richint-or-richx-in-scala)
> (ie `Int` to `RichInt`) to provide additional functionality.

Sequence types: `Range[]`, `Seq[]`, `GenSeq[]`, `GenIterable[]`, `GenTraversableOnce[]`

Void value: `Unit` or `()`

### Variables and Constants
Variable and Constants:

| Code | Explanation |
| ---  | --- |
| `val x = 0` | Define a constant `x` assigned with the value `0` |
| `var x = 0` | Define a variable `x` assigned with the value `0` |
| `val x:String = "hello"` | Define a constant of  `x` assigned with the value `"hello"` |
| `val x, y = 0` | Define both constants `x` and `y` with the value `0` |
| `val x, y:String = "hello` | Define both constants `x` and `y` with the value `"hello"` |

> use constants wherever possible, variables only when necessary.

### Syntactic Sugar
Syntactic Sugar:
| Code | Explanation | Extended Form |
| ---  | --- | --- |
| `x.toString`  | Empty `()` in function calls can be removed if does not mutate `x`  | `x.toString()` |
| `1 to 10` | Single argument calls can be replaced with method name and spaces | `1.to(10)` |
| `x(2)` | Calls the `.apply()` method in `x` with argument `2` | `x.apply(2)` |
| `key -> value` | Creates a pair tuple of `key` and `value` | `(key, value)` |

> Scala has no distinction between valid method names (ie `+` is a valid method name)

#### Multiple Assignment
Multiple Assignment in Scala:
- Tuple assignment:
```scala
val (a, b) = (1, 2) // a = 1, b = 1
```
- Array assignment:
```scala
val Array(head, tail @ _*) = arr // assigns first element to 'head', rest to 'tail'
```
- Regex assignment:
```scala
val regex = "(capture this) (and this) not this".r
val regex(capThis, andThis) = "capture this and this not this"
// capThis = "capture this", andThis = "and this"
```
### Common Operations
Common Operations:

| Code | Explanation |
| ---  | --- |
| `x.toString`  | Convert `x` to string representation |
| `1 to 10` | Create range of no. from 1 to 10 inclusive  |
| `x.sorted` |  Returns x sorted alphanumericaly in ascending order |
| `x.intersect(y)` | Returns the intersection between the two sequences |
| `scala.util.Random.nextInt` | Generates a random integer |

#### String Operations
Common String Operations (`StringOps`) : given `x` is a Scala string

| Code | Explanation |
| ---  | --- |
| `s.toLowercase` | Convert letters in `s` to lowercase |
| `s.toUppercase` | Convert letters in `s` to uppercase |
| `s.split(c)` | Tokenize / Split string into tokens delimited by `c` |

#### Math Operations
Math operations are located in the `scala.math` package:
```scala
import scala.math._  // '_' acts as wildcard import
```

| Code | Explanation |
| ---  | --- |
| `sqrt(x)` | Computes $\sqrt{x}$ |
| `pow(x, y)` | Computes $x^y$ |
| `min(x, y)` | Computes the minimum of `x` &amp; `y` |

## Operators
Scala supports the [boolean/math/bitwise operators](https://www.geeksforgeeks.org/operators-in-scala/) in Java/C++

Scala supports operator overloading, so library/user defined objects might have custom implementations

In scala `_` is a wildcard operator that can have [multiple uses](https://ananthakumaran.in/2010/03/29/scala-underscore-magic.html):
- Defines anonymous functions by implicitly referring to parameters
```scala
// List(1,2,3,4,5).foreach( a => print(a))
List(1,2,3,4,5).foreach(print(_))
// List(1,2,3,4,5).reduceLeft((a, b) => a + b)
List(1,2,3,4,5).reduceLeft(_ + _)
```
- Wildcard imports

```scala
// import everything under `scala.util.matching`
import scala.util.matching._
```

- [Pattern matching](#pattern-matching)
```scala
def matchTest(x: Any): String = x match {
    case 1 => "one"
    case 2 => "two"
    case List(_*)  => " a list with zero or more elements "
    case Map[_,_] => " matches a map with any key type and any value type "
    case _ => "anything else"
}
```

- assigning no arg functions without evaluating them

```scala
def fetch = {
  veryExpensiveOp
  return 2
}
// scala evaluates 'fetch' as no args func
val fetchVal = fetch
// _ prevents scala from evaluating 'fetch'
val fetchFn  = fetch _
```

### Block Expressions
Block expressions evaluate to some value. For example:
```scala
val distance = { 
  val dx = x - x0
  val dy = y - y0
  sqrt(dx * dx + dy * dy) // implicitly assigned to distance variable
}
```
> If the block expression does not evaluate to some value,
> the block returns a `Unit` (ie `void`) value: `()` represents
> a `Unit` literal, which is synonymous with `null` or `nil`.

### Multiline Statements
Extend statements over multiple lines by ending with a character that cannot by the end of a statement:

```scala
// statement cannot end with '*', so the statement continues on the next line
val foobar = foooooooooooooooooooooooooooooooo *
  baaaaaaaaaaaaaaaaaaaaaaaaaaaaaar
```

or with parenthesis `()`:
```scala
var foobar = (foo
  + bar)
```

### Standard Input/Output
Standard Input - `import scala.io`:

| Code | Explaintation |
| --- | --- |
| `val name = StdIn.readline("Name:")` | Prompt the user to enter name and store in `name` |
| `val age = StdIn.readInt()` | Prompt the user to enter age and store in `age` as a integer |


Standard Output:

| Code | Explanation |
| --- | --- |
| `print("thing")` | Print `thing` without a newline |
| `println("thing")` | Print `thing` with a newline |
| `printf("%d things%n", numThings")` | Print with C-style formatted string (`%n` - newline) |
| `print(s"$numThings things")` | Print with string interpolation |
| `print(f"Price: $price%.2f")` | Print with string interpolation and applying C-style formatting. |

### Lazy Expressions 
Lazy expressions are only evaluated when used
```scala
// long network download only happens when words is used.
lazy val words = // long network download 
```

## Control Structures & Functions 
### Conditionals
Conditionals in Scala are like ternary operators in (`Java/C++`)
-  assign s as if x more than 0, otherwise -1
```scala
val s = if(x > 0) 1 else -1
```
- if n is more than 0, multiply r by n and subtract n by 1
```scala
if(n > 0) {
  r = r * n
  n -= 1 
}
```

### Loops
In scala there is `break` or `continue` in loops.
Use instead:
- boolean control variable
- nested functions
- `scala.util.control.Breaks`

#### While
While loops are the same as c++/java
```scala
while(/*loop condition here*/) {
  // do stuff repeatedly here
}
```

#### For
For loops in scala follow the same general structure as c++/java
- for loop will iteratively assign the `some iterator` to each element of `some iterable`
```scala
for(/*some iterator*/  <- /*some iterable*/>){
  // do stuff repeatedly here
}
```
Examples of for loops
| Variant | Description |
| --- | --- |
| `for(i <- 1 to n)` | For loop from 1 to $n$ inclusive |
| `for(i <- 0 until n)` | For loop from 0 to $n$ exclusive |
| `for(c <- "input")` | For loop each character of string `"input"` |
| `for(i <- 1 to n; j <- 1 to m)` | Nested iteration (ie equivalent to `for(i <- 1 to n){ for(j <- 1 to m) { // do stuff }}`)
| `for(i <- 1 to n; j <- 1 to m if  i != j)` | Nested iteration with guard/condition (`i != j`) |
| `val squares = for(i <- 1 to n) { yield i * i  }`| For comprehension to create a generator of squares |

For comprehension generates a result with the type of the first arg:
- Since the first argument `"hello"` is a Scala string,
  this for comprehension would yield `"HIeflmlmop"`
```scala
for (c <- "Hello"; i <- 0 to 1) yield (c + i).toChar
```
- Since the first argument `0 to 1` is a `Range`, this for comprehension would yield
  `Vector('H', 'e', 'l', 'l', 'o', 'I', 'f', 'm', 'm', 'p')`
```scala
for (i <- 0 to 1; c <- "Hello") yield (c + i).toChar
```

#### Match
Pattern matching in scala is its version of a switch:
- based on value:

```scala
value match {
  case 1 => "one"
  case 2 => "two"
  case _ => "some other number"
}

```

- based on condition:

```scala
value match {
  case v if v < 1 " less than one"
  case _ => "some other number"
}
```

- based on type:
```scala
value match {
  case i: Int => "its an int"
  case i: Double => "its a double"
  case _ => "i dont know"
}
```

### Functions
Defining functions in scala:
- one line absolute:
```scala
def abs(x: Double) = if(x >= 0) x else -x
```
- anonymous functions
```scala
(x: Double) => if(x >= 0) x else -x
```
- iterative factorial function
```scala
def factorial(n : Int) = {
  var r = 1
  for (i <- 1 to n) r = r * i
  r
}
```
- recursive factorial function
```scala
def factorial(n: Int): Int = {
  if(n <= 0) 1  else n * fac(n - 1);
}
```
> Return type is required for recursive arguments.
> Otherwise the scala compiler can use type interence to infer the return type.

#### Arguments
Defining function arguments in scala
- default arguments:
``` scala
def wrap(thing: String, left:String="<", right:String=">") = { 
    left + thing + right
}
```
- variable arguments
```scala
def sum(args: Int*) = {
  var result = 0
  for (arg <- args) result += arg
  result
}
```
- passing vector/list as argument 
```scala
let vec = 1 to 5
sum(1 to 5: _*)
```

> When calling functions without arguments the trailing `()` can be obmitted.
> ```scala
> def three() = 1 + 2 
> println(three)

#### Functional: Partially Applied Functions and Currying
Scala allows arguments of a function to be:
Example `def sum(a: Int, b: Int, c: Int) = a + b + c`:
- partially applied
```scala
val plus2and3 = sum(2, 3, _:Int)
plus2and3(4)
```
- curried functions - function that takes arguments one at a time
```scala
// either: defined as curried function
def curriedSum(a: Int)(b: Int)(c: Int) = a + b + c
// or: convert normal function to curried function
val curriedSum = (sum _).curried
// apply arguments one by on
val plus2 = curriedSum(2)
val plus2and3 = curriedSum(3)
plus2and3(4)
```

#### Functional: Function Composition 

```scala
def f(s: String) = "f(" + s + ")"
def g(s: String) = "g(" + s + ")"

// f(g(s))
val fg = f _ compose g _
// g(f(s))
val gf = f _ andThen g _
```

#### Functional: Partial Functions
Functions that are only defined at some value(s):
- use  `{}` and `case` to define a partial function. (see [Pattern Matching](#pattern-matching))
```scala
// partial function only defined at 
val two: PartialFunction[Int, String] = { case 2 => "two" }
```
- Use `.lift` to convert a partial function to a normal function with `Option` return:
```scala
two.lift // normal Function[Int, Option[String]]
```

> :warning:: If the catchall `catch _` is used, the function defined will be a normal function.

### Exceptions
Exceptions are similar to c++/java:
- throwing exceptions
```scala
throw new IllegalArgumentException("x should not be negative")
```
- try/catch/finally - same:
```scala
try {
  // stuff
} catch  {
  case e: SomeException  => /* Do stuff to recover */
  case _: SomeOtherException  => /* Do stuff to recover */
} finally {
  // always runs :ie for cleanup
}
```

## Data Structures
### Arrays
Arrays in Scala:
- `Array` - constant size array
```scala
// array of 10 ints
val nums = new Array[Int](10)
// multidim arrays 10 by 2 by 3
val nums = new Array.ofDim[Int](10, 2, 3)
// literal array
val s = Array("Hello", "World")
// use () to access elements. prints "Hello"
println(s(0))
```
- `List` - linked list version of array
- `ArrayBuffer` - variable sized array
```scala
import scala.collection.mutable.ArrayBuffer
val varNums = ArrayBuffer[Int]()
varNums += 1 // append 1 to the array
varNums += (2, 3, 4, 5) // append a literal list
varNums ++= nums // append the contents of the array
```
- `ListBuffer` - variable size list.

> Array and Lists in scala corresponds to ArrayList and LinkedList in java.

#### Sequence / Iterable Operations
Common Iterable Operations:

| Description | Example |
| --- | --- |
| Collect the indexes of elements `< 0` | `for (i <- a.indices if a(i) < 0) yield i` |
| Compute the sum/max | `a.sum; a.max` |
| Sort sequence in ascending order | `a.sorted` |
| Find first element matching | `a.find(_ == 2)` |
| Sort sequence with comparison function | `a.sortWith(_ > _) // descending order` |
| Zip two equal length sequences together | `val zipped = a.zip(b);` |
| Partition elements in sequence into two sequences based on function | `val (even, odd) = a.partition(_ % 2 == 0)` |
| Filter sequence to vals `< 2` |  `a.filter(_ < 2)` |
| Use a `for yield` loop to transform the array | `for(elem <- a if elem >= 0) yield 2 * elem` |
| Run `fn` over each element in the sequence | `a.forEach(fn)` |
| Accumulate from start to end, using `begin` as starting value | `a.foldLeft(begin)(_ + _)` |
| Accumulate from end to start, using `begin` as starting value | `a.foldRight(begin)(_ + _)` |
| Flatten multidim sequence | `A.flatten` |

> Maps are actually a sequence oof tuples, so sequence operations work on them to.

### Maps
Maps are scala's dictionary data structures:
- `Map` - immutable map
```scala
var scores = Map("Alice" -> 10, "Bob" -> 3, "Cindy" -> 8)
// use () to access elements. 10
println(scores("Alice"))
// create a new map with updates
scores = scores + ("Bob" -> 10, "Fred" -> 7)
//  ^ equivalent:
scores += ("Bob" -> 10, "Fred" -> 7)
// create a new map with key removed 
scores = scores - "Alice"
//  ^ equivalent:
scores -= "Alice"
// set default value to length of name (key of map) if missing
scores.withDefault(_.length)
scores("david") // = 5
```
- `mutable.Map` - mutable map (hash table)
```scala
import scala.collection.mutable
val scores = mutable.Map[String, Int]()
// assign Bob -> 10 mapping to map
scores("Bob") = 10
// multiple assigns
scores += ("Bob" -> 10, "Fred" -> 7)
// remove stuff
scores -= "Alice"
```
- `mutable.SortedMap` - sorted mutable map (BST)
```scala
import scala.collection.mutable
// use when sorted order is important
val scores = mutable.SortedMap[String, Int]()
```

#### Maps Ops
Common Maps Ops:

| Description | Example |
| --- | --- |
| Check if key exists in map | `m.contains("Bob")` |
| Get an `Option` Optional wrapping nothing or the gotten value | `m.get("key")` |
| Get with default value | `m.getOrElse("Bob", 0)` |
| Iterate over maps `keys` and `values` | `for((k, v) <- m) // do stuff with k & v` |

### Tuples
Tuples - static collection of values of type `TupleN` where `N` is no. of elements
```scala
val t:(Int, Double, String) = (1, 3.14, "Fred")
// assign individual elements with ._1, ._2, ....
t._3 // = "Fred"
// assign elements to variables
val (num, pi, name) = t
// assign some elements to variables
val (num, pi, _) = t
```
> Tuples are used to return multiple values in functions

### Option
Optionals in Scala are `Option[T]`: May or may not hold value:
```scala
val value: Option[string]  = map.get(key)
if value.isDefined {
  // ...
}
```

## Object Oriented Programming
#### Defining Classes
Defining classes in Scala:
```scala
// classes default by default 
class Counter(initalValue:Int=0, name:String="Counter") { // define params of primary constructor
  // code outside of a method is placed inside primary constructor
  var value:Int = initalValue // define a property
  val name:String = name // constant property
  // Methods are public by default
  def increment() { value += 1 }
  def current() = value
}
```

> Inner/Nested classes are also possbile although this caveat should be noted:
> Each instance of the object has its own class, meaning that:  
> `Array[Class.InnerClass]` is not allowed  
> use `Array[Class#InnerClass]` instead


#### Constructors/Factory Methods
Creating objects with constructors/factory methods in Scala:
- primary constructor - defined inline with the class

```scala
class Person(val name:String, var age:Int, private var income:Float) { 
  // ^ short hand for 
  // val name:String = name
  // var age:Int = age
  // private var income:Float = age
}
```
> Params in the primary constructor automatically become `private[this]` fields
> when being used outside the constructor (ie another method)

- auxiliary constructor - must call primary constructor directly or indirectly 
   (ie through another auxiliary constructor) as the **first line**

```scala
class Person(val name:String, var age:Int, private var income:Float) { 
  // primary constructor code here ...
  // auxiliary constructor with default values
  def this(name:String) {
    this(name, 0, 0)
  }
}
```
- factory methods in companion object

```scala
class Person(val name:String, var age:Int, private var income:Float) { 
  // ...
}
// companion object - same name as the class
object Person {
  // factory method to construct a Person from js
  def apply(personJson:String): Person = {
    // parse json here ...
    return new Person(name, age, income)
  }
}
```

#### Setters & Getters
Scala automatically generates getters and setters for properties.
(ie for `value` scala generates `value()` getter and `value_=` setter)
- Default scala setters and getters:

```scala
class Counter(initalValue:Int=0, name:String="Counter") { 
  private var value:Int = initalValue // define a property
  def value_=(newValue: Int) { /* overwrite setter */ }
  def value() { /* overwrite getter*/ }
}
```
> Override these methods to add functionality when setting or getting property

#### Access Control
By default classes/methods/properties in scala are public.
Use access control modifiers to control access:

| Access Control Modifier | Description |
| --- | --- |
| `private` | Limit access to all object/instances of the same class |
| `private[this]` | Limit access only this instance of the class |


##### Readonly Properties
Defining mutable readonly properties in Scala:
```scala
class Counter(initalValue:Int=0, name:String="Counter") { 
  private var value:Int = initalValue // define a private property
  def increment() { 
    value += 1 
  }
  // obmit () - current can only be accessed without ()
  def current = value
}
```

> By convention, obmit () in methods that take no parameters have no side effects.

### Instances
#### Creating Instances
Creating objects in Scala is almost exactly what you expect:
```scala
val counter = new Counter(1, "A Counter")
// or - () not required if no arguments are passed
val counter = new Counter
```

## Java Interop
Interop Scala with Java

### Data Structures
Data Structure / Collection Java Interop:
- import converters: `import scala.jdk.CollectionConverters._`
- calling `.asJava` converts scala types to java types
  ```scala
  import scala.jdk.CollectionConverters._
  import java.util.HashMap
  val scalaMap = Map("name" -> "James", "address" -> "10 Downing Street")
  val javaMap = new HashMap[String, String](scalaMap.asJava)
  ```
- calling `.asScala` converts java types to scala types

### Functions
Function Java Interop:
- import converters: `import scala.jdk.FunctionConverters._`
- calling `.asJava` converts Scala functions / lambdas to Java `Function`:
  ```scala
  val f = i => i > 7
  f.asjava // now a java Function
  ```
- calling `.asScala` converts Java `Function` back to Scala function (`FunctionN`)


### Streams
Converting Scala Collections into Java 8 Streams:
- import converters: `import scala.jdk.StreamConverters._`
- call `.asJavaSeqStream` for a sync Java Stream, `.asJavaParStream` for a parallel stream.
- use `toScala` to convert Java Streams back to Scala collections.

### Getters & Setters
Java native tools expect Java style getter and setters (ie `getX(); setX()`)
- Use `@BeanProperty` to generate Java style getters/setters (ie `getX(); setX()`) for Scala classes.

```scala
import scala.beans.BeanProperty
class Counter(initalValue:Int=0, name:String="Counter") { 
  @BeanProperty var value:Int = initalValue
}
```



## Scala OOP
Object Oriented Programming in Scala

### Classes
Defining a class:
```scala
class Calculator {
   // Property
   val brand: String  = "HP"
   // method
   def add(m: Int, n:Int): Int = m + n
}
```

#### Constructors
Scala constructors are defined as methods outside of the class:
```scala
class Calculator(brandCode: String) {
    // Constructor code includes all code outside of methods
    var brandName: String = if(brandCode == "TI")  {
        "Texas Instruments" 
    } else if (brand == "C") {
        "Casio"
    } else {
        "Unknown"
    }
}
```

### Inheritance
Inheritance in Scala:
```scala
// Inherit from class
class ScientificCalculator(brand: String) extends Calculator(brand) {
  def log(m: Double, base: Double) = math.log(m) / math.log(base)
  def toString = "scientific_calc"
}
// Override/Overload method in class
class EvenMoreScientificCalculator(brand: String) extends ScientificCalculator(brand) {
  def log(m: Int): Double = log(m, math.exp(1))
  // 'override' keyword is compulsory when overriding methods
  // 'super` keyboard used to qualify `toString` method from superclass.
  override def toString = s"even_more_${super.toString}"
}
```
- Use `super` to refer to the superclass, `override` when overriding methods.
- Get the class of instance `x`: `classOf[x]`
- Check if a instance `x` is subclass of class `X`: `x.isInstanceOf[X]`
- Cast instance `x` is to type `X`: `x.asInstanceOf[X]`

> [Pattern Matching](#pattern-matching) provides a more consise syntax
> when matching instances multiple types

### Traits & Abstract Classes
Traits are the interfaces in Java/Golang:
```scala
trait Calculator {
  def log(m: Double, base: Double): Double
}

trait Computer {
  val processor: Int
  val os: String
}

class VirtualCalculator extends Calculator with Computer {
  val processor = "amd"
  val os = "linux"
  def log(m: Double, base: Double) = math.log(m) / math.log(base)
}
```

> Functions are actually objects in Scala that extends the `FunctionX[args...,return]` trait
> Where `X` refers to the number of arguments (1 - 22). This allows us to define class functions:
> ```scala
> // (Int => Int) is a shorthand for Function1[Int, Int]
> class AddOne extends (Int => Int) {
>   def apply(m: Int): Int = m + 1
> }
> ```

Abstract classes can also be used to define methods that subclasses should implement:
```scala
abstract class Shape {
  // subclass should define this
  def area():Int
}

class Shape(r : Int) extends {
  def area() = {r * r * 3}
}
```

> Abstract Class vs Trait: If u need a constructor use an abstract class.
> Use traits otherwise.

### Objects
Objects are singletons of a class:
- Companion Objects: Objects with the same name as a class.
```scala 
class Bar(foo: String) 
// companion object defines a factory for the bar class
object Bar {
 def apply(foo: String) = new Bar(foo)
}

val bar = Bar("johnny")
```

Values and functions cannot be defined outside of a class or object.
Objects makes nice wrappers for them:
```scala
package com.example
// Defining a "enum"
object colors {
  val BLUE = "Blue"
  val RED = "Red"
}
```

### Access Modifiers
Access Modifiers in Scala:
- for fields:

| Access Modifier | Description |
| --- | --- |
| `private[this]` | Only within the current instance `this` |
| `private` | Only within class the field is defined in  &amp; all its instances. No subclass / package access. |
| `protected` | Class the field is defined in &amp; its subclasses, instances. No package access. |
| `public` | Fully accessible |

- for classes:

| Access Modifier | Description |
| --- | --- |
| `final` | The class cannot be extended |
| `sealed` | The class can only be extended in the same source file as itself. |

### Enumerations
Enumerations are implemented by extending the `Enumeration` object:
- assigning fields to `Value` automatically provides field with a unique value:
```scala
object Status extends Enumeration {
  val Ok, Waiting, Error = Value
}
```

### Case Classes
Case Classes:
- optimized for [Pattern Matching](#pattern-matching)
- class fields are converted into constant `val`s
- POJOs in Scala with already implemented:
  - `apply()` method for `new` free instance creation.
  - `unapply()` method for automatic unpacking.
  - `equals`, `toString`, `hashCode`, `copy` methods
```
case class Calculator(brand: String, model: String)
```

Case Classes can be used to implement different cases of a supertype (ie `Amount`):
- `Dollar` and `Currency` are subtype cases of `Amount`
```scala
abstract class Amount
case class Dollar(value: Double) extends Amount
case class Currency(value: Double, unit: String) extends Amount
```

### Generics
Generics can be used to define methods:
```scala
trait Cache[K, V] {
  def get(key: K): V
  //...
}

// and functions
def remove[K](key: K)
```



## Packages &amp; Imports

### Package
Packages in scala can store Objects, Classes, Traits.

Defining package the scala:
```scala
package com.example.thing {
   // ...

}
```
- is equalvilent defining to nested packages:
```scala
package com {
  package example {
    package thing {
      // ...
    }
  }
}
```
- is equavilent to entire file package declaration:
```scala
package com.example.thing;
// ...
```
- package have package objects to store variable and functions:
```scala
// define in package objects
package object com.example.thing {
  def doStuff() = // ...
}

package {
  // code that uses doStuff()
}
```


### Imports
Imports reduce typing by removing the need to type the fully qualified identifier:
```scala
import com.example.thing._ // wildcard import "com.example.thing" package
```
- renaming imported members / from-in imports: 
```scala
import java.util.{HashMap => JavaHashMap}
```


## File I/O &amp; Regex
### Reading Input
#### Reading from stdin
Reading input from stdin in Scala:
- `scala.io` provides convenience `.readX` methods:
  - read specific data types: `.readBoolean, .readDouble, .readInt`
  - read line: `.readLine, .readLines`
  - `scanf()` like read from stdin: `.readf`

#### Reading from File
Reading input from a text File in  Scala:
1. Open the file as a `Source`:
- Text file as input source: Use `scala.io.Source.fromFile()` to load a file source:
```scala
import scala.io.Source
val source = Source.fromFile("myfile.txt", "UTF-8")
```
2. Read input from the `Source`:
- Read text:
  - `.getLines()` to read lines: 
  ```scala
  val lines = source.getLines
  for(line <- lines) // do stuff with line from myfile.txt
  ```
  - `.mkString()` to read entire file as string,
  - directly iterate text characters in the file by looping over source:
  ```scala
  for(c <- source) // do stuff with character from myfile.txt
  ```
  - lookahead text characters without consuming them using `.buffered`
- Read numbers: Read as text, then use methods like `.toInteger` `.toDouble` to convert to numbers.

#### Reading from URL
Reading input from a web text File in Scala:
1. Open the file's URL as a `Source`:
```scala
val source1 = Source.fromURL("http://horstmann.com", "UTF-8")
```
2. Follow [Reading from File](reading-from-file) from step 2 onwards.

#### Reading Binary Files
Read binary files via Java in Scala:
- use `java.io` Java classes to open the file for use in Scala
```scala
val file = new File(filename)
val in = new FileInputStream(file)
val bytes = new Array[Byte](file.length.toInt)
in.read(bytes)
in.close()
```

### Writing Files
Writing files in Scala needs to be done with Java:
- use `java.io.PrintWriter` to write files:
```scala
val (quantity, price) = 25, 2.01
val out = new PrintWriter("out.txt")
out.printf(f"$quantity%d @ $price%10.2f")
```

### Regular Expressions
Regular Expressions (regex) in Scala:
- Scala strings can be converted to `scala.util.matching.Regex` via `.r` method:
```scala
"[0-9]*".r
```
- use `"""` instead of `"`/`'` when writing regex to avoid having to escape backslashes (`//`)

#### Matching / Replacing Regular Expressions
Matching / Replace regex in Scala:
- use `.findAllIn` to find all matches, `.findFirstIn` to find first match.
- replace matches of regex with: `.replaceFirstIn`, `.replaceAllIn`
- `.replaceSomeIn` allows replacement with filter / predicate:
```scala
"[0-9]+".r.replaceSomeIn("99 bottles, 98 bottles",
  m => if (m.matched.toInt % 2 == 0) Some("XX") else None)
// = "99 bottles, XX bottles"
```
- groups in regex `(capture this) (and this) not this` can be matched with:
  - `findAllMatchIn`, `findFirstMatchIn` returning a `Match` instance
  - groups can be accessed by `.group` on the `Match` instance
  - or use the multiple assignment shorthand syntax:
```scala
val regex = "(capture this) (and this) not this".r
val regex(capThis, andThis) = "capture this and this not this"
// capThis = "capture this", andThis = "and this"
```

## Pattern Matching
### Pattern Matching 
Pattern Matching in Scala: `match` statement
- implement `switch` statements: (ie do different things based on data value / type).
- unpacking: extract elements from data structures.

#### Switch Statement
Pattern Matching to implement switch statement:
- `break` is implicit for each case, there is no 'fallthrough' between cases
- `case _` is a catchall default case
- `case NAME` is a catchall default case with the match target assigned to variable with `NAME`
> Warning :warning:: Scala assumes all names starting  with a lowercase character
> to be variable name to be assigned to. To use an existing expression with a 
> starting with lowercase character in case statement, backquote the expression: ``` `NAME` ```
- `case _: TYPE` or `case NAME: TYPE` matches based on data type.
> 
> Warning :warning:: When matching generic types like `Map` match against
> the generic version of the type ie `Map[_, _]` instead of ie `Map[String, Int]`

```scala
// example CLI option menu implemented with match statement
// ... read a option as 'option' ...
val response = option match {
  case 1 => "Option 1"
  case 2 | 3 => "Option 2 or 3"
  // 'case opt' assigns 'option' to 'opt' before executin
  case opt: Int => s"Unknown option $opt"
  case opt: String => "Expected an integer option"
  case opt @ (_: Char, _: Float) => s"Float or Char opt: $opt"
}
println(response)
```

#### Guards
Pattern Matching allows a guard if condition to be specified for each case:
- case only executes the case matches _and_ the if condition is true.
- useful to provide a case condition for catch default cases.
```scala
// ... read a character as 'c' ...
c match {
  // case runs if matches (catchall in this example) and c is a digit character
  case _ if Character.isDigit(ch) => digit = Character.digit(ch, 10)
  // ...
}
```

#### Unpacking
Unpacking / Destructuring data structures / regex while using pattern matching:
- case can unpack anything that can be used for  [Multiple Assignment](#multiple-assignment)
  - case can be tasked to unpack data structures such as `Array`, case classes &amp; unpack them:
  ```scala
  // ... construct 'obj' somewhere ...
  obj match {
    // matches array of size two, assigns elements to 'x' & 'y'
    case Array(x, y) => // do something  ...
    // matcfh array of any size, assign first element to 'x', rest to 'tail'
    case Array(head, tail @ _*) => // do something  ...
  }
  ```
  - case can be taksed to unpack regex groups:
  ```scala
  val pattern = "([0-9]+) ([a-z]+)".r
  "99 bottles" match {
    case pattern(num, item) => ...
      // Sets num to "99", item to "bottles"
  } ```

