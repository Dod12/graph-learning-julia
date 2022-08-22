include("SuccessorRepresentation.jl")
include("Layout.jl")
using Graphs
using GraphPlot
using Plots
import Cairo, Fontconfig

grid_size = 50

graph = Graphs.grid([grid_size, grid_size], periodic=true)

L = Matrix([1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 0 0 0 0 1 1;
            1 1 0 1 1 0 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1])

L_grid = Matrix([1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1])

A = Matrix(Graphs.LinAlg.adjacency_matrix(graph))

g, A = LayoutToAdj(L)

PlotGraph(g, L)

SR = SuccessorRepresentation(A, 0.98)

print("Calculated successor representation!")

function plot_heatmap_from_starting_point(SuccessorRepresentation::Matrix, starting_point::Tuple{Int64, Int64})
    heatmap(
        reshape(SuccessorRepresentation[grid_size*(starting_point[1] - 1) + starting_point[2],:], (grid_size, grid_size)),
        color=:jet, aspect_ratio=1, size=(600, 600)
    )
end

function plot_eigenvector(F, n)
    heatmap(
        reshape(real(F.vectors[:,length(F.values)-n+1]), (grid_size, grid_size)),
        color=:jet, aspect_ratio=1, size=(600, 600), ori
    )
end

#F = eigen(SR)

node = (5, 5)

#plot_heatmap_from_starting_point(SR, node)
heatmap(NodeMatrixToGrid(Matrix(SR), L, node), aspect_ratio=1, size=(600, 600))
#plot_eigenvector(F, 1)