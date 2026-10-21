///|
/// Namespace for reading the `version` field of a MoonBit manifest.
#warnings("-struct_never_constructed")
pub struct Version {}

///|
pub suberror VersionError {
  VersionNotFound(String)
}

///|
pub fn Version::parse(path : String) -> String raise {
  let content = @fs.read_file_to_string(path)
  match version_from_manifest(content) {
    Some(version) => version
    None => raise VersionNotFound(path)
  }
}

///|
fn version_from_manifest(content : String) -> String? {
  for raw_line in content.split("\n") {
    let line = raw_line.trim()
    if line.is_empty() || line.has_prefix("//") {
      continue
    }
    match version_from_line(line) {
      Some(version) => return Some(version)
      None => ()
    }
  }
  None
}

///|
fn version_from_line(line : StringView) -> String? {
  guard line.strip_prefix("version") is Some(rest) else { return None }
  let rest = rest.trim()
  guard rest.strip_prefix("=") is Some(value) else { return None }
  let value = value.trim()
  guard value.strip_prefix("\"") is Some(body) else { return None }
  guard body.split_once("\"") is Some((version, _)) else { return None }
  Some(version.to_owned())
}
