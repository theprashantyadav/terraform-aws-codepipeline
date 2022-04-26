variable "s3_bucket_name" {
  type        = string
  default     = ""
  description = "Name of a GCS bucket to store GCE usage reports in (optional)"

}

variable "name" {
  type    = string
  default = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "ActionMode" {
  type    = string
  default = ""
}

variable "Capabilities" {
  type    = string
  default = ""
}

variable "OutputFileName" {
  type    = string
  default = ""
}

variable "StackName" {
  type    = string
  default = ""
}

variable "TemplatePath" {
  type    = string
  default = ""
}