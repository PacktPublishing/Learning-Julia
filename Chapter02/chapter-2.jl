x = 100

println("x is ", x)

x*5

println("x is ", x)

x = x*5

println("x is ", x)


y = 200

x,y = y,x

println("x is ", x, " y is ", y)


अंशुल= 101

println("Value stored in symbols (Anshul) from language Hindi ", अंशुल)



# String
langname = "Julia"
println(typeof(langname))


println(typemax(Int32))
println(typemin(Int32))


x = Int16(10000)
println(x*x)



# largest possible value of 16-bit Int: 32767
x = typemax(Int16)
println(x)
# 32767

# Julia will maintain variable types even if the max value # is exceeding
# -32768
println(x + Int16(1))


# Float64
x=2.99e8
println(typeof(x))
# Replace e by f to generate Float32
y=2.99f8
println(typeof(y))

# true
println(x==y)


# This happens when that particular number doesn’t have the expected
# floating point representation.
x = 1.1; y = 0.1;
println(x+y)


# expressions
x = 4; y = 11;
println(3x + 4y + 93)
# 149




# this creates an empty array
empty_array = Float64[]
println(empty_array)
# 0-element Array{Float64,1}


# the function push!() adds values to the array
push!(empty_array,1.1)
println(empty_array)
# 1-element Array{Float64,1}:
# 1.1

# adding more values
push!(empty_array,2.2,3.3)
println(empty_array)
# 3-element Array{Float64,1}:
# 1.1
# 2.2
# 3.3




# constructing a matrix
X = [1 1 2; 3 5 8; 13 21 34]
println(X)
# 3×3 Array{Int64,2}:
# 1 1 2
# 3 5 8
# 13 21 34




# a 3x2 matrix
A = [2 4; 8 16; 32 64]
println(A)
# 3×2 Array{Int64,2}:
# 2 4
# 8 16
# 32 64

# We can change the shape of a matrix using the reshape() function:
println(reshape(A,2,3))
# 2×3 Array{Int64,2}:
# 2 32 16
# 8 4 64





# multidimensional array
multiA = rand(3,3,3)
println(multiA)
# 3×3×3 Array{Float64,3}:
# .........


# access the values just as we accessed values in arrays and matrices, using the index:
println(multiA[1,3,2])



# NA datavalues in dataset
using DataArrays
x = DataArray([1.1, 2.2, 3.3, 4.4, 5.5, 6.6])
println(x)

x[1] = NA
println(x)


# operations on DataArrays
println(mean(x[2:6]))



# Type aliases of Vector (a onedimensional
# Array type) and Matrix (a two-dimensional Array type) are DataVector
# and DataMatrix, provided by DataArray.
dvector = data([10,20,30,40,50])
println(dvector)
dmatrix = data([10 20 30; 40 50 60])
println(dmatrix)



# Pkg.add("DataFrames")
using DataFrames
df = DataFrame(Name = ["Julia", "Python"], Version = [0.5, 3.6])
println(df)
