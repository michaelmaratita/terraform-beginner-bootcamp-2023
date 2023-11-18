# Terraform Beginner Bootcamp 2023 - Week 1

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
