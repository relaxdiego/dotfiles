# Credits

`cursor_smear_fade.glsl` is the cursor-trail shader referenced by
`custom-shader` in `../config`. It is third-party work, kept here so the setup
survives a rebuild.

## Origin

Traced to **KroneCorylus/shader-playground**, a playground for building Ghostty
shaders: https://github.com/KroneCorylus/shader-playground

The trail runs through a gist by reshen, "Ghostty smooth fading trailing
cursor", whose header names KroneCorylus as the original author and gives the
path `shaders/cursor_smear_fade.glsl`:
https://gist.github.com/reshen/991d19f9f8c8fedf64ff726f05f05f44

That repository is **MIT licensed** (checked August 2026), which covers keeping
a copy here with attribution.

Two caveats, both checked August 2026:

- The exact file path on GitHub could not be loaded to compare byte for byte —
  the directory listing returned 404, so the repo layout may have changed since
  the file was downloaded in December 2025.
- The copy here has no comment header, so it appears to be KroneCorylus's
  original rather than reshen's modified version. reshen's variant adds a trail
  color that follows Ghostty's `cursor-color` plus a configurable
  `TRAIL_MAX_OPACITY` — worth a look if this one ever needs replacing.

All shaders in this family build on Inigo Quilez's 2D signed-distance-function
techniques, cited in their own headers:
https://iquilezles.org/articles/distfunctions2d/

## Other sources for Ghostty cursor shaders

If this shader needs replacing or you want different effects:

- https://github.com/KroneCorylus/shader-playground — the origin above; also
  the source of the `cursor_blaze_*`, `cursor_smear_*`, `cursor_frozen` and
  `cursor_border_*` family
- https://github.com/sahaj-b/ghostty-cursor-shaders — MIT; trail, ripple and
  pulse effects (`cursor_warp`, `cursor_tail`, `ripple_cursor`, …)
- https://github.com/0xhckr/ghostty-shaders — a large general collection,
  including `cursor_blaze.glsl` and many full-screen effects
- https://github.com/Crackerfracks/Synesthaxia.glsl — a cursor shader that
  adapts to the active colorscheme
- https://gist.github.com/chardskarth/95874c54e29da6b5a36ab7b50ae2d088 —
  a collected set of cursor animation shaders

One shader that was previously kept here, `cursor_smear_gradient.glsl`, carried
its own in-file credit: "Shader Contribution by PremModhaOfficial",
https://github.com/PremModhaOfficial — noted in case it is ever wanted back.

## Note

Ghostty cursor shaders only render correctly with `cursor-style = block`, which
is why `../config` sets it. Inside tmux this makes no difference, since tmux
normalizes the cursor to a block on its own.
See https://github.com/ghostty-org/ghostty/discussions/7865
