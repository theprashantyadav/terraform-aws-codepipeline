variable "s3_bucket_name" {
  type        = string
  default     = ""
  description = "Name of a GCS bucket to store GCE usage reports in (optional)"

}

variable "name" {
  type        = string
  default     = ""
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

variable "location" {
  type    = string
  default = ""

}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-kms"
  description = "Terraform current module repo"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

variable "role_arn" {
  type        = string
  default     = ""
  description = "Optionally supply an existing role"
}


variable "kms_key" {
  type    = string
  default = ""

}