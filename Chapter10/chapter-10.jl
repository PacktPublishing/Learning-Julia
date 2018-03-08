### LLVM

# sample code
julia> function fib(n::Int64)
           if n == 1
               return n
           elseif n == 0
               return 0
           else
               return fib(n-1) + fib(n-2)
           end
       end
fib (generic function with 1 method)

julia> fib(10)
55

# Inspect in Julia
julia> @code_llvm(fib(10))

define i64 @julia_fib_62805.2(i64) #0 !dbg !5 {
top:
  %1 = icmp eq i64 %0, 1
  br i1 %1, label %if, label %L4

if:                                               ; preds = %L4, %top
  %merge = phi i64 [ 1, %top ], [ 0, %L4 ]
  ret i64 %merge

L4:                                               ; preds = %top
  %2 = icmp eq i64 %0, 0
  br i1 %2, label %if, label %L9

L9:                                               ; preds = %L4
  %3 = add i64 %0, -1
  %4 = call i64 @julia_fib_62805(i64 %3)
  %5 = add i64 %0, -2
  %6 = call i64 @julia_fib_62805(i64 %5)
  %7 = add i64 %6, %4
  ret i64 %7
}


### Parallel Computing
# current processes
julia> nprocs()
2

# add 2 more processes
julia> addprocs(2)
2-element Array{Int64,1}:
 3
 4

# check the updated processes again
julia> nprocs()
4

# Create a remotecall
julia> remote_call = remotecall(+, 2, 2, 3)
Future(2,1,5,Nullable{Any}())

julia> interim_res = @spawnat 2 1 + fetch(remote_call)
Future(2,1,6,Nullable{Any}())

julia> fetch(interim_res)
6

# running on a single process, i.e when workers are just 1. 

julia> workers()
1-element Array{Int64,1}:
 1

# simple for loop, works perfectly
julia> for i in 1:5
           println(i)
       end
1
2
3
4
5

# parallel for loop running on sigle worker doesn't give a 
# synchronised output
julia> @parallel for i in 1:5
           println(i)
       end
1
1-element Array{Future,1}2:
3
4Future(1,1,1,#NULL)
5

julia> addprocs(2)
2-element Array{Int64,1}:
 2
 3

julia> nprocs()
3

julia> workers()
2-element Array{Int64,1}:
 2
 3

julia> result = @parallel for i in 1:5
           println(i)
       end
2-element Array{Future,1}:
 Future(3,1,5,#NULL)
 Future(2,1,6,#NULL)

julia>  From worker 3:  1
        From worker 3:  2
        From worker 3:  3
        From worker 2:  4
        From worker 2:  5
julia>

julia> pmap(sum, [1 2 3 4 5])
5-element Array{Any,1}:
 1
 2
 3
 4
 5
 
 
 ### TCP Sockets & Servers
 # define the PORT
PORT = 7575

# create the server
server = listen(PORT)

# create the connection
connection = accept(server)

# read the input from the user
aline = readline(connection)

# write the following to the receiver's screen
write(connection, "Hey, how are you?")

# close the connection immediatly
close(connection)

# Sockets
julia> u = UDPSocket()
UDPSocket(init)

julia> bind(u, IPv4(127,0,0,1), 5001)
true

julia> v = UDPSocket()
UDPSocket(init)

julia> bind(v, IPv4(127,0,0,1), 5002)
true

julia> send(v,ip"127.0.0.1",5001,"Hey there!")

julia> msg = recv(u)
10-element Array{UInt8,1}:
 0x48
 0x65
 0x79
 0x20
 0x74
 0x68
 0x65
 0x72
 0x65
 0x21

julia> String(msg)
"Hey there!"

julia> close(u)

julia> close(v)

