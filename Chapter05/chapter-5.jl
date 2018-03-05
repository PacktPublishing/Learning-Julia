# compound expressions
julia> volume = begin
           len = 10
           breadth = 20
           height = 30
       len * breadth * height
       end
6000

# Alternate method using ;
julia> volume = (length = 10; breadth = 20; height = 30; length * breadth * height)
6000

# conditional evaluation 
# FizzBuzz algorithm
julia> for i in 1:30
           if i % 3 == 0 && i % 5 == 0
               println("FizzBuzz")
           elseif i % 3 == 0
               println("Fizz")
           elseif i % 5 == 0
               println("Buzz")
           else
               println(i)
           end
       end
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
16
17
Fizz
19
Buzz
Fizz
22
23
Fizz
Buzz
26
Fizz
28
29
FizzBuzz

# checking prime number
# first find factors
julia> function factors(num)
           factors = []
           for i in 1:num
               if rem(num, i) == 0
                   push!(factors, i)
               end
           end
           return factors
       end
factors (generic function with 1 method)

# check if the number was prime
julia> function is_prime(num)
           factors_array = factors(num)
           if length(factors_array) == 2
               true
           else
               false
           end
       end
is_prime (generic function with 1 method)

julia> is_prime(10)
false

julia> is_prime(11)
true


# if blocks are leacky
# here parity is being declared inside a if block, but is still accessible to the println function
julia> function f(n)
           if n % 2 == 0
               parity = "even"
           else
               parity = "odd"
           end
           println("the number is $parity")
       end
f (generic function with 1 method)

julia> f(2)
the number is even

julia> f(3)
the number is odd


# if blocks return values!
julia> switch = true
true

julia> y = if switch println("switch is ON") else println("switch is OFF") end
switch is ON


# although
julia> 1 == true
true

# BUT....If block does NOT translate 1/0 to true/false
# julia> if 1 println("true") end
# ERROR: TypeError: non-boolean (Int64) used in boolean context


### ternary operators
julia> name = "julia"
"julia"

julia> isa(name, String) ? "its a string" : "nopes, not a string"
"its a string"


### short - circuit evaluation

# this method is now deprecated
julia> isdigit("10") && println("reached me")
reached me

# newer method
julia> all(isdigit, "10") && println("reached me")
reached me

julia> all(isdigit, "ten") && println("reached me")
false



### Repeated evaluation

# over integers
julia> collection = [1,2,3,4,5,6,7,8,9]
9-element Array{Int64,1}:
 1
 2
 3
 4
 5
 6
 7
 8
 9

julia> while length(collection) > 1
           pop!(collection)
           println(collection)
       end
[1, 2, 3, 4, 5, 6, 7, 8]
[1, 2, 3, 4, 5, 6, 7]
[1, 2, 3, 4, 5, 6]
[1, 2, 3, 4, 5]
[1, 2, 3, 4]
[1, 2, 3]
[1, 2]
[1]

# over strings
julia> statement = "This is a great example!"
"This is a great example!"

julia> for word in split(statement)
           println(word)
       end
This
is
a
great
example!

# slicing
julia> statement = "Yet another awesome example"
"Yet another awesome example"

julia> for word in split(statement)[2:4]
           println(word)
       end
another
awesome
example

julia> for word in split(statement)[2:3:4]
           println(word)
       end
another

# defining range of numbers
# range can be defined using a syntax similar to start:end example, 
julia> for i in 1:5
           print("*",i,"\n", "\t"^i)
       end
*1
	*2
		*3
			*4
				*5


# playing around with loops for fun
julia> for i in 1:5
           for j in 1:i
               print("*")
           end
           println("")
       end
*
**
***
****
*****

julia> for i in 5:-1:1
           for j in 1:i
               print("*")
           end
           println("")
       end
*****
****
***
**
*

# reverse a string
julia> my_string = "This is a great thing to do!"
"This is a great thing to do!"

julia> my_string[length(my_string):-1:1]
"!od ot gniht taerg a si sihT"


# break/continue
julia> for letter in word
           println(letter)
           if letter == 'i'
               break
           end
       end
j
u
l
i

julia> for letter in word
           println(letter)
           if letter == 'l'
               continue
           end
       end
j
u
l
i
a


### Exception handling

# exception is a data type in julia
julia> typeof(Exception)
DataType

# using try catch along with throw()
julia> function say_hi(name)
           try
               if typeof(name) != String
                   throw(TypeError(:say_hi, "printing name", String, name))
               else
                   println("hi $name")
               end
           catch e
               println(typeof(e))
           end
       end
say_hi (generic function with 1 method)

# throws exception as `n` is a Char not a String type
julia> say_hi('n')
TypeError

julia> say_hi("rahul")
hi rahul

# error/warn/info
julia> info("This is an information")
INFO: This is an information

julia> warn("This is a warning")
WARNING: This is a warning

julia> error("This is an error")
ERROR: This is an error
Stacktrace:
 [1] error(::String) at ./error.jl:21


# try/catch/finally
julia> try
           exponent("alpha")
       catch e
           println(e)
       finally
           print("Goodbye")
       end
MethodError(exponent, ("alpha",), 0x0000000000005546)
Goodbye


### Tasks in Julia
julia> function add_one()
           a = 1
           # produce() is now deprecated
           produce(a)
           while true
               a += 1
               produce(a)
           end
       end

julia> generator = Task(add_one)
Task (runnable) @0x000000010eecb850

# consume is deprecated
julia> consume(generator)
1

julia> consume(generator)
2

julia> consume(generator)
3

# valid for julia 0.5
julia> function sample_task()
			for i in 1:3
				produce(i^2)
			end
			produce("END")
			end

julia> result = Task(sample_task)
Task(runnable) @0x0000000113bfc6d0

julia> consume(result)
1

julia> consume(result)
4

julia> consume(result)
9

julia> consume(result)
"END"

julia> consume(result)
()

## helpful external links:
# https://docs.julialang.org/en/latest/manual/parallel-computing/#Channels-1
# https://discourse.julialang.org/t/how-to-replace-consume-and-produce-with-channels/5125/9











