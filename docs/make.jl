using Documenter
using ENN

push!(LOAD_PATH,"../src/")
makedocs(
    sitename = "ENN.jl Documentation",
    format = Documenter.HTML(),
    modules = [ENN]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "git@github.com:AgentLearn/ENN.jl.git",
    devbranch = "main"
)
