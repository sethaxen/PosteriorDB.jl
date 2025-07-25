# PosteriorDB.jl: a Julia package to work with `posteriordb`

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://sethaxen.github.io/PosteriorDB.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://sethaxen.github.io/PosteriorDB.jl/dev/)
[![Build Status](https://github.com/sethaxen/PosteriorDB.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/sethaxen/PosteriorDB.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/sethaxen/PosteriorDB.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/sethaxen/PosteriorDB.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)
[![DOI](https://zenodo.org/badge/556828352.svg)](https://doi.org/10.5281/zenodo.16420622)

PosteriorDB.jl is a Julia package for easily working with a [`posteriordb`](https://github.com/stan-dev/posteriordb) database.
It includes convenience functions for accessing data, model code, and information for individual posteriors, models, data, and reference draws.

## Installation

PosteriorDB can be installed from the Julia general registry with

```julia
] add PosteriorDB
```

## Usage

See the [documentation](https://sethaxen.github.io/PosteriorDB.jl).

## Citing PosteriorDB.jl

If you use PosteriorDB.jl, please cite it using the metadata in the [CITATION.cff](https://github.com/sethaxen/PosteriorDB.jl/blob/main/CITATION.cff) file.
Please also consider citing the [`posteriordb`](https://github.com/stan-dev/posteriordb) software and [paper](https://proceedings.mlr.press/v258/magnusson25a.html) whose metadata are also included.
To generate a citation file in an arbitrary format, click "Cite this repository" on the right on the repo [homepage](https://github.com/sethaxen/PosteriorDB.jl).
