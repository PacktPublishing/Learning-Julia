### Working with data

# usage of read with Char
julia> read(STDIN, Char)
j
'j': ASCII/Unicode U+006a (category Ll: Letter, lowercase)

# usage of read with Bool 
julia> read(STDIN, Bool)
true
true

# usage of read with Int8
julia> read(STDIN, Int8)
23
50

# method signature for Bool Type
julia> @which read(STDIN,Bool)
read(s::IO, ::Type{Bool}) in Base at io.jl:370

# method signature for Char Type
julia> @which read(STDIN,Char)
read(s::IO, ::Type{Char}) in Base at io.jl:403

# method signature for Int8 Type
julia> @which read(STDIN,Int8)
read(s::IO, ::Type{Int8}) in Base at io.jl:365

# Or Alternatively
julia> for val in [:Bool, :Char, :Int8]
          @eval println(@which read(STDIN, $val))
       end
read(s::IO, ::Type{Bool}) in Base at io.jl:370
read(s::IO, ::Type{Char}) in Base at io.jl:403
read(s::IO, ::Type{Int8}) in Base at io.jl:365

julia> statement = readline()
julia is fast!
"julia is fast!"

julia> readline(chomp = false)
julia
"julia\n"

julia> methods(readline)
# 4 methods for generic function "readline":
readline(s::IOStream; chomp) in Base at iostream.jl:234
readline() in Base at io.jl:190
readline(filename::AbstractString; chomp) in Base at io.jl:184
readline(s::IO; chomp) in Base at io.jl:190

julia> number = parse(Int64, readline())
23

julia> println(number)
23



# taking input from user and performing actions on it
# take input from user
julia> numbers = readline()
23 45 67 89
"23 45 67 89"

# use the split function to convert string to array
julia> split(numbers)
4-element Array{SubString{String},1}:
 "23"
 "45"
 "67"
 "89"

# the easy way
julia> for item in split(numbers)
           println(parse(Int64, item))
       end
23
45
67
89

# the array comprehension way
julia> [parse(Int64, item) for item in split(numbers)]
4-element Array{Int64,1}:
 23
 45
 67
 89



### Working with Text Files
# Mode Description                  
# –––– –––––––––––––––––––––––––––––
# r    read                         
# r+   read, write                  
# w    write, create, truncate      
# w+   read, write, create, truncate
# a    write, create, append        
# a+   read, write, create, append 

julia> methods(open)
# 8 methods for generic function "open":
open(fname::AbstractString) in Base at iostream.jl:113
open(fname::AbstractString, rd::Bool, wr::Bool, cr::Bool, tr::Bool, ff::Bool) in Base at iostream.jl:103
open(fname::AbstractString, mode::AbstractString) in Base at iostream.jl:132
open(f::Function, cmds::Base.AbstractCmd, args...) in Base at process.jl:599
open(f::Function, args...) in Base at iostream.jl:150
open(cmds::Base.AbstractCmd) in Base at process.jl:575
open(cmds::Base.AbstractCmd, mode::AbstractString) in Base at process.jl:575
open(cmds::Base.AbstractCmd, mode::AbstractString, other::Union{Base.FileRedirect, IO, RawFD}) in Base at process.jl:575


# sample file
shell> cat sample.txt
Julia is a great and powerful language
It is homoiconic.
It supports static as well as dynamic typing.
Julia walks like python runs like C.
Julia uses multiple dispatch.


# inside julia,
# read file from the device folder in the current path
julia> file = open("sample.txt")
IOStream(<file sample.txt>)

# oread the contents of file
julia> file_data = readlines(file)
5-element Array{String,1}:
 "Julia is a great and powerful language"       
 "It is homoiconic."                            
 "It supports static as well as dynamic typing."
 "Julia walks like python runs like C."         
 "Julia uses multiple dispatch." 


# running an enumerate over the file provides us with a counter too!
julia> enumerate(file_data)
Enumerate{Array{String,1}}(String["Julia is a great and powerful language", "It is homoiconic.", "It supports static as well as dynamic typing.", "Julia walks like python runs like C.", "Julia uses multiple dispatch."])

# using enumerate to our advantage to get the length of each line
julia> for lines in enumerate(file_data)
           println(lines[1],"-> ", lines[2])
       end
1-> Julia is a great and powerful language
2-> It is homoiconic.
3-> It supports static as well as dynamic typing.
4-> Julia walks like python runs like C.
5-> Julia uses multiple dispatch.

# convert everything to uppercase
julia> for line in file_data
           println(uppercase(line))
       end
JULIA IS A GREAT AND POWERFUL LANGUAGE
IT IS HOMOICONIC.
IT SUPPORTS STATIC AS WELL AS DYNAMIC TYPING.
JULIA WALKS LIKE PYTHON RUNS LIKE C.
JULIA USES MULTIPLE DISPATCH.

# reverse each line!!
julia> for line in file_data
           println(reverse(line))
       end
egaugnal lufrewop dna taerg a si ailuJ
.cinociomoh si tI
.gnipyt cimanyd sa llew sa citats stroppus tI
.C ekil snur nohtyp ekil sklaw ailuJ
.hctapsid elpitlum sesu ailuJ

# to simply count the number of lines in a file
julia> countlines("sample.txt")
5

# print the first line of the file
julia> first(file_data)
"Julia is a great and powerful language"

# print last line of the file
julia> last(file_data)
"Julia uses multiple dispatch."


###Working with CSV and Delimited File Formats

julia> csvfile = readcsv("sample.csv")
5×3 Array{Any,2}:
 1  "James"       "UK"        
 2  "Lora"        "UK"        
 3  "Raj"         "India"     
 4  "Rangnatham"  "Sri lanka" 
 5  "Azhar"       "Bangladesh"

# getting only the names of the people
julia> csvfile[:,2]
5-element Array{Any,1}:
 "James"     
 "Lora"      
 "Raj"       
 "Rangnatham"
 "Azhar"

# getting only the top 3 data
julia> csvfile[1:3,:]
3×3 Array{Any,2}:
 1  "James"  "UK"   
 2  "Lora"   "UK"   
 3  "Raj"    "India"

# reverse sorting the rows
julia> sortrows(csvfile, rev=true)
5×3 Array{Any,2}:
 5  "Azhar"       "Bangladesh"
 4  "Rangnatham"  "Sri lanka" 
 3  "Raj"         "India"     
 2  "Lora"        "UK"        
 1  "James"       "UK" 

# A pipe seperated file with the same data as above
shell> cat sample.psv
1|"James"|"UK"
2|"Lora"|"UK"
3|"Raj"|"India"
4|"Rangnatham"|"Sri lanka"
5|"Azhar"|"Bangladesh"

# using '|' as delimiter
julia> readdlm("sample.psv",'|')
5×3 Array{Any,2}:
 1  "James"       "UK"        
 2  "Lora"        "UK"        
 3  "Raj"         "India"     
 4  "Rangnatham"  "Sri lanka" 
 5  "Azhar"       "Bangladesh"



### Working with DataFrames
# install the package
julia> Pkg.add("DataFrames")

# first time load takes times due to precompilation
julia> using DataFrames

# check the functions provided by DataFrames
julia> names(DataFrames)
254-element Array{Symbol,1}:
 :&                 
 Symbol("@csv2_str")
 Symbol("@csv_str") 
 Symbol("@data")    
 Symbol("@formula") 
 Symbol("@pdata")   
 Symbol("@tsv_str") 
 Symbol("@wsv_str") 
 Symbol("@~")       
 :AIC               
 :AICc              
 :AbstractContrasts 
 :AbstractDataArray 
 :AbstractDataFrame 
 :AbstractDataMatrix
 :AbstractDataVector
 ⋮                  
 :winsor            
 :winsor!           
 :wmean             
 :wmean!            
 :wmedian           
 :wquantile         
 :writetable        
 :wsample           
 :wsample!          
 :wsum              
 :wsum!             
 :xor               
 :zscore            
 :zscore!           
 :|                 


julia> DataMatrix{Any} == DataArray{Any, 2}
true

julia> DataVector{Any} == DataArray{Any, 1}
true

# NA values
julia> a = [1,2,3,nothing,5,6]
6-element Array{Any,1}:
 1       
 2       
 3       
  nothing
 5       
 6       

# try to access the element
julia> a[4]

# check the data type
julia> typeof(a[4])
Void

julia> using DataArrays

julia> a = DataArray([1.1, 2.2, 3.3, 4.4, 5.5, 6.6])
6-element DataArrays.DataArray{Float64,1}:
 1.1
 2.2
 3.3
 4.4
 5.5
 6.6

julia> a[1] = NA
NA

julia> a
6-element DataArrays.DataArray{Float64,1}:
  NA
 2.2
 3.3
 4.4
 5.5
 6.6

julia> typeof(a[1]) 
DataArrays.NAtype

julia> true || a
true

julia> true && a
6-element DataArrays.DataArray{Float64,1}:
  NA
 2.2
 3.3
 4.4
 5.5
 6.6

julia> mean(a)
NA

julia> mean(a[2:length(a)])
4.4


# DataArrays
# creating a 2D data matrix
julia> data_matrix = DataArray([1 2 3;4 5 6])
2×3 DataArrays.DataArray{Int64,2}:
 1  2  3
 4  5  6

# Creating a 1D vector
julia> data_vector = DataArray([1 2 3 4 5 6 7 8])
1×8 DataArrays.DataArray{Int64,2}:
 1  2  3  4  5  6  7  8

# Creating a column major 1D array
julia> data_vector_column_major = DataArray([1,2,3,4])
4-element DataArrays.DataArray{Int64,1}:
 1
 2
 3
 4

# assigning the first value as NA
julia> data_vector_column_major[1] = NA
NA

# dropping NA values
julia> data_vector_column_major
4-element DataArrays.DataArray{Int64,1}:
  NA
 2  
 3  
 4  


# DataFrames
julia> dframe = DataFrame(Names = ["John","Ajay"], Age = [27,28])
2×2 DataFrames.DataFrame
│ Row │ Names  │ Age │
├─────┼────────┼─────┤
│ 1   │ "John" │ 27  │
│ 2   │ "Ajay" │ 28  │


julia> dframe.columns[1]
2-element DataArrays.DataArray{String,1}:
 "John"
 "Ajay"

julia> typeof(dframe.columns[1])
DataArrays.DataArray{String,1}




### Linear Algebra and Differential Calculus

julia> A = rand(3,3)
3×3 Array{Float64,2}:
 0.821807   0.828687  0.974031
 0.996824   0.805663  0.274284
 0.0341033  0.224237  0.39982

julia> ones(5)
5-element Array{Float64,1}:
 1.0
 1.0
 1.0
 1.0
 1.0


# Vector
julia> Vector{Float64} == Array{Float64,1}
true

# Matrix
julia> Matrix{Float64} == Array{Float64,2}
true

# Multiplication
# creat a random matrix of 3x3 dimension
julia> A
3×3 Array{Float64,2}:
 0.673465  0.880229  0.100458 
 0.752117  0.545464  0.0180286
 0.531316  0.221628  0.179626 

# Easily, we could do
julia> b = 2 * A
3×3 Array{Float64,2}:
 1.34693  1.76046   0.200917 
 1.50423  1.09093   0.0360573
 1.06263  0.443255  0.359252

# Julia's advantage! Omit the '*' while multiplication
julia> b = 2A
3×3 Array{Float64,2}:
 1.34693  1.76046   0.200917 
 1.50423  1.09093   0.0360573
 1.06263  0.443255  0.359252 


# Matrix operations
# Matrix Transpose
julia> transpose_of_A = A'
3×3 Array{Float64,2}:
 0.673465  0.752117   0.531316
 0.880229  0.545464   0.221628
 0.100458  0.0180286  0.179626

# Matrix inversion
julia> X = [1 2; 3 4]
2×2 Array{Int64,2}:
 1  2
 3  4

julia> inv(X)
2×2 Array{Float64,2}:
 -2.0   1.0
  1.5  -0.5

# Matrix Determinant
julia> M = [10 10; 10 10]
2×2 Array{Int64,2}:
 10  10
 10  10

julia> det(M)
0.0

# Matrix Multiplication
julia> M * M'
2×2 Array{Int64,2}:
 200  200
 200  200

# Matrix Division
julia> div.(M, 10)
2×2 Array{Int64,2}:
 1  1
 1  1

# Eigenvalues of Matrix
julia> eigvals(M)
2-element Array{Float64,1}:
  0.0
 20.0


# linear equations
# define the value of x
julia> x = 5
5

# solve the equation 
julia> equation = 3x^2 + 4x + 3
98



# Differential calculus
julia> Pkg.add("Calculus")
julia> using Calculus

# list of functions supported by Calculus
julia> names(Calculus)
22-element Array{Symbol,1}:
 Symbol("@sexpr")                
 :AbstractVariable               
 :BasicVariable                  
 :Calculus                       
 :SymbolParameter                
 :Symbolic                       
 :SymbolicVariable               
 :check_derivative               
 :check_gradient                 
 :check_hessian                  
 :check_second_derivative        
 :deparse                        
 :derivative                     
 :differentiate                  
 :hessian                        
 :integrate                      
 :jacobian                       
 :processExpr                    
 :second_derivative              
 :simplify                       
 :symbolic_derivative_bessel_list
 :symbolic_derivatives_1arg

julia> f(x) = sin(x)
f (generic function with 1 method)

julia> f'(1.0) - cos(1.0)
-5.036193684304635e-12

julia> f''(1.0) - (-sin(1.0))
-6.647716624952338e-7

julia> f'''(1.0) - (-cos(1.0))
0.11809095011119602

julia> differentiate("cos(x) + sin(x) + exp(-x) * cos(x)", :x)
:(-(sin(x)) + cos(x) + (-(exp(-x)) * cos(x) + exp(-x) * -(sin(x))))

julia> differentiate("cos(x) + sin(y) + exp(-x) * cos(y)", [:x, :y])
2-element Array{Any,1}:
 :(-(sin(x)) + -(exp(-x)) * cos(y))
 :(cos(y) + exp(-x) * -(sin(y))) 


### Statistics

julia> x = [10,20,30,40,50]
5-element Array{Int64,1}:
 10
 20
 30
 40
 50

# computing the mean 
julia> mean(x)
30.0
 
# computing the median
julia> median(x)
30.0

# computing the sum
julia> sum(x)
150

# computing the standard deviation
julia> std(x)
15.811388300841896

# computing the variance
julia> var(x)
250.0

# cummax() : To find the cumulative maximum.
# cummin() : To find the cumulative minimum.
# cumsum() : To find the cumulative maximum.
# cumprod() : To find the cumulative product.


# old implementations
julia> cummax(x)
5-element Array{Int64,1}:
 10
 20
 30
 40
 50

julia> cummin(x)
5-element Array{Int64,1}:
 10
 10
 10
 10
 10

julia> cumsum(x)
5-element Array{Int64,1}:
  10
  30
  60
 100
 150

julia> cumprod(x)
5-element Array{Int64,1}:
       10
      200
     6000
   240000
 12000000


# using accumulate function
julia> accumulate(+,x)
5-element Array{Int64,1}:
  10
  30
  60
 100
 150

julia> accumulate(*,x)
5-element Array{Int64,1}:
       10
      200
     6000
   240000
 12000000

julia> accumulate(max,x)
5-element Array{Int64,1}:
 10
 20
 30
 40
 50

julia> accumulate(min,x)
5-element Array{Int64,1}:
 10
 10
 10
 10
 10


# Basic Statistics using DataFrames

julia> dframe = DataFrame(Subjects = ["Maths","Physics","Chemistry"],Marks = [90,85,95])
3×2 DataFrames.DataFrame
│ Row │ Subjects    │ Marks │
├─────┼─────────────┼───────┤
│ 1   │ "Maths"     │ 90    │
│ 2   │ "Physics"   │ 85    │
│ 3   │ "Chemistry" │ 95    │

julia> describe(dframe)
Subjects
Summary Stats:
Length:         3
Type:           String
Number Unique:  3
Number Missing: 0
% Missing:      0.000000

Marks
Summary Stats:
Mean:           90.000000
Minimum:        85.000000
1st Quartile:   87.500000
Median:         90.000000
3rd Quartile:   92.500000
Maximum:        95.000000
Length:         3
Type:           Int64
Number Missing: 0
% Missing:      0.000000


# using pandas!
julia> Pkg.add("Pandas")
julia> using Pandas

julia> pandasDataframe = Pandas.DataFrame(Dict(:Subjects => ["Maths","Physics","Chemistry"],:Marks => [90,85,95]))
   Marks   Subjects
0     90      Maths
1     85    Physics
2     95  Chemistry

julia> Pandas.describe(pandasDataframe)
       Marks
count    3.0
mean    90.0
std      5.0
min     85.0
25%     87.5
50%     90.0
75%     92.5
max     95.0

julia> pandasDataframe[:Subjects]
0        Maths
1      Physics
2    Chemistry
Name: Subjects, dtype: object

julia> pandasDataframe[:Marks]
0    90
1    85
2    95
Name: Marks, dtype: int64

# simple query operation
julia> query(pandasDataframe,:(Marks>90))
   Marks   Subjects
2     95  Chemistry



### Advanced Statistics Topics
# Distributions


julia> Pkg.add("Distributions")
julia> using Distributions


# setting the seed for normal distribution
julia> srand(123)
MersenneTwister(UInt32[0x0000007b], Base.dSFMT.DSFMT_state(Int32[1464307935, 1073116007, 222134151, 1073120226, -290652630, 1072956456, -580276323, 1073476387, 1332671753, 1073438661  …  138346874, 1073030449, 1049893279, 1073166535, -1999907543, 1597138926, -775229811, 32947490, 382, 0]), [1.23253, 1.95067, 1.54183, 1.85035, 1.28927, 1.24474, 1.40729, 1.95055, 1.39839, 1.92576  …  1.79227, 1.83391, 1.89061, 1.74502, 1.57469, 1.24833, 1.69181, 1.48955, 1.40392, 1.75348], 382)

# initialize the distribution
julia> distribution = Normal()
Distributions.Normal{Float64}(μ=0.0, σ=1.0)

# create the random array of 10 element following Normal distribution
julia> x = rand(distribution, 10)
10-element Array{Float64,1}:
  1.19027  
  2.04818  
  1.14265  
  0.459416 
 -0.396679 
 -0.664713 
  0.980968 
 -0.0754831
  0.273815 
 -0.194229


# binomial
julia> Binomial()
Distributions.Binomial{Float64}(n=1, p=0.5)

# cauchy
julia> Cauchy()
Distributions.Cauchy{Float64}(μ=0.0, σ=1.0)

# poissons
julia> Poisson()
Distributions.Poisson{Float64}(λ=1.0)


# TimeSeries

julia> Pkg.add("TimeSeries")
julia> Pkg.add("MarketData")

julia> using TimeSeries
julia> dates  = collect(Date(2017,8,1):Date(2017,8,5))
5-element Array{Date,1}:
 2017-08-01
 2017-08-02
 2017-08-03
 2017-08-04
 2017-08-05

julia> sample_time = TimeArray(dates, rand(length(dates)))
5x1 TimeSeries.TimeArray{Float64,1,Date,Array{Float64,1}} 2017-08-01 to 2017-08-05                     
2017-08-01 | 0.7059  
2017-08-02 | 0.292   
2017-08-03 | 0.2811  
2017-08-04 | 0.7929  
2017-08-05 | 0.2092  

julia> fieldnames(sample_time)
4-element Array{Symbol,1}:
 :timestamp
 :values   
 :colnames 
 :meta  

julia> sample_time.timestamp
5-element Array{Date,1}:
 2017-08-01
 2017-08-02
 2017-08-03
 2017-08-04
 2017-08-05

julia> sample_time.values
5-element Array{Float64,1}:
 0.70586 
 0.291978
 0.281066
 0.792931
 0.20923 

julia> sample_time.colnames
1-element Array{String,1}:
 ""

julia> sample_time.meta

# retrieve the first element
julia> head(sample_time)
1x1 TimeSeries.TimeArray{Float64,2,Date,Array{Float64,2}} 2017-08-01 to 2017-08-01
                     
2017-08-01 | 0.7179  

# retrieve the last element
julia> tail(sample_time)
1x1 TimeSeries.TimeArray{Float64,2,Date,Array{Float64,2}} 2017-08-05 to 2017-08-05
                     
2017-08-05 | 0.4142 



### Hypothesis Testing
julia> Pkg.add('HypothesisTests")
julia> using HypothesisTests

julia> using Distributions

julia> srand(123)
MersenneTwister(UInt32[0x0000007b], Base.dSFMT.DSFMT_state(Int32[1464307935, 1073116007, 222134151, 1073120226, -290652630, 1072956456, -580276323, 1073476387, 1332671753, 1073438661  …  138346874, 1073030449, 1049893279, 1073166535, -1999907543, 1597138926, -775229811, 32947490, 382, 0]), [1.04643, 1.18883, 1.92848, 1.52435, 1.80384, 1.20354, 1.40414, 1.04937, 1.25594, 1.66531  …  1.86043, 1.53826, 1.54179, 1.83724, 1.85687, 1.14965, 1.14176, 1.03677, 1.17827, 1.21738], 382)

julia> sampleOne = rand(Normal(), 10)
10-element Array{Float64,1}:
  1.19027  
  2.04818  
  1.14265  
  0.459416 
 -0.396679 
 -0.664713 
  0.980968 
 -0.0754831
  0.273815 
 -0.194229 

julia> testOne = OneSampleTTest(sampleOne)
One sample t-test
-----------------
Population details:
    parameter of interest:   Mean
    value under h_0:         0
    point estimate:          0.47641935520300993
    95% confidence interval: (-0.13332094295432084, 1.0861596533603408)

Test summary:
    outcome with 95% confidence: fail to reject h_0
    two-sided p-value:           0.11093746407653728

Details:
    number of observations:   10
    t-statistic:              1.7675319478229796
    degrees of freedom:       9
    empirical standard error: 0.2695393176852065


julia> @which OneSampleTTest(sampleOne)
HypothesisTests.OneSampleTTest(v::AbstractArray{T,1}) where T<:Real

julia> pvalue(testOne)
0.11093746407653728

# the most significant
julia> pvalue(testOne, tail=:right) 
0.05546873203826864

# the least significant
julia> pvalue(testOne, tail=:left)
0.9445312679617314


julia> BinomialTest(25, 1000, 0.50)
Binomial test
-------------
Population details:
    parameter of interest:   Probability of success
    value under h_0:         0.5
    point estimate:          0.025
    95% confidence interval: (0.01624253569688223, 0.036684823051923)

Test summary:
    outcome with 95% confidence: reject h_0
    two-sided p-value:           9.125992175283306e-252

Details:
    number of observations: 1000
    number of successes:    25


### optimisation

# JuMP

julia> Pkg.add("JuMP")
julia> Pkg.add("Clp")
julia> using JuMP
julia> using Clp

# creating a model without a solver
julia> m = JuMP.Model()
Feasibility problem with:
 * 0 linear constraints
 * 0 variables
Solver is default solver

# but we want to use Clp as solver, we have
julia> m = JuMP.Model(solver = Clp.ClpSolver())
Feasibility problem with:
 * 0 linear constraints
 * 0 variables
Solver is ClpMathProg


# create optimiser.jl 
using JuMP
using Clp

m = Model(solver = ClpSolver())
@variable(m, 0 <= a <= 2 )
@variable(m, 0 <= b <= 10 )

@objective(m, Max, 5a + 3*b )
@constraint(m, 1a + 5b <= 3.0 )

print(m)

status = solve(m)

println("Objective value: ", getobjectivevalue(m))
println("a = ", getvalue(a))
println("b = ", getvalue(b))

# run optimiser.jl 
mymachine:user$ julia optimiser.jl 
Max 5 a + 3 b
Subject to
 a + 5 b ≤ 3
 0 ≤ a ≤ 2
 0 ≤ b ≤ 10
Objective value: 10.6
a = 2.0
b = 0.2



# Convex.jl

julia> Pkg.add("Convex")
julia> Pkg.add("SCS")
julia> X = Variable(2, 2)
Variable of
size: (2, 2)
sign: Convex.NoSign()
vexity: Convex.AffineVexity()

julia> y = Variable()
Variable of
size: (1, 1)
sign: Convex.NoSign()
vexity: Convex.AffineVexity()

julia> p = minimize(vecnorm(X) + y, 2 * X <= 1, X' + y >= 1, X >= 0, y >= 0)
Problem:
minimize AbstractExpr with
head: +
size: (1, 1)
sign: Convex.NoSign()
vexity: Convex.ConvexVexity()

subject to
Constraint:
<= constraint
lhs: AbstractExpr with
head: *
size: (2, 2)
sign: Convex.NoSign()
vexity: Convex.AffineVexity()

rhs: 1
vexity: Convex.AffineVexity()
		Constraint:
>= constraint
lhs: AbstractExpr with
head: +
size: (2, 2)
sign: Convex.NoSign()
vexity: Convex.AffineVexity()

rhs: 1
vexity: Convex.AffineVexity()
		Constraint:
>= constraint
lhs: Variable of
size: (2, 2)
sign: Convex.NoSign()
vexity: Convex.AffineVexity()
rhs: 0
vexity: Convex.AffineVexity()
		Constraint:
>= constraint
lhs: Variable of
size: (1, 1)
sign: Convex.NoSign()
vexity: Convex.AffineVexity()
rhs: 0
vexity: Convex.AffineVexity()
current status: not yet solved

julia> solve!(p)
----------------------------------------------------------------------------
	SCS v1.2.6 - Splitting Conic Solver
	(c) Brendan O'Donoghue, Stanford University, 2012-2016
----------------------------------------------------------------------------
Lin-sys: sparse-direct, nnz in A = 25
eps = 1.00e-04, alpha = 1.80, max_iters = 20000, normalize = 1, scale = 5.00
Variables n = 7, constraints m = 19
Cones:	primal zero / dual free vars: 1
	linear vars: 13
	soc vars: 5, soc blks: 1
Setup time: 1.09e-04s
----------------------------------------------------------------------------
 Iter | pri res | dua res | rel gap | pri obj | dua obj | kap/tau | time (s)
----------------------------------------------------------------------------
     0|      inf       inf       nan       inf       inf       inf  3.97e-05 
    60| 6.94e-06  8.04e-05  4.05e-05  1.00e+00  1.00e+00  2.20e-16  1.69e-04 
----------------------------------------------------------------------------
Status: Solved
Timing: Solve time: 1.74e-04s
	Lin-sys: nnz in L factor: 51, avg solve time: 5.07e-07s
	Cones: avg projection time: 9.80e-08s
----------------------------------------------------------------------------
Error metrics:
dist(s, K) = 5.8351e-19, dist(y, K*) = 0.0000e+00, s'y/|s||y| = 3.3410e-18
|Ax + s - b|_2 / (1 + |b|_2) = 6.9388e-06
|A'y + c|_2 / (1 + |c|_2) = 8.0432e-05
|c'x + b'y| / (1 + |c'x| + |b'y|) = 4.0465e-05
----------------------------------------------------------------------------
c'x = 1.0000, -b'y = 0.9999
============================================================================

julia> println(round(X.value, 2))
[0.0 0.0; 0.0 0.0]

julia> println(y.value)
1.0000106473513

julia> p.optval
1.0000111259613518











