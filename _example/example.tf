provider "aws" {
  region = "eu-west-1"
}

module "codepipeline" {
  source         = "./../"
  name           = "test-pipeline"
  ActionMode     = "REPLACE_ON_FAILURE"
  Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
  OutputFileName = "CreateStackOutput.json"
  StackName      = "MyStack"
  TemplatePath   = "build_output::sam-templated.yaml"
}