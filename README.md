# Mimi-DICE-2013.jl

## Software Requirements

You need to install [Julia 1.1.0](https://julialang.org) or newer to run this model. You can download Julia from http://julialang.org/downloads/.

## Preparing the Software Environment

You first need to connect your julia installation with the central Mimi registry of Mimi models. This central registry is like a catalogue of models that use Mimi that is maintained by the Mimi project. To add this registry, run the following command at the julia package REPL:

```julia
pkg> registry add https://github.com/mimiframework/MimiRegistry.git
```

You only need to run this command once on a computer.
The next step is to install MimiDICE013.jl itself. You need to run the following command at the julia package REPL:

```julia
pkg> add MimiDICE2013
```

You probably also want to install the Mimi package into your julia environment, so that you can use some of the tools in there:

```julia
pkg> add Mimi
```
## Running the model

The model uses the Mimi framework and it is highly recommended to read the Mimi documentation first to understand the code structure. For starter code on running the model just once, see the code in the file `examples/main.jl`.
