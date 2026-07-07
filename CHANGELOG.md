# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.2] - 2026-07-07

### Fixed

- Bumped the `Compat` compat floor from `3.46` to `3.46.2`. `Compat` 3.46.0/3.46.1
  fail to precompile on Julia versions where `Base.@_pure_meta` has been removed
  (e.g. 1.10), since the guard around that call is a plain `if` rather than
  `@static if` and the macro is still expanded during lowering regardless of the
  runtime branch taken. `Compat` 3.46.2 fixed this with a proper `@static if` guard.
