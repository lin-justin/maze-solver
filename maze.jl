const inf = typemax(Int64)
const maze = [
    0 1 0 0 0 0;
    1 0 1 0 1 0;
    0 1 0 0 0 1;
    0 0 0 0 1 0;
    0 1 0 1 0 0;
    0 0 1 0 0 0
]

"""
Find the smallest distant node among nodes
"""
function minimumdist(nodes::Set, dist::Dict)::Int64
    kmin, vmin = nothing, inf
    for (k, v) in dist
        if k in nodes && v <= vmin
            kmin, vmin = k, v
        end
    end
    return kmin
end

"""
Dijkstra's Algorithm
"""
function dijkstra(maze::Array{Int64, 2}, source::Int64 = 1)::Dict
    # Check that the adjacency matrix is squared
    @assert size(maze, 1) == size(maze, 2)
    n = size(maze, 1)

    # Set of unvisited nodes
    Q = Set{Int64}(1:n)
    # Unknown distance function from the source to v
    dist = Dict(n => inf for n in Q)
    # Previous node in optimal path from the source
    prev = Dict(n => 0 for n in Q)
    # Distance from source to source
    dist[source] = 0

    # Until all the nodes are visited
    while !isempty(Q)
        u = minimumdist(Q, dist)
        pop!(Q, u)

        # All remaining vertices are inaccessible from the source
        if dist[u] == inf
            break
        end

        # Each neigbor v of u
        for v in 1:n
            # Where v has not yet been visited
            if maze[u, v] != 0 && v in Q
                alt = dist[u] + maze[u, v]
                if alt < dist[v]
                    dist[v] = alt
                    prev[v] = u
                end
            end
        end
    end

    return prev
end

function showpath(prev::Dict, target::Int64)
    path = "$target"

    while prev[target] != 0
        target = prev[target]
        path = "$target -> " * path
    end

    println(path)
end

@time path = dijkstra(maze)
showpath(path, 6)