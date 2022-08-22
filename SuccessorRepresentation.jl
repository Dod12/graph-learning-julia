using LinearAlgebra

function SuccessorRepresentation(AdjacencyMatrix, gamma)
    ## Setup successor representation from the adjacecncy matrix of a graph.
    #  This follows from the transition matrix, representing the normalized 
    #  transition probabilities from the adjacency matrix.

    TransitionMatrix::Matrix{Float64} = AdjacencyMatrix ./ sum(AdjacencyMatrix, dims=2)

    return inv(I - gamma * TransitionMatrix)
end

function LaplaceTransform()

end