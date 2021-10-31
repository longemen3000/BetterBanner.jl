# BetterBanner.jl

## Motivation

This package was done to solve two issues with the start banner (`Base.banner()`):
1. from 1.6 onwards, there is a new `show` method for sparse matrices, that uses braille unicode to draw the sparsity pattern. despite of that, the julia start banner still uses ascii, and there are striking differences between the official logo and the logo recreated.

2. The current banner overflows easily. I have a terrible programming enviroment (by choice) where i choose to have a long, narrow terminal screen, and the display quality of the banner suffers each time. The fact that i saw some julia users on mobile phones (!!) with the same problem, pushed me over the edge to do this.

Lets see the current situation:
![original banner, with enouth space](images/original.PNG)

Seems right, but sometimes, i really want to start julia on a narrow terminal:
![original banner, with not enouth space](images/original_overflow.PNG)

## The Solution

Enter BetterBanner.jl.

The package (or file, this is only one file with no dependencies,wrapped in a package for convenience) replaces the current banner art with one done with braille unicode:

[new banner, with space](images/new.PNG)

it comes with some text overflow protection:
![new banner, overflow](images/new_overflow1.PNG)
![new banner, more overflow](images/new_overflow2.PNG)
![new banner, too much overflow](images/new_overflow3.PNG)
![new banner, insane overflow](images/new_overflow4.PNG)

## Usage

At the moment, copy BetterBanner.jl and add this to your `.julia//config//startup.jl` file (if the file or directory is not there, create it first):

```julia
#startup.jl
include("BetterBanner.jl")
Base.banner(io=stdout) = BetterBanner.banner(io)
```
and that it.

If the package is registered in the future, you can do:

```julia
#startup.jl
using BetterBanner
Base.banner(io=stdout) = BetterBanner.banner(io)
```
