<div align="center">
    <h1>Sketch</h1>
    <p>A visual debugging library for Roblox</p>
</div>

Sketch is a visual debugging library for Roblox, allowing you to render visual representations of rays, text and shapes with ease.
This project is still in it's infancy, and is just meant to be a quick utility library.

## Purpose
Visually representing information in the 3D World has always been a bit of a hassle on Roblox. After all, even simple visible text
needs to be mounted on a [BillboardGui](https://create.roblox.com/docs/reference/engine/classes/BillboardGui) which then needs to be
attached to an Adornee. This library aims to solve this problem without being destructive or harmful to your normal workflow.

## Documentation
This project is still rather early in development, and though it is completely functional, it does not yet have thorough documentation
beyond the APIs (and some examples you can find in the ``src/example/`` folder). Hopefully documentation can be sorted out some time soon.

## Installation

### Wally
[Wally](https://github.com/UpliftGames/wally) is a package manager for Roblox, allowing you to integrate this (and countless other unique and helpful libraries)
directly into your project through a controlled system. To use this library in wally, you can simply add the following to your `wally.toml`:

```toml
Sketch = "xactlyblue/sketch@1.0.0"
```

### Rojo
If you don't want to use a package manager like Wally, you can git-clone the source code directly into the folder you'd prefer and [Rojo](https://rojo.space) can take care of the rest.

```git clone "https://github.com/xactlyblue/sketch"```
