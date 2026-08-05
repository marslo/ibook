# macOS Python Upgrade Runbook (Homebrew + pipx + pip)

> Distilled from hands-on testing. **Key split**: a patch bump is near zero-effort; only a minor bump forces rebuilding venvs / reinstalling packages.

## 0. First decide: patch vs minor

| Type | Example | venv / `--user` packages | Action |
|---|---|---|---|
| **patch** (within a minor) | 3.14.0 → 3.14.6 | follow the `opt/python@3.14` symlink, ABI-compatible | basically nothing |
| **minor** | 3.13 → 3.14 / 3.14 → 3.15 | dir keyed to minor + shebang pinned → all invalid | run steps 1–5 below |

```bash
python3 --version
brew list --versions | grep -E 'python@'
```

> [!NOTE]
> Why they break: package dirs live under `.../<minor>/...` and script shebangs hardcode `python@<minor>`. Both `--user` and system installs are hit; changing the install location does not help.

---

## 1. Upgrade Homebrew Python

```bash
brew update
brew upgrade python@3.14          # patch: new bugfix within the same minor
brew install python@3.15          # minor: a new minor is a separate formula, coexists with the old
```

Steps 2–5 apply to a **minor** bump only; for a patch bump you are done here.

---

## 2. pipx: rebuild app venvs onto the new python

```bash
pipx list                                     # note: 'installed using Python X' is a static install-time label, not current state
pipx environment | grep -E 'PIPX_DEFAULT_PYTHON|SHARED'
cat ~/.local/pipx/venvs/<pkg>/pyvenv.cfg      # real python of a given venv

pipx reinstall-all --python python3.15        # rebuild every app venv onto the new python
```

> [!WARNING]
> Pinned packages are skipped with a prompt → `pipx unpin <pkg>` then `pipx reinstall <pkg>`.

The shared venv (shared pip) is **not** rebuilt by `reinstall-all`; it self-heals after the old python is removed (step 5).
To upgrade only the shared pip (unrelated to a python bump): `pipx upgrade-shared`.

---

## 3. pip (`--user`) packages: reinstall onto the new python

`--user` packages live under `~/Library/Python/<minor>/...`; a new minor means a fresh empty dir. **Snapshot before, restore after**:

```bash
# before the upgrade (on the old python)
python3 -m pip list --user --format=freeze > ~/py-user-pkgs.txt
# after the minor upgrade (on the new python)
python3 -m pip install --user -r ~/py-user-pkgs.txt

python3 -m pip install --user --upgrade pip   # upgrade that python's own pip
```

> [!NOTE]
> `--user` does not bypass PEP 668 → keep `break-system-packages=true` to install into Homebrew python.

---

## 4. brew: verify dependents → rebuild → remove the old python

```bash
# 1) who still depends on the old python (reads the installed build's receipt)
brew uses --installed python@3.14

# 2) rebuild them against the current formula → re-bind to the new python
#    note: `brew outdated` may NOT list them (version unchanged, only the dependency changed) → reinstall is required
brew reinstall <formula1> <formula2> ...

# 3) re-verify until empty
brew uses --installed python@3.14             # goal: empty

# 4) drop companion packages + the old python
brew uninstall python-tk@3.14                 # companion that only serves the old python
brew autoremove                               # remove orphans no longer depended on (incl. old python)
brew uninstall python@3.14                    # if autoremove kept it (marked install-on-request)
```

---

## 5. shared venv self-heal + final checks

```bash
# old python is gone → the shared venv's interpreter is invalid → pipx rebuilds it on the new python
pipx repair --python python3.15
cat ~/.local/pipx/shared/pyvenv.cfg | grep -E '^(home|version)'   # should show the new minor

# overall checks
brew list --versions | grep -E 'python@'      # only the new minor remains
brew uses --installed python@3.14             # empty
pipx list                                     # all on the new python
python3 --version

# clean up '~' leftover dirs from interrupted pip runs
find ~/.local ~/Library/Python /opt/homebrew/lib -maxdepth 4 -name '~*' -type d 2>/dev/null
```

> [!IMPORTANT]
> `pipx repair` only rebuilds venvs whose interpreter cannot run → run it **after** the old python is removed, or the shared venv will not migrate (it is a no-op while the old python still exists).

---

## appendix: known traps (may hit after moving to a new python)

| Trap                          | Note / workaround                                                                                                                                                                                         |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Usable python window          | some packages only run on **3.10–3.13** (3.9 too old for pip, 3.14 has the bug above) → pin per-tool with `pipx install --python python3.12 ...`                                                          |
| keyring / subprocess provider | pip's `subprocess` provider excludes its own scripts dir (`/opt/homebrew/bin`) → keyring must live elsewhere (e.g. `~/Library/Python/<minor>/bin` or pipx); `auto`/`import` are unaffected and the safest |
