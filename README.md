# PendulumControlDemo

[![Build Status](https://github.com/Ratfink/PendulumControlDemo.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Ratfink/PendulumControlDemo.jl/actions/workflows/CI.yml?query=branch%3Amain)

An interactive demo of pendulum control in Julia.

## Installation

From the Julia REPL, run:

```julia
using Pkg; Pkg.add(url="https://github.com/Ratfink/PendulumControlDemo.jl")
```

The demo currently requires a development branch of Makie, found in the
`joystick` branch of [this repository](https://github.com/Ratfink/Makie.jl).
This branch enables work-in-progress joystick support.  After cloning the
repository, you can enable it in Julia with:

```julia
Pkg.develop(path="path/to/Makie.jl")
Pkg.develop(path="path/to/Makie.jl/GLMakie")
```

## Usage

Enter the project directory, located at `~/.julia/dev/PendulumControlDemo` on
Linux.  Run the Julia REPL with `julia --project`.  Then, run the following:

```julia
using PendulumControlDemo
pendulum_run()
```

A window should appear, running the demo.
