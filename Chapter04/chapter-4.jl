# types
1		# Int64
1.10	# Float64
'j'		# Char
"julia"	# String

# function that calculates cube 
julia> function cube(number::Int64)
           return number ^ 3
       end
cube (generic function with 1 method)

# call the function with 10 as an argument
julia> cube(10)
1000

# The following usages of the function cube will thrown error
# julia> cube("10")
# ERROR: MethodError: no method matching cube(::String)
# Closest candidates are:
#   cube(::Int64) at REPL[1]:2

# The :: operator
# returns the value itself if true, else with throw an error
# julia> 2:: Float64
# ERROR: TypeError: typeassert: expected Float64, got Int64
julia> 2:: Int64
2

# Or
julia> typeassert(2, Int64)
2


# checking out what machine we are on, whether a 64 bit or 32 bit
julia> bits(1)
"0000000000000000000000000000000000000000000000000000000000000001"
julia> sizeof(bits(1))
64


# typemax and typemin for Julia types
# Int64
julia> typemin(1)
-9223372036854775808
julia> typemax(1)
9223372036854775807

# Float64
julia> typemin(1.11)
-Inf
julia> typemax(1.11)
Inf


# Type conversions using convert function
# Syntax - convert( desiredType, valueToConvert)
julia> convert(Float64, 10)
10.0

# Sample usage in a function
julia> function distance_covered(speed::Int64, time ::Int64)
           convert(Float64, speed * time) 
       end
distance_covered (generic function with 1 method)
julia> distance_covered(62,2)
124.0


# Manipulating Float values
julia> ceil(Int, 3.4)
4
julia> floor(Int, 3.4)
3
julia> round(Int, 3.4)
3


# Subtypes and Supertypes
julia> supertype(Number)
Any

julia> subtypes(Any)
275-element Array{Union{DataType, UnionAll},1}:
 AbstractArray              
 AbstractChannel            
 AbstractRNG                
 AbstractSerializer         
 AbstractSet                
 AbstractString             
 Any                        
 Associative                
 Base.AbstractCartesianIndex
 Base.AbstractCmd           
 Base.AsyncCollector        
 Base.AsyncCollectorState   
 Base.AsyncCondition        
 Base.AsyncGenerator        
 Base.AsyncGeneratorState   
 ⋮                          
 Timer                      
 Tuple                      
 Type                       
 TypeMapEntry               
 TypeMapLevel               
 TypeName                   
 TypeVar                    
 UniformScaling             
 Val                        
 Vararg                     
 VecElement                 
 VersionNumber              
 Void                       
 WeakRef                    
 WorkerConfig


# Function to check and print all the subtypes of a given a abstract type
julia> function check_all_subtypes(T, space=0)
           println("\t" ^ space, T)
           for t in subtypes(T)
               if t!= Any
               check_all_subtypes(t, space+1)
           end
       end
       end
check_all_subtypes (generic function with 2 methods)

# checking all subtypes of Number type
julia> check_all_subtypes(Number)
Number
	Complex
	Real
		AbstractFloat
			BigFloat
			Float16
			Float32
			Float64
		Integer
			BigInt
			Bool
			Signed
				Int128
				Int16
				Int32
				Int64
				Int8
			Unsigned
				UInt128
				UInt16
				UInt32
				UInt64
				UInt8
		Irrational
		Rational

# Checking all subtypes of AbstractString type
julia> check_all_subtypes(AbstractString)
AbstractString
	Base.SubstitutionString
	Base.Test.GenericString
	DirectIndexString
	RevString
	String
	SubString



# User defined types
julia> type Person
           name:: String
           age::Int64
       end

# create the object for this Person type
julia> rahul = Person("rahul", 27)
Person("rahul", 27)

julia> typeof(rahul)
Person

# access the fields inside this object
julia> rahul.name
"rahul"
julia> rahul.age
27

# To know all the fieldnames inside a object, use the below function
julia> fieldnames(rahul)
2-element Array{Symbol,1}:
 :name
 :age 


# Composite Types
# Immutable types using struct keyword
julia> struct Point
              x::Int64
              y::Int64
              z::Int64
       end

julia> p = Point(1,2,3)
Point(1, 2, 3)

julia> p.x
1

# This is NOT allowed for a struct, as its immutable
# julia> p.x = 10
# ERROR: type Point is immutable


# Mutable types
julia> mutable struct MutPoint
              x::Int64
              y::Int64
              z::Int64
       end

julia> p = MutPoint(1,2,3)
MutPoint(1, 2, 3)
julia> p.x
1
julia> p.x = 10
10
julia> p
MutPoint(10, 2, 3)



### Inner Constructors

# showcasing default constructor with extra validation function 
julia> type Family
           num_members :: Int64
           members :: Array{String, 1}
       end

julia> f1 = Family(2, ["husband", "wife"])
Family(2, String["husband", "wife"])

julia> f2 = Family(1, ["husband", "wife"])
Family(1, String["husband", "wife"])

# creating a simple function that validates the count provided with the length of the array
julia> function validate(obj::Family)
           if obj.num_members != length(obj.members)
               println("ERROR! Not all members listed!!")
           else
               println("Valid!!")
       end
       end

# lets validate 
julia> validate(f1)
Valid!!

julia> validate(f2)
ERROR! Not all members listed!!


# Using Inner constructor to help solve the above problem better
julia> workspace()

julia> type Family
           num_members:: Int64
           members :: Array{String, 1}
           
           # inner constructor in play
           Family(num_members, members) = num_members != length(members) ? error("Mismatch!!") : new(num_members, members)
           end

# This throws error!
# julia> f1 = Family(1, ["husband", "wife"])
# ERROR: Mismatch!!
# Stacktrace:
#  [1] Family(::Int64, ::Array{String,1}) at ./REPL[73]:6

# While this works!
julia> f2 = Family(2, ["husband", "wife"])
Family(2, String["husband", "wife"])



### Modules & Interfaces

# create a module
julia> module MyModule
           foo=10
           bar=20
           function baz()
               "baz"
           end
           function qux()
               "qux"
           end
           export foo, baz
           end
MyModule

julia> import MyModule

julia> MyModule.bar
20

julia> MyModule.baz()
"baz"

julia> MyModule.foo
10

julia> MyModule.qux()
"qux"


# Including files in modules
# this can be done by using the function include
# open the shell using ; and then creat file by the name transformations.jl
# put say_hello function inside the file

shell> cat transformations.jl
function say_hello(name:: String)
	"hello, $name"
end

# now include this file
julia> include("transformations.jl")
say_hello (generic function with 1 method)

julia> say_hello("rahul")
"hello, rahul"



### Module precompilation

# without precompilation
module Samplecode

export sum_of_numbers

sum_of_numbers = 0
for num in 1:1000000000
	sum_of_numbers += num
end

end

# With precompilation
__precompile__()
module Samplecode

export sum_of_numbers

sum_of_numbers = 0
for num in 1:1000000000
	sum_of_numbers += num
end

end



### Multiple dispatch revisited

julia> type Coordinate{T}
           x::T
           y::T
           z::T
       end

julia> function calc_sum(value::Coordinate{Int64})
           value.x + value.y + value.z
       end
calc_sum (generic function with 1 method)

julia> function calc_sum(value::Coordinate{Float64})
                  value.x + value.y + value.z
       end
calc_sum (generic function with 2 methods)

# we use the function methods to know the available method signatures
julia> methods(calc_sum)
# 2 methods for generic function "calc_sum":
calc_sum(value::Coordinate{Float64}) in Main at REPL[41]:2
calc_sum(value::Coordinate{Int64}) in Main at REPL[40]:2

julia> calc_sum(Coordinate(1,2,3))
6
julia> calc_sum(Coordinate(1.0,2.0,3.0))
6.0





