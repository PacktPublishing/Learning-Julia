### interacting with the system
julia>;

shell> pwd
/Users/rahullakhanpal/learning-julia

# or alternatively, using 
julia> pwd()
"/Users/rahullakhanpal/learning-julia"

# to know your home directory
julia> homedir()
"/Users/rahullakhanpal"

# to join two paths
julia> joinpath(homedir(), "Documents")
"/Users/rahullakhanpal/Documents"

# read the contents of a directory
julia> readdir(pwd())
8-element Array{String,1}:
 ".git"      
 ".gitignore"
 "chapter-1" 
 "chapter-2" 
 "chapter-3" 
 "chapter-4" 
 "chapter-5" 
 "chapter-6" 

# stat over any random file
julia> stat(".gitignore")
StatStruct(mode=0o100644, size=21)

# check if its a file
julia> isfile(".gitignore")
true

# check if its a directory
julia> isdir(".git")
true

# knowing basename of the home directory
julia> basename(homedir())
"rahullakhanpal"

# to split the directory structure
julia> splitdir(homedir())
("/Users", "rahullakhanpal")

# to check if its a path
julia> ispath(homedir())
true

# to know absolute path of current directory
julia> abspath(".")
"/Users/rahullakhanpal/learning-julia/"


### I/O Operations

# to open a file and read its contents in Julia
julia> file = open("sample.txt")
IOStream(<file sample.txt>)
julia> readlines(file)
2-element Array{String,1}:
 "Hi there! my name is Rahul."   
 "Learning Julia is so much fun."

# to write into a file in julia
julia> write("sample.txt", "Thats a line using the write() function")
39
julia> readlines("sample.txt")
1-element Array{String,1}:
 "Thats a line using the write() function"

# close a file, where,
# file = "sample.txt"
julia> close(file)



### Example to create a shell script that accepts arguments

# create a file input.txt in the current directory and put the following in it
shell> cat input.txt
Julia is a high-level, high-performance dynamic programming language for numerical computing. It provides a sophisticated compiler, distributed parallel execution, numerical accuracy, and an extensive mathematical function library. Julia’s Base library, largely written in Julia itself, also integrates mature, best-of-breed open source C and Fortran libraries for linear algebra, random number generation, signal processing, and string processing. In addition, the Julia developer community is contributing a number of external packages through Julia’s built-in package manager at a rapid pace. IJulia, a collaboration between the Jupyter and Julia communities, provides a powerful browser-based graphical notebook interface to Julia.

shell> cat sample.jl
# Arguments
# ARGS[0] is the command itself
in_file = ARGS[1]
out_file = ARGS[2]

# Keeping track using a counter
counter = 0
for line in eachline(in_file)
	for word in split(line)
		if word == "Julia"
			counter += 1
		end
	end
end

# Write the contents to the o/p file
write(out_file, "The count for the word julia is $counter")

# Finally, read the contents to inform the user
for line in readlines(out_file)
	println(line)
end

# run the script like
shell> julia sample.jl input.txt out.txt
The count for the word julia is 4



### calling C from julia

julia> ccall((:clock, :libc), Int64, ())
5818283

julia> syspath = ccall( (:getenv, :libc), Ptr{Cchar}, (Ptr{Cchar},), "SHELL")
Ptr{Int8} @0x00007ffee62cfc00

julia> unsafe_string(syspath)
"/bin/bash"

# Python
# simple hello world 
julia> using PyCall
INFO: Precompiling module PyCall.

julia> py"""
         print 'hello world'
         """
hello world

# calling a function
julia> py"""
       def cube(n):
           return n*n*n
       print cube(10)
       """
1000

# imports in python
julia> @pyimport numpy as np

julia> np.sin(120)
0.5806111842123143

# Using pybuiltin, directy create a python dict object
julia> pybuiltin(:dict)(a=1,b=2)
Dict{Any,Any} with 2 entries:
  "b" => 2
  "a" => 1

julia> pycall(pybuiltin("dict"), Any, a=1, b=2)
PyObject {'a': 1, 'b': 2}

julia> d = pycall(pybuiltin("dict"), Any, a=1, b=2)
PyObject {'a': 1, 'b': 2}

# making sure of the type, still a python object
julia> typeof(d)
PyCall.PyObject

# using pyDict to convert python's object to a juia dict object
julia> julia_dictionary = PyDict{Symbol, Int64}(pycall(pybuiltin("dict"), Any, a=1, b=2))
PyCall.PyDict{Symbol,Int64,true} with 2 entries:
  :a => 1
  :b => 2

# as we see, its now a julia dict object
julia> typeof(julia_dictionary)
PyCall.PyDict{Symbol,Int64,true}

# accessing dictionary elements
julia> julia_dictionary[:a]
1

# accessing dictionary elements
julia> julia_dictionary[:b]
2

# a function that takes kw arguments
julia> f(; a=0, b=0) = [10a, b]
f (generic function with 1 method)

julia> f(;julia_dictionary...)
2-element Array{Int64,1}:
 10
  2

### Expressions and Macros

julia> code = "println(\"hello world \")"
"println(\"hello world \")"

julia> expression = parse(code)
:(println("hello world "))

julia> typeof(expression)
Expr

julia> fieldnames(expression)
3-element Array{Symbol,1}:
 :head
 :args
 :typ 

julia> expression.args
2-element Array{Any,1}:
 :println      
 "hello world "

julia> expression.head
:call

julia> expression.typ
Any

julia> dump(expression)
Expr
  head: Symbol call
  args: Array{Any}((2,))
    1: Symbol println
    2: String "hello world "
  typ: Any

julia> result = :hello
:hello

julia> typeof(result)
Symbol

julia> fieldnames(result)
0-element Array{Symbol,1}

julia> sample_expr = Expr(:call, +, 10, 20)
:((+)(10,20))

julia> eval(sample_expr)
30

julia> sample_expr.args
3-element Array{Any,1}:
   +
 10 
 20 

julia> eval(sample_expr)
20

# interpolation of variables
julia> x = 10
10

julia> y = 10
10

julia> sample_expr = Expr(:call, +, :x, :y)
:((+)(10,10))

# or even this works
julia> sample_expr = Expr(:call, +, x, y)
:((+)(10,10))

julia> eval(sample_expr)
20

# interpolation using quotes(:)
julia> quote
       30 * 100
       end
quote  # REPL[12], line 2:
    30 * 100
end

julia> eval(ans)
3000

julia> :(30 * 100)
:(30 * 100)

julia> eval(ans)
3000

# interpolation of varibales using dollar($)
julia> x = 10
10

julia> y = 10
10

julia> e = :($x + $y)
:(10 + 10)

julia> eval(e)
20


# Macros
julia> macro HELLO(name)
                  :( println("Hello! ", $name))
              end
@HELLO (macro with 1 method)

julia> @HELLO("rahul")
Hello! rahul

julia> macroexpand(:(@HELLO("rahul")))
:(println("Hello!","rahul"))

# Example of using macro
julia> for header in [:h1, :h2, :h3, :h4, :h5, :h6]
                         @eval function $(Symbol(header))(text::String)
                             println("<" * $(string(header))* ">"  * " $text " * "</" * $(string(header))* ">")
                         end
                     end

julia> h1("Hello world!")
<h1> Hello world! </h1>

julia> h2("Hello world!")
<h2> Hello world! </h2>


### Built in macros

# checking the time taken by a function to run, using @time macro
# simple function to find recursive sum
julia> function recursive_sum(n)
           if n == 0
               return 0
           else
               return n + recursive_sum(n-1)
       end
       end
recursive_sum (generic function with 1 method)

# A bit slow to run for the 1st Time, as the function gets compiled.
julia> @time recursive_sum(10000)
  0.003905 seconds (450 allocations: 25.816 KiB)
50005000

# Much much faster in the second run!
julia> @time recursive_sum(10000)
  0.000071 seconds (5 allocations: 176 bytes)
50005000



# @elapsed
julia> @elapsed average(10000000, 1000000000)
2.144e-6

julia> typeof(@elapsed average(10000000, 1000000000))
Float64



# @show
julia> @show(println("hello world"))
hello world
println("hello world") = nothing

julia> @show(:(println("hello world")))
$(Expr(:quote, :(println("hello world")))) = :(println("hello world"))
:(println("hello world"))

julia> @show(:(3*2))
$(Expr(:quote, :(3 * 2))) = :(3 * 2)
:(3 * 2)

julia> @show(3*2)
3 * 2 = 6
6

julia> @show(Int64)
Int64 = Int64
Int64



# @which
# create a function that tripples an Integer
julia> function tripple(n::Int64)
           3n
       end
tripple (generic function with 1 method)

# redefine the same function to accept Float
julia> function tripple(n::Float64)
           3n
       end
tripple (generic function with 2 methods)

# check the methods available for this function
julia> methods(tripple)
# 2 methods for generic function "tripple":
tripple(n::Float64) in Main at REPL[22]:2
tripple(n::Int64) in Main at REPL[21]:2

# Get the correct method , when 'n' is an Int64
julia> @which tripple(10)
tripple(n::Int64) in Main at REPL[21]:2

# Get the correct method , when 'n' is Float64
julia> @which tripple(10.0)
tripple(n::Float64) in Main at REPL[22]:2



# @task
julia> say_hello() = println("hello world")
say_hello (generic function with 1 method)

julia> say_hello_task = @task say_hello()
Task (runnable) @0x000000010dcdfa90

julia> istaskstarted(say_hello_task)
false

julia> schedule(say_hello_task)
hello world
Task (queued) @0x000000010dcdfa90

julia> yield()

julia> istaskdone(say_hello_task)
true



# @code_lowered, @code_typed, @code_llvm and @code_native
julia> function fibonacci(n::Int64)
           if n < 2
               n
           else 
               fibonacci(n-1) + fibonacci(n-2)
           end
       end
fibonacci (generic function with 1 method)

# OR, can also define it this way
julia> fibonacci(n::Int64) = n < 2 ? n : fibonacci(n-1) + fibonacci(n-2)
fibonacci (generic function with 1 method)

julia> fibonacci(10)
55

julia> @code_lowered fibonacci(10)
CodeInfo(:(begin 
        nothing
        unless n < 2 goto 4
        return n
        4: 
        return (Main.fibonacci)(n - 1) + (Main.fibonacci)(n - 2)
    end))


julia> @code_typed fibonacci(10)
CodeInfo(:(begin 
        unless (Base.slt_int)(n, 2)::Bool goto 3
        return n
        3: 
        SSAValue(1) = $(Expr(:invoke, MethodInstance for fibonacci(::Int64), :(Main.fibonacci), :((Base.sub_int)(n, 1)::Int64)))
        SSAValue(0) = $(Expr(:invoke, MethodInstance for fibonacci(::Int64), :(Main.fibonacci), :((Base.sub_int)(n, 2)::Int64)))
        return (Base.add_int)(SSAValue(1), SSAValue(0))::Int64
    end))=>Int64

julia> @code_warntype fibonacci(10)
Variables:
  #self#::#fibonacci
  n::Int64

Body:
  begin 
      unless (Base.slt_int)(n::Int64, 2)::Bool goto 3
      return n::Int64
      3: 
      SSAValue(1) = $(Expr(:invoke, MethodInstance for fibonacci(::Int64), :(Main.fibonacci), :((Base.sub_int)(n, 1)::Int64)))
      SSAValue(0) = $(Expr(:invoke, MethodInstance for fibonacci(::Int64), :(Main.fibonacci), :((Base.sub_int)(n, 2)::Int64)))
      return (Base.add_int)(SSAValue(1), SSAValue(0))::Int64
  end::Int64

julia> @code_llvm fibonacci(10)

define i64 @julia_fibonacci_61143.2(i64) #0 !dbg !5 {
top:
  %1 = icmp sgt i64 %0, 1
  br i1 %1, label %L3, label %if

if:                                               ; preds = %top
  ret i64 %0

L3:                                               ; preds = %top
  %2 = add i64 %0, -1
  %3 = call i64 @julia_fibonacci_61143(i64 %2)
  %4 = add i64 %0, -2
  %5 = call i64 @julia_fibonacci_61143(i64 %4)
  %6 = add i64 %5, %3
  ret i64 %6
}


julia> @code_native fibonacci(10)
  .section  __TEXT,__text,regular,pure_instructions
Filename: REPL[50]
  pushq %rbp
  movq  %rsp, %rbp
  pushq %r15
  pushq %r14
  pushq %rbx
  pushq %rax
  movq  %rdi, %rbx
Source line: 1
  cmpq  $1, %rbx
  jle L63
  leaq  -1(%rbx), %rdi
  movabsq $fibonacci, %r15
  callq *%r15
  movq  %rax, %r14
  addq  $-2, %rbx
  movq  %rbx, %rdi
  callq *%r15
  addq  %r14, %rax
  addq  $8, %rsp
  popq  %rbx
  popq  %r14
  popq  %r15
  popq  %rbp
  retq
L63:
  movq  %rbx, %rax
  addq  $8, %rsp
  popq  %rbx
  popq  %r14
  popq  %r15
  popq  %rbp
  retq
  nopl  (%rax)



## Type introspection
# making use of typeof

julia> type Student
           name::String
           age::Int64
       end

julia> alpha = Student("alpha",24)
Student("alpha", 24)

julia> beta = Student("beta",25)
Student("beta", 25)

julia> typeof(alpha)
Student

# similar to isinstance in python
julia> isa(alpha, Student)
true


## Reflection
# the first method tries to take in all integer values
julia> function calculate_quad(a::Int64,b::Int64,c::Int64,x::Int64)
           return a*x^2 + b*x + c
       end
calculate_quad (generic function with 2 methods)

julia> calculate_quad(1,2,3,4)
27

# the second method takes all but x as integer values
julia> function calculate_quad(a::Int64,b::Int64,c::Int64,x::Float64)
           return a*x^2 + b*x + c
       end
calculate_quad (generic function with 3 methods)

julia> calculate_quad(1,2,3,4.75)
35.0625

# to know what all methods does the function supports
# which as we can see that there are 2 currently
julia> methods(calculate_quad)
# 3 methods for generic function "calculate_quad":
calculate_quad(a::Int64, b::Int64, c::Int64, x::Float64) in Main at REPL[31]:2
calculate_quad(a::Int64, b::Int64, c::Int64, x::Int64) in Main at REPL[29]:2
calculate_quad(a, b, c, x) in Main at REPL[27]:2


# from the already declared Student class
julia> fieldnames(Student)
2-element Array{Symbol,1}:
 :name
 :age 


julia> Student.types
svec(String, Int64)
