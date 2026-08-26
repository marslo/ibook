<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [common](#common)
- [differences](#differences)
- [configuration](#configuration)
  - [`--no-ext-diff` / `--no-pager` behavior matrix](#--no-ext-diff----no-pager-behavior-matrix)
- [common pitfalls](#common-pitfalls)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> - `difft` is an _external diff_ **engine**
> - `delta` and `diff-highlight` are **pagers** (they only prettify the unified diff git already produced)

<table style="border-collapse:collapse">
  <style>
    table td, table th { vertical-align: middle; text-align: left; }
  </style>
  <thead>
    <tr>
      <th>TOOL</th>
      <th>TYPE</th>
      <th>IMPACT — examples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>difft</code></td>
      <td>external diff<br/><b>engine</b></td>
      <td>
        it <b>replaces</b> git's diff computation, so <b>anything git normally does at the diff layer is skipped</b> — <code>textconv</code> is just one example:
        <ul>
          <li><code>textconv</code> — diffs the raw blob, not the converted text (binary / JSON / <code>hexdump</code> drivers)</li>
          <li><code>.gitattributes</code> <code>diff=&lt;driver&gt;</code> — custom <code>xfuncname</code> hunk headers, <code>wordRegex</code>, etc.</li>
          <li>render / normalize flags — <code>--color-words</code>, <code>--word-diff</code>, <code>diff.colorMoved</code> (zebra), <code>-w</code> / <code>--ignore-*-space</code>, <code>diff.orderFile</code></li>
          <li>output is <b>not a unified patch</b> → <code>git apply</code> / <code>patch</code> / most review tools can't consume it</li>
          <li>still fine: <code>--stat</code> / <code>--numstat</code> / <code>-S</code>/<code>-G</code> pickaxe (git computes these, not the engine)</li>
          <li>only <code>--no-ext-diff</code> bypasses it</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td><code>delta</code></td>
      <td rowspan="2"><b>pager</b><br/><sub>(restyles the diff<br/>git already produced)</sub></td>
      <td>
        <ul>
          <li>honors <code>textconv</code>, <code>--color-words</code>, etc. for free (they run upstream)</li>
          <li>nothing to render when there's no diff → <code>git log -1</code> (no <code>-p</code>) looks unchanged</li>
          <li><code>--no-ext-diff</code> does <b>not</b> disable it — use <code>--no-pager</code></li>
          <li>double-colors when <code>color.diff=always</code> (feed it <code>--no-color</code>)</li>
          <li>chokes on non-unified input (e.g. piping difft's output → mangled)</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td><code>diff-highlight</code></td>
      <td>
        same pager model as delta, lighter:
        <ul>
          <li>passes unknown lines through untouched → tolerant of foreign input</li>
          <li>word-level emphasis only; no line numbers / side-by-side</li>
          <li><code>--no-ext-diff</code> does <b>not</b> disable it — use <code>--no-pager</code></li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

## common

- all make `git diff` / `git log -p` / `git show` output **nicer to read**
- all are **read-only rendering** — they never change the repo or the actual diff data git generates
- all should **yield clean output on a non-tty** (pipe / capture)

## differences

| ASPECT                                 | `difft` (difftastic)                           | `delta` (git-delta)                                            | `diff-highlight`                                                                                   |
| -------------------------------------- | ---------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| category                               | **external diff** — replaces git's diff engine | **pager** — reads git's unified diff                           | **pager** (perl filter), same class as delta                                                       |
| diff algorithm                         | own **structural / syntax-tree (AST)** diff    | git's line-level diff; only recolors/reformats                 | git's line-level diff; adds word-level emphasis                                                    |
| config entry                           | `[diff] external` / `GIT_EXTERNAL_DIFF`        | `[core] pager` / `[pager] <cmd>`                               | `[core] pager` / `[pager] <cmd>`                                                                   |
| bypassed by                            | `git diff --no-ext-diff` ✅                    | `git --no-pager` / `git -c core.pager=cat` auto-off on non-tty | `git --no-pager` / auto-off on non-tty                                                             |
| can act as external?                   | yes (it *is* the external)                     | **no** — doesn't take `GIT_EXTERNAL_DIFF`'s 7 positional args  | **no** — same as delta                                                                             |
| line numbers / side-by-side / navigate | side-by-side, syntax coloring                  | line numbers, side-by-side, `navigate`, hyperlinks             | none, word-level emphasis only                                                                     |
| parseable (for scripts/grep)           | no (own format, not unified)                   | yes (with `--no-pager` it's git's native diff)                 | yes (same as left)                                                                                 |
| install                                | `brew install difftastic`                      | `brew install git-delta`                                       | ships with git contrib `$(brew --prefix git)/share/git-core/contrib/diff-highlight/diff-highlight` |

## configuration

<table style="border-collapse:collapse">
  <style>
    table td, table th { vertical-align: middle; text-align: left; }
  </style>
  <thead>
    <tr>
      <th>CONFIG</th>
      <th>delta<br/><sub>(pager)</sub></th>
      <th>diff-highlight<br/><sub>(pager)</sub></th>
      <th>difft<br/><sub>(external diff)</sub></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>TO BE DEFAULT</b></td>
      <td>
<pre><code>[core]
  pager        = delta
[pager]
  diff         = delta
  log          = delta
[interactive]
  diffFilter   = delta --color-only</code></pre>
      </td>
      <td>
<pre><code>[core]
  pager = diff-highlight | less $LESS -F -x1,5 -X
[pager]
  diff  = diff-highlight | less
  log   = diff-highlight | less -FRXK</code></pre>
      </td>
      <td>
<pre><code>[diff]
  external = difft
[difftool "difftastic"]
  cmd = difft "$LOCAL" "$REMOTE"</code></pre>
      </td>
    </tr>
    <tr>
      <td><b>STYLING</b></td>
      <td>
<pre><code>[delta]
  navigate                 = true
  line-numbers             = true
  side-by-side             = false
  wrap-max-lines           = unlimited
  hyperlinks               = false
  max-line-length          = 0
  syntax-theme             = Catppuccin Mocha
  minus-style              = syntax
  minus-emph-style         = syntax "#45293440"
  plus-style               = syntax
  plus-emph-style          = syntax "#2c3b3480"
  line-numbers-minus-style = "#f38ba8"
  line-numbers-plus-style  = "#a6e3a1"
  line-numbers-zero-style  = "#6c7086"
  zero-style               = syntax
  hunk-header-style        = omit
  file-style               = bold "#89b4fa"
  file-decoration-style    = "#585b70" ul</code></pre>
      </td>
      <td><i>none — word-level emphasis only; tune the trailing <code>less</code> flags</i></td>
      <td><i>not via gitconfig — </i>env vars:
<pre><code>DFT_DISPLAY=side-by-side
DFT_SYNTAX_HIGHLIGHT=on
DFT_BACKGROUND=dark
DFT_TAB_WIDTH=2</code></pre>
      </td>
    </tr>
    <tr>
      <td><b>ON-DEMAND ALIAS</b></td>
      <td>
<pre><code>[alias]
  # redundant once delta is default
  dd = "!git --no-pager diff --no-ext-diff \"$@\" | delta"</code></pre>
      </td>
      <td>
<pre><code>[alias]
  dh = "!f() { git --no-pager diff --no-ext-diff \"$@\" | diff-highlight | less -RFX; }; f"</code></pre>
      </td>
      <td>
<pre><code>[alias]
  dft = -c diff.external=difft diff
  rd  = -c diff.external=difft diff @{u}..@
  pd  = -c diff.external=difft diff @{-1}..@
  nd  = -c diff.external=difft diff --name-status</code></pre>
      </td>
    </tr>
    <tr>
      <td><b>FORCE-USE</b><br/><sub>one-off; ignores<br/>current pager &amp; engine</sub></td>
      <td>
<pre><code>git --no-pager diff --no-ext-diff | delta</code></pre>
      </td>
      <td>
<pre><code>git --no-pager diff --no-ext-diff | diff-highlight | less -R</code></pre>
      </td>
      <td>
<pre><code>git --no-pager -c diff.external=difft diff --ext-diff</code></pre>
      </td>
    </tr>
    <tr>
      <td><b>WAY TO BYPASS</b></td>
      <td>
<pre><code>git --no-pager diff
git -c pager.diff=false diff
# --no-ext-diff does NOT disable delta</code></pre>
      </td>
      <td>
<pre><code>git --no-pager diff
# auto-off when piped (it is a pager)</code></pre>
      </td>
      <td>
<pre><code>git diff --no-ext-diff</code></pre>
      </td>
    </tr>
  </tbody>
</table>


### `--no-ext-diff` / `--no-pager` behavior matrix

| COMMAND                  | INTERACTIVE TERMINAL (TTY)                                                 | PIPE / CAPTURE `$(...)` / <code>&#124; grep</code>             |
| ------------------------ | -------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `git diff`               | delta-rendered                                                             | plain unified diff (pager auto-off)                            |
| `git diff --no-ext-diff` | still delta (pager applies on tty; `--no-ext-diff` only disables external) | **plain unified diff** ✅ (neither external nor pager applies) |
| `git --no-pager diff`    | plain unified diff (pager forced off)                                      | plain unified diff                                             |
| `git dft`                | difftastic side-by-side                                                    | difftastic text (not unified, not for parsing)                 |


## common pitfalls

| PITFALL                                                  | EXPLANATION                                                                               |
| -------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `--no-ext-diff` won't disable delta                      | delta is a pager, not an external. For plain output on a tty, use `--no-pager`.           |
| `git log -1` "isn't using delta"                         | no `-p` means no diff; delta passes it through. Verify with `git log -p -1`.              |
| `pager.<cmd>` outranks `core.pager`                      | to temporarily disable the diff pager use `-c pager.diff=false`, not `-c core.pager=cat`. |
| delta double-colors pre-colored input                    | with `color.diff=always`, add `--no-color` before piping into delta.                      |
| pre-commit always uses `--no-ext-diff` + captured output | neither difft nor delta applies to it; switching diff tools does not affect pre-commit.   |
