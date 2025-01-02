# Workshop Notes for Monarch Linux

Notes use Jinja2 for templating.

To build notes, run the following:

```
nix develop
just
```

The files will be copied into the `lessons` directory.

## Build without Nix

You can also build without Nix.

```
python template.py
```

The result will be emitted in the `out` directory.
