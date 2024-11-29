using LinearAlgebra

const ID = UInt64
const Strength = Float32
const CONDUCT = 0.75
const MIN_CHARGE = 0.05
const THRESHOLD_CHARGE = 1

# SNN

struct Signal
    id::ID
    signals::Vector{ID}
end

mutable struct Synapse
    charge::Strength
    weight::Strength
end

struct Dendrite
    levels::Vector{Vector{Synapse}}
end

struct Axon
    terminals::Vector{Synapse}
end

mutable struct Neuron
    const id::ID
    charge::Strength
    const axon::Axon
    const dendrites::Vector{Dendrite}
end

function decay!(n::Neuron, by::Strength=0.9)::nothing
    n.charge *= by
    for d in n.dendrites
        for l in d.levels
            for synapses in l
                for s in synapses
                    s.charge *= by
                end
            end
        end
    end
    nothing
end

function send_signal(sender_id::ID, synapse::Synapse)::nothing
    synapse.charge += synapse.weight
    nothing
end

function evaluate!(n::Neuron)::Bool
    # propagate charges along dendrons

    for dendrite in n.dendrites
        charge::Strength = 0
        for level in dendrite.level
            for s in level
                charge += s.charge * CONDUCT
            end
            if charge < MIN_CHARGE
                charge = 0
                break
            end
        end
        n.charge += charge
    end
    if n.charge >= THRESHOLD_CHARGE
        n.charge -= THRESHOLD_CHARGE
        for synapse in n.axon.terminals
            send_signal(n.id, synapse)
        end
        return true
    end
    false
end

struct NeuralRegion
    id::ID
    neurons::Vector{Neuron}
end

# Memory

struct MemoryStore
    row_memories::Vector{Signal}
    connected::Vector{Vector{ID}}
end

