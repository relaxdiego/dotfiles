# Credits

The shaders here are the cursor-trail effects for `custom-shader` in
`../config`. They are third-party work, kept here so the setup survives a
rebuild.

- `cursor_blaze.glsl` — in use. Yellow-to-red trail that also lights up the
  cursor block itself.
- `cursor_smear_fade.glsl` — the previous one, a plain yellow trail.

## Origin: cursor_blaze.glsl

Downloaded August 2026 from **KroneCorylus/ghostty-shader-playground**, path
`public/shaders/cursor_blaze.glsl`, branch `main`:
https://github.com/KroneCorylus/ghostty-shader-playground

That repo is **MIT licensed** (checked August 2026). It is the same repository
credited below under its old name, `KroneCorylus/shader-playground` — GitHub
now redirects the old name to the new one, which is why the paths in the next
section no longer resolve.

The file is upstream's byte for byte, plus two local changes, both marked
`LOCAL CHANGE` in the file:

- It returns early when the cursor moves less than `MIN_JUMP_CELLS`
  (1.5 cells), so typing does not set off the effect.
- `DURATION` is 0.1s, down from upstream's 0.3s, matching the speed of the
  older `cursor_smear_fade.glsl`.

A different copy of this shader circulates in `0xhckr/ghostty-shaders` with a
built-in `DRAW_THRESHOLD` that does the same job. It was not used here: that
repo has no license, and its trail drops upstream's saturation pass, so the
colors come out flatter.

## Origin: cursor_smear_fade.glsl

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
  the directory listing returned 404. The repo has since been renamed to
  `KroneCorylus/ghostty-shader-playground` and now keeps its shaders under
  `public/shaders/`, which explains the 404; it holds no `cursor_smear_fade`,
  so this copy could not be re-checked against it.
- The copy here has no comment header, so it appears to be KroneCorylus's
  original rather than reshen's modified version. reshen's variant adds a trail
  color that follows Ghostty's `cursor-color` plus a configurable
  `TRAIL_MAX_OPACITY` — worth a look if this one ever needs replacing.

It carries the same local change as `cursor_blaze.glsl`: it skips the effect
when the cursor moves less than `MIN_JUMP_CELLS` (1.5 cells), so typing does
not flash it. Marked `LOCAL CHANGE` in the file.

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
