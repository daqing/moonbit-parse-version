# daqing/parse-version

A tiny MoonBit library that reads the `version` field from a MoonBit manifest (`moon.mod`).

## Installation

```bash
moon add daqing/parse-version
```

Then add the import to your `moon.pkg`:

```moonbit nocheck
///|
import {
  "daqing/parse-version",
}
```

## Usage

### Read the version from `moon.mod`

```moonbit nocheck
///|
fn main {
  let version = @parse-version.Version::parse("moon.mod")
  println(version) // e.g. "0.1.0"
}
```

`Version::parse` takes a path, reads the file and returns the value of the first `version` line in it.

### Handle a missing version

If the manifest does not contain a `version` field, `Version::parse` raises `VersionError::VersionNotFound`, carrying the path that was read:

```moonbit nocheck
///|
fn read_version(path : String) -> String {
  @parse-version.Version::parse(path) catch {
    @parse-version.VersionNotFound(path) =>
      "unknown (\{path} has no version field)"
  }
}
```

## Parsing rules

- Blank lines and lines starting with `//` are skipped.
- The key and the value may be separated by any amount of whitespace: `version="1.2.3"` and `version = "1.2.3"` both work.
- The value must be a quoted string; anything after the closing quote is ignored, so trailing comments are fine.
- The first matching line wins.
- The manifest is not parsed as full TOML, so a `version` line nested in another table would also be picked up.

## API

```moonbit nocheck
pub struct Version {}

pub suberror VersionError {
  VersionNotFound(String)
}

pub fn Version::parse(path : String) -> String raise
```

- `Version::parse(path)` returns the version string, or raises `VersionNotFound(path)`.
- `VersionError` is a sub-error, so it can be caught and re-raised freely in your own error types.

## Development

```bash
moon test          # run tests
moon info && moon fmt
```

## License

Apache-2.0
