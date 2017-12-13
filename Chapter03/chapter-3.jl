function greet()
    println("hello world")
end
# greet (generic function with 1 method)

greet()
# hello world



function calculator(x, y, operation)
    if operation == "+"
        x+y
    elseif operation == "-"
        x-y
    elseif operation == "*"
        x*y
    elseif operation == "/"
        x/y
    else
        println("Incorrect operation")
        return 0
    end
end
# calculator (generic function with 1 method)


println(calculator(10,20, "+"))
# 30
println(calculator(10,20, "-"))
# -10
println(calculator(10,20, "*"))
# 200
println(calculator(10,20, "/"))
# 0.5


# passing arguments
function say_hello(name)
    println("hello $name")
end
# say_hello (generic function with 1 method)

say_hello("rahul")
# hello rahul


# explicitly defining the type
function say_hello(name::String)
    println("hello $name")
end
# say_hello (generic function with 1 method)

say_hello("rahul")
# hello rahul



# Variable arguments
function letsplay(x,y...)
    println(x)
    println(y)
end
# letsplay (generic function with 1 method)

letsplay("cricket","hockey","tennis")
# cricket
# ("hockey","tennis")
