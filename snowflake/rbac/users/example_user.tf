resource "snowflake_user" "user_example" {
  name                 = "ExampleUser"
  login_name           = "EXAMPLEUSER"
  default_role         = "PUBLIC"
  password             = "replace"
  must_change_password = "true"
  comment              = "Testing"
}
