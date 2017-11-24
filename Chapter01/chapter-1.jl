# simple print statement
println("Hello World")

# julia REPL can be used as a calculator
4+11

# simple function to print hello world
function helloworld()
    println("Hello world from chapter-1.jl")
end
helloworld()


# include hello.jl
include("hello.jl")

# helloworld from hello.jl
helloworld()
