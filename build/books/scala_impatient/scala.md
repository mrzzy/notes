# Scala Notes
References _Scala for the Impatient_ Book and [Twitter's Scala School](https://twitter.github.io/scala_school/)
Rights and Credits belong to their repective authors

## SBT - Simple Built Tool
References [SBT: The Missing Tutorial](https://github.com/shekhargulati/52-technologies-in-2016/blob/master/02-sbt/README.md)

SBT is scala's project build tool:
- `sbt` on the project directory to start sbt shell
- place `~` before `sbt` sub command to make the subcommand to automatically run on code changese
- join subcommands with `:`  (ie `compile:run`) 
- place project source in `src/main/scala/`
- place test cases in `src/test/scala/`

Commands that can be used in `sbt`:
- `run` - runs the current project
- `compile` - compiles the current project


### build.sbt file
Config scala version and other project metadata  in `build.sbt` located at the base directory:
```scala
name := "testing"
version := "0.1.0"
scalaVersion := "2.11.6"
```
> Reload changes in `build.sbt` using  `reload` subcommand.

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
### Types
Basic types simliar to `java`: `Int`, `Byte`, `Char`, `Short`, `Float`, `Double`
- except there is no distinction between primatives and class types:
Extended types: `BigInt` and `BigDecimal`

Sequence types: `Range[]`, `Seq[]`, `GenSeq[]`, `GenIterable[]`, `GenTraversableOnce[]`

Void value: `Unit` or `()`

### Variables and Constants
Variable and Constants:

| Code | Explaination |
| ---  | --- |
| `val x = 0` | Define a constant `x` assigned with the value `0` |
| `var x = 0` | Define a variable `x` assigned with the value `0` |
| `val x:String = "hello"` | Define a constant of  `x` assigned with the value `"hello"` |
| `val x, y = 0` | Define both constants `x` and `y` with the value `0` |
| `val x, y:String = "hello` | Define both constants `x` and `y` with the value `"hello"` |

> use constants wherever possible, variables only when necesseary.

### Syntactic Sugar
Syntactic Sugar:

| Code | Explaination | Extended Form |
| ---  | --- | --- |
| `x.toString`  | Empty `()` in function calls can be removed if does not mutate `x`  | `x.toString()` |
| `1 to 10` | Single argument calls can be replaced with method name and spaces | `1.to(10)` |
| `x(2)` | Calls the `.apply()` method in `x` with argument `2` | `x.apply(2)` |

> Scala has no distinction between valid method names (ie `+` is a valid method name)

### Common Operations
Common Operations:

| Code | Explaination |
| ---  | --- |
| `x.toString`  | Convert `x` to string representation |
| `1 to 10` | Create range of no. from 1 to 10 inclusive  |
| `x.sorted` |  Returns x sorted alphanumericaly in ascending order |

### Block Expressions
Block expressions evaluate to some value. For example:
```scala
val distance = { 
  val dx = x - x0
  val dy = y - y0
  sqrt(dx * dx + dy * dy) // implictly assigned to distance variable
}
```
> If the block expression does not evaluate to some value, 
> the block returns a `Unit` (ie `void`)value.

### Standard Input/Output
Standard Input - `import scala.io`:

| Code | Explaintation |
| --- | --- |
| `val name = StdIn.readline("Name:")` | Prompt the user to enter name and store in `name` |
| `val age = StdIn.readInt()` | Prompt the user to enter age and store in `age` as a integer |


Standard Output:

| Code | Explaination |
| --- | --- |
| `print("thing")` | Print `thing` without a newline |
| `println("thing")` | Print `thing` with a newline |
| `printf("%d things%n", numThings")` | Print with C-style formatted string (`%n` - newline) |
| `print(f"\$numThings things")` | Print with string interpolation |
| `print(f"Price: \$price%.2f")` | Print with string interpolation and applying C-style formating. |

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
| `for(i <- 1 to n)` | For loop from 1 to <img src="./assets/55a049b8f161ae7cfeb0197d75aff967.svg?sanitize=true&invert_in_darkmode" align=middle width=9.867000000000003pt height=14.155350000000013pt/> inclusive |
| `for(i <- 0 until n)` | For loop from 0 to <img src="./assets/55a049b8f161ae7cfeb0197d75aff967.svg?sanitize=true&invert_in_darkmode" align=middle width=9.867000000000003pt height=14.155350000000013pt/> exclusive |
| `for(c <- "input")` | For loop each character of string `"input"` |
| `for(i <- 1 to n; j <- 1 to m)` | Nested iteration (ie equivilent to `for(i <- 1 to n){ for(j <- 1 to m) { // do stuff }}`)
| `for(i <- 1 to n; j <- 1 to m if  i != j)` | Nested iteration with guard/condition (`i != j`) |
| `val sqaures = for(i <- 1 to n) { yield i * i  }`| For comprehension to create a vector of squares |

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
- recusive factorial function
```scala
def factorial(n: Int): Int = {
  if(n <= 0) 1  else n * fac(n - 1);
}
```
> Return type is required for recusive arguments


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

#### Functional: Partials and Curryin
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

### Exceptions
Exceptions are simliar to c++/java:
- throwing exceptions
```scala
throw new IllegalArgumentException("x should not be negative")
```
- try/catch/finally - same:
```scala
try {
  // stuff
} catch  {
  case exception: /* SomeException */ => /* Do stuff to recover */
  case exception: /* SomeOtherException  */ => /* Do stuff to recover */
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
- `ArrayBuffer` - variable sized array
```scala
import scala.collection.mutable.ArrayBuffer
val varNums = ArrayBuffer[Int]()
varNums += 1 // append 1 to the array
varNums += (2, 3, 4, 5) // append a literal list
varNums ++= nums // append the contents of the array
```

#### Array Ops
Common Arrays Ops:

| Description | Example |
| --- | --- |
| Use a `for yield` loop to transform the array | `for(elem <- a if elem >= 0) yield 2 * elem` |
| Collect the indexes of elements `< 0` | `for (i <- a.indices if a(i) < 0) yield i` |
| Compute the sum/max | `a.sum; a.max` |
| Sort array ascending order | `a.sorted` |
| Sort array with comparision function | `a.sortWith(_ > _) // decending order` |
| Zip two equal length arrays together | `val zipped = a.zip(b);` |

### Maps
Maps are scala's dictionary data structures:
- `Map` - constant size map
```scala
var scores = Map("Alice" -> 10, "Bob" -> 3, "Cindy" -> 8)
// use () to access elements. 10
println(scores("Alice"))
// create a new map with updates
scores = scores + ("Bob" -> 10, "Fred" -> 7)
//  ^ equivilent:
scores += ("Bob" -> 10, "Fred" -> 7)
// create a new map with key removed 
scores = scores - "Alice"
//  ^ equivilent:
scores -= "Alice"
```
- `mutable.Map` - mutable map (hash table)
```scala
import scala.collection.mutable val scores = mutable.Map[String, Int]()
// assign Bob -> 10 mapping to map
scores("Bob") = 10
// multiple assigns
scores += ("Bob" -> 10, "Fred" -> 7)
// remove stuff
scores -= "Alice"
```
- `mutable` - mutable map (BST)
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
| Get with default value| `m.getOrElse("Bob", 0)` |
| Iterate over maps `keys` and `values` | `for((k, v) <- m) // do stuff with k & v` |

### Tuples
Tuples - static collection of values
```scala
val t:(Int, Double, String) = (1, 3.14, "Fred")
// assign elements to variabless
val (num, pi, name) = t
```
> Tuples are used to return multiple values in functions

## Object Oriented Programming
### Classes
```scala
```

## Java Interop
Interop with java stuff

### Data Structures
Java Interops - `import scala.collection.JavaConverters._`

Java Interops Examples:
- convert scala map to java map
```scala
import scala.collection.JavaConverters._
import java.util.HashMap
val scalaMap = Map("name" -> "James", "address" -> "10 Downing Street")
val javaMap = new HashMap[String, String](scalaMap.asJava)
```
