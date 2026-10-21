///|
test "Version::parse reads the version from moon.mod" {
  assert_eq(@parse-version.Version::parse("moon.mod"), "0.1.0")
}
