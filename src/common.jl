"""
    database(obj) -> PosteriorDatabase

Return the database containing `obj`.

`obj` can be a `Posterior`, `Model`, `AbstractImplementation`, `Dataset`, or
`ReferencePosterior`.
"""
function database end

"""
    name(obj) -> String

Return the name of `obj`.

`obj` can be a `Posterior`, `Model`, `Dataset`, or `ReferencePosterior`.
"""
function name end

"""
    info(obj) -> AbstractDict

Return the info dictionary for `obj`.

`obj` can be a `Posterior`, `Model`, `Dataset`, or `ReferencePosterior`.
"""
function info end
