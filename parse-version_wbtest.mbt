///|
test "version_from_manifest extracts the version field" {
  let content = "name = \"daqing/parse-version\"\n\nversion = \"0.1.0\"\n"
  assert_eq(version_from_manifest(content), Some("0.1.0"))
}

///|
test "version_from_manifest skips comments and other keys" {
  let content = "// version = \"9.9.9\"\nname = \"demo\"\nversion=\"1.2.3\" // trailing\n"
  assert_eq(version_from_manifest(content), Some("1.2.3"))
}

///|
test "version_from_manifest returns none when version is missing" {
  assert_eq(version_from_manifest("name = \"demo\"\n"), None)
}
