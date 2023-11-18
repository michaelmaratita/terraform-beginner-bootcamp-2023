variable "user_uuid" {
  description = "The UUID of the user"
  type = string
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.user_uuid))
    error_message = "User UUID must be in the format '8-4-4-4-12' hexadecimal characters, e.g., '123e4567-e89b-12d3-a456-426655440000'"
  }
}