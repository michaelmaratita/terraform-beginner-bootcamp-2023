# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

Example:

Local Tag
```sh
$ git tag -d <tag_name>
```

Remote Tag
```sh
$ git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your GitHub history.

[GitHub tag delete reference](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
├── README.md            - required for root modules
├── main.tf
├── outputs.tf            - stores outputs
├── providers.tf          - defines providers and their configurations
├── terraform.tfvars      - variables data loaded into terraform project
└── variables.tf          - store the structure of input variables
```

## References:
[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In Terraform, we can set two kinds of variables:
- Environmental Variables - set in your **bash terminal**, e.g. PROJECT_ROOT
- Terraform Variables - set in your **tfvars** file

We can set Terraform Cloud variables to be sensitive so they are not shown in plaintext in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

#### Var Flag
We can use the `-var` flag to set an input variable or override an existing variable in the tfvars file, e.g. `terraform plan -var user_uuid="my-unique-user_id`

#### var-file flag
The `-var-file` flag is used to specify the `.tfvars` file to be loaded so that multiple variable definitions can be loaded, e.g. `terraform apply -var-file="my-variables.tfvars"`


#### terraform.tfvars

This is the default file to load in terraform variables in bulk.

#### auto.tfvars

Terraform will automatically load any files with names ending in `.auto.tfvars` or `.auto.tfvars.json`

#### Terraform Variables Precendence

 If the same variable is assigned multiple values, Terraform uses the last value it finds, overriding any previous values. Note that the same variable cannot be assigned multiple values within a single source.

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

## Dealing with Configuration Drift

### What happens if we lose our state file?

Most likely you will have to tear down cloud infrastructure manually.

**HOWEVER**:
You may be able to use `terrform import`. Check [Terraform Registry](https://registry.terraform.io/) to see the Provider's documentation on import support.

### Fix Missing Resources with Terraform Import

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

Example:
`terraform import aws_s3_bucket.bucket ksysdhz3xjrffdc1can6yc9u` - Imports S3 bucket configuration to tfstate file


[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)

### Fix Manual Configuration

In the case where the infrustructure is not in the state Terraform expects, e.g. deleted or modified resources, we can run `terraform plan` to create an execution plan to get the infrustructure back into its expected state;
thus fixing the *configuration drift*

## Fix using Terraform Refresh

`terraform apply -refresh-only --auto-approve`

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a modules directory when locally developing modules.

### Passing Input Variables

We cam pass input variable to our module.
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrashouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module Sources

Using the source we can import the module from various places, e.g.:
- locally
- Github
- Terraform Registry

[Terraform Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may produce older examples that could be deprecated. Often affecting providers.

## Working with Files in Terraform

### Fileexists function

Determines whether a file exists at a given path.

[fileexists reference](https://developer.hashicorp.com/terraform/language/functions/fileexists)

```
fileexists("${path.module}/hello.txt")
true
```

### Filemd5 function

A variant of `md5` that hashes the contents of a given file rather than a literal string.

[filemd5 reference](https://developer.hashicorp.com/terraform/language/functions/filemd5)

`etag = filemd5("${path.root}/public/index.html")`

### Path Variable

In Terraform, there is a special variable called `path` that allows us to reference local paths:

- path.module - get the path for the current module
- path.root - get the path for the root module

[Filesystem and Workspace Info](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

Example:

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"

  etag = filemd5("${path.root}/public/index.html")
}

### Terraform Locals

Terraform local values (or "locals") assign a name to an expression or value. Using locals simplifies your Terraform configuration – since you can reference the local multiple times, you reduce duplication in your code.

[Terraform Locals](https://developer.hashicorp.com/terraform/tutorials/configuration-language/locals)

### Terraform Data Sources

A data source is accessed via a special kind of resource known as a data resource, declared using a `data` block:
```
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

This is useful when we want to reference cloud resourceswithout importing them.

[Terraform Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

### Working with JSON

`jsonencode` encodes a given value to a string using JSON syntax.

We utilized the jsonencode function to create an inline json policy in HCL.

```
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)