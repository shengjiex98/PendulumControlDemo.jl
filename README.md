# PendulumControlDemo

[![Build Status](https://github.com/Ratfink/PendulumControlDemo.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Ratfink/PendulumControlDemo.jl/actions/workflows/CI.yml?query=branch%3Amain)

An interactive demo of pendulum control in Julia.

## Installation

This demo requires Julia 1.9. Install it with
```bash
juliaup add 1.9
```

Then, clone this repository with `git clone --recurse-submodules`. e.g.,
```bash
git clone --recurse-submodules https://github.com/shengjiex98/PendulumControlDemo.jl.git
```
This will automatically clone a development branch of Makie, found in the
`joystick` branch of [this repository](https://github.com/Ratfink/Makie.jl).
This branch enables work-in-progress joystick support.

Finally, start julia within the project folder:
```bash
cd PendulumControlDemo.jl
julia +1.9 --project=.
```

Then, in the Julia REPL, add the development branch of Makie
```julia
using Pkg
Pkg.develop(path="path/to/Makie.jl")
Pkg.develop(path="path/to/Makie.jl/GLMakie")
Pkg.precompile()
```

## Usage

Start julia in the project folder:
```bash
# In the PendulumControlDemo.jl folder
julia +1.9 --project=.
```

Then, in the Julia REPL, run
```julia
using PendulumControlDemo
pendulum_run()
```

A window should appear, running the demo.
