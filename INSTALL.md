# Installing `pica`

This repository is my personal fork of Pi. The command I use day to day is `pica`, so it can live alongside the upstream `pi` command without replacing it.

The setup intentionally has two commands:

- `pica`: runs the built `dist` version from this repo. Use this as the daily coding agent.
- `pica-dev`: runs the TypeScript source through `pi-test.sh`. Use this when actively working on this repo and wanting source edits to take effect immediately.

## Install locally

From the repo root:

```bash
npm run install:pica
```

This runs:

1. `npm install --ignore-scripts`
2. `npm run build`
3. writes launcher scripts into `~/bin`:
   - `~/bin/pica`
   - `~/bin/pica-dev`

`~/bin` must be on `PATH`.

To install into a different directory:

```bash
PICA_BIN_DIR=/some/bin/dir npm run install:pica
```

## Update an existing install

From the repo root:

```bash
npm run update:pica
```

This runs:

1. syncs local `main` with `upstream/main` from `https://github.com/earendil-works/pi.git`, preserving fork commits with a normal merge when needed
2. pushes the synced `main` to `origin`
3. `npm run install:pica`

This is meant to behave like GitHub's **Sync fork** button. It refuses to run if the worktree is dirty, if you are not on `main`, or if local `main` does not match `origin/main`. If upstream changes conflict with this fork, the merge stops for manual conflict resolution.

## Command behavior

After installation:

```bash
pica --version
pica-dev --version
```

`pica` runs:

```bash
node /path/to/pica/packages/coding-agent/dist/cli.js "$@"
```

`pica-dev` runs:

```bash
/path/to/pica/pi-test.sh "$@"
```

The installed upstream command remains separate:

```bash
which pi
which pica
which pica-dev
```

## When to use each command

Use `pica` for normal work. It starts faster because it runs built JavaScript.

Use `pica-dev` when editing this repo. It runs source through `tsx`, so changes are picked up without rebuilding, but startup is slower.

If you change code and want `pica` to pick it up, rebuild/reinstall:

```bash
npm run install:pica
```

## Containers and additional machines

For another machine or container:

```bash
git clone <this-fork-url> pica
cd pica
npm run install:pica
```

If `~/bin` is not appropriate in the container, choose another bin directory:

```bash
PICA_BIN_DIR=/usr/local/bin npm run install:pica
```

For an existing checkout:

```bash
npm run update:pica
```

## Performance note

Running source through `pica-dev` has extra startup overhead because it invokes `tsx` and loads TypeScript directly. Running built dist through `pica` avoids that cost. For long interactive sessions the difference is mostly just launch time; for short scripted invocations, `pica` is preferable.
