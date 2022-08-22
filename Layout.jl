using LinearAlgebra, Graphs, Plots, GraphPlot
import Cairo, Fontconfig

function LayoutToAdj(Layout::Matrix)
    
    grid_size = size(Layout, 1)

    graph = SimpleGraph(sum(Layout))

    node_index = 0
    for i in 1:grid_size
        for j in 1:grid_size
            if Layout[i,j] != 0
                node_index += 1
                for node in [[i, j+1], [i, j-1], [i+1, j], [i-1,j]]
                    if checkbounds(Bool, Layout, node[1], node[2]) && Layout[node[1], node[2]] != 0
                        target = (node[1]-1)*grid_size + node[2]
                        # println(Layout[1:target])
                        target_offset = sum(Layout'[1:target] .== 0)
                        println([i,j], " -> ", node, ", ", node_index, " -> ", target-target_offset, " offset: ", target_offset)
                        add_edge!(graph, node_index, target-target_offset)
                    end
                end
            end
        end
    end
    return graph, adjacency_matrix(graph)
end

function NodeMatrixToGrid(NodeMatrix::Matrix, Layout::Matrix, location)
    
    if Layout[location[1], location[2]] == 0
        throw(ErrorException("Tried to acces a wall in the layout"))
    end

    grid_size = size(Layout, 1)

    output = zeros(size(Layout))

    target = (location[1]-1)*grid_size + location[2]

    target_offset = sum(Layout'[1:target] .== 0)

    non_zero_index = 0
    for i in 1:grid_size
        for j in 1:grid_size
            if Layout[i, j] != 0
                non_zero_index += 1
                output[i, j] = NodeMatrix[target-target_offset, non_zero_index]
            else
                output[i, j] = 0
            end
        end
    end
    return output
end

function plotLayout(Layout::Matrix)
    heatmap(Layout, color=:jet, aspect_ratio=1, size=(600, 600))
end

function PlotGraph(graph, Layout::Matrix)
    locs_x = zeros(sum(Layout))
    locs_y = zeros(sum(Layout))
    node_names = fill("", sum(Layout))
    grid_size = size(Layout, 1)

    non_zero_index = 0
    for i in 1:grid_size
        for j in 1:grid_size
            if Layout[i,j] != 0
                non_zero_index += 1
                locs_y[non_zero_index] = i
                locs_x[non_zero_index] = j
                node_names[non_zero_index] = string([i, j])
            end
        end
    end
    gplot(graph, locs_x, locs_y, nodelabel=node_names)
end

