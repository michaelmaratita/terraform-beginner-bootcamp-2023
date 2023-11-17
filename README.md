# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:
    
**MAJOR.MINOR.PATCH**, e.g. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes


## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyriung changes. Referred to the latest install CLI instructions via Terraform Documentation and changed the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distributions

This project is built against Ubuntu. Please consider checking your Linux Distribution and change accordingly to distribution needs.

[Find Linux Distribution/Version](https://www.cyberciti.biz/faq/find-linux-distribution-name-version-number/)

Example of checking OS Version:
```
$ cat /etc/*-release

DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=22.04
DISTRIB_CODENAME=jammy
DISTRIB_DESCRIPTION="Ubuntu 22.04.3 LTS"
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
``````

### Refactoring into bash scripts

While fixing the Terraform CLI gpg deprication issues, we noticed the bash scripts steps were a considerable amount of code. So we decided to create a bash script to install Terraform CLI.

> Bash script location: [install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](./.gitpod.yml))tidy.
- Allows easier debugging and manual execution of Terraform CLI installation.
- Allows better portability for other projects that need to install Terraform CLI.

#### Shebang Conisderations

A Shebang is a special character sequence used at the beginning of a script or program file to indicate the interpreter that should be used to execute the script. e.g. `#!/bin/bash`

ChatGPT recommneded this format for bash: `#!/usr/bin/env bash`

- for portability with different OS distributions
- will search the user's PATH for bash executable

[Shebang(Unix)](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### Execution Considerations

When executing the bash script, we can use the `./` shorthand to execute the bash script

e.g. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point to the script to a program to interpret it.

e.g. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable, we need to change Linux permissions for the file to be executable at the user level.

[Linux File Permissions (chmod)](https://en.wikipedia.org/wiki/Chmod)

e.g.
- `chmod 744`
- `chmod u+x ./bin/install_terraform_cli`
```
$ ls -la ./bin
total 4
drwxr-xr-x 2 gitpod gitpod  35 Nov  2 16:01 .
drwxr-xr-x 4 gitpod gitpod 113 Nov  2 16:01 ..
-rw-r--r-- 1 gitpod gitpod 578 Nov  2 16:10 install_terraform_cli
$ chmod 744 ./bin/install_terraform_cli
-rwxr--r-- 1 gitpod gitpod 578 Nov  2 16:11 ./bin/install_terraform_cli
```

### Gitpod Workspace Lifecycle (Before, Init, Command)

We need to be careful when using the ***init*** because it will not rerun if we restart an existing workspace.

[Gitpod Workspace Lifecycle](https://www.gitpod.io/docs/configure/workspaces/tasks)

### Working with Env Vars

 We can list out all Environmental Variables (Env Vars) using the `env` command

 We can filter specific env vars using grep, e.g. `env | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal we can set env vars using `export TEST=./test/location`

In the terminal we can unset env vars using `unset TEST`

We can set an env var temporarily when running a command, e.g.:

```sh
TEST=./test/location ./bin/test_echo
```

Within a bash script we can set env vars without writing export, e.g.:

```sh
#!/usr/bin/env bash

TEST=./test/location

echo $TEST
```

#### Printing Env Vars

We can print an env var using echo, e.g. `echo $TEST`

#### Scoping of Env Vars

When you open up new bash terminals in VSCode, it will not be aware of env vars that you have set in another window.

If you want env vars to persist across all future bash terminals that are open, you need to set env vars in your bash profile, e.g. `.bash_profile`

#### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in gitpod user-specific env vars, e.g.:

```
gp env TEST=./test/location
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml`, but this can only contain non-sensitive env vars.

### AWS CLI Installation

AWS CLI is installed for the project via the bash script [install_aws_cli](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials are configured properly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return that looks like this:

```json
{
    "UserId": "AKIAIOSFODNN7EXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credentials from IAM User in order to use AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform Registry which is located at [Terraform Registry](https://registry.terraform.io/)

- **Providers** are interfaces to APIs that will allow creation of resources in Terraform

Example Provider: [random](https://registry.terraform.io/providers/hashicorp/random/latest)

- **Modules** are a way to make large amount of Terraform code modular, portable and shareable.

Example Module: [AWS IAM](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest)


### Terraform Console

We can see a list of all the Terraform commands by typing `terraform`

```
$ terraform
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure
...
```

#### Terraform Init

At the start of a new terraform project, we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

```
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/random from the dependency lock file
- Installing hashicorp/random v3.5.1...
- Installed hashicorp/random v3.5.1 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

#### Terraform Plan

`terraform plan`
Displays changeset for the state of our infrastructure and what will be changed.

```
$ terraform plan
random_string.bucket_name: Refreshing state... [id=5AUoDEyuuWQkNgNv]

Changes to Outputs:
- random_bucket_name    = "5AUoDEyuuWQkNgNv" -> null
+ random_bucket_name_id = "5AUoDEyuuWQkNgNv"

> NOTE: For S3 naming conventions, per AWS:
> - Bucket names can consist only of lowercase letters, numbers, dots (.), and hyphens (-).
> - Bucket names must begin and end with a letter or number.
>
> Ensure **random_string** resource within **main.tf** only meets these parameters, e.g. **NO CAPS**
```

#### Terraform Apply

`terraform apply`
This will run a plan and pass the changeset to be executed by terraform. Only **yes** will apply changes.

If we want to automatically approve an apply, we can provide the `--auto-approve` flag; e.g. `terraform apply --auto-approve`

```
$ terraform apply --auto-approve
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.bucket_name will be created
  + resource "random_string" "bucket_name" {
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + numeric     = true
      + result      = (known after apply)
      + special     = false
      + upper       = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + random_bucket_name = (known after apply)
random_string.bucket_name: Creating...
random_string.bucket_name: Creation complete after 0s [id=80V5DTZJmcykPVtn]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

random_bucket_name = "80V5DTZJmcykPVtn"
```

#### Terraform Destroy

`terraform destroy` will destroy resources from terraform plan. This also works with the `--auto-approve` flag, e.g. `terraform destroy --auto-approve`. Be **CAUTIOUS** of utilizing `--auto-approve`. This will not give you an opportunity to review resources before they are destroyed.

```
$ terraform destroy
random_string.bucket_name: Refreshing state... [id=o92mt21u00s47k90odo53pbs]
aws_s3_bucket.example: Refreshing state... [id=o92mt21u00s47k90odo53pbs]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_s3_bucket.example will be destroyed
  - resource "aws_s3_bucket" "example" {
      - arn                         = "arn:aws:s3:::o92mt21u00s47k90odo53pbs" -> null
      - bucket                      = "o92mt21u00s47k90odo53pbs" -> null
      - bucket_domain_name          = "o92mt21u00s47k90odo53pbs.s3.amazonaws.com" -> null
      - bucket_regional_domain_name = "o92mt21u00s47k90odo53pbs.s3.us-west-1.amazonaws.com" -> null
  ....

  # random_string.bucket_name will be destroyed
  - resource "random_string" "bucket_name" {
      - id          = "o92mt21u00s47k90odo53pbs" -> null
      - length      = 24 -> null
      - lower       = true -> null
      - min_lower   = 0 -> null
      - min_numeric = 0 -> null
  ...

Plan: 0 to add, 0 to change, 2 to destroy.

Changes to Outputs:
  - random_bucket_name = "o92mt21u00s47k90odo53pbs" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_s3_bucket.example: Destroying... [id=o92mt21u00s47k90odo53pbs]
aws_s3_bucket.example: Destruction complete after 0s
random_string.bucket_name: Destroying... [id=o92mt21u00s47k90odo53pbs]
random_string.bucket_name: Destruction complete after 0s
```

#### Terraform Login

Steps to login to Terraform via CLI: 

1. Create a Project and Workspace on [Terraform](https://app.terraform.io/).

- Within the created Workspace, there will be Example code provided by CLI-driven runs, e.g.:

```
terraform {
  cloud {
    organization = "example-org"

    workspaces {
      name = "terra-house-1"
    }
  }
}
```
2. Copy the example code and add to **main.tf**

3. Once added, in the CLI type: `terraform login`
- Type `yes` to proceed to login
- Type `P` to print options
> NOTE: There will be a URL path to create a temporary token
>
> https://app.terraform.io/app/settings/tokens?source=terraform-login
- Choose the appropriate timeframe for Token credentials
- Type `Q` to quit the options pane, and you will be prompted for the token value 
- Paste token value and Press `ENTER`

**Successful login** will show within CLI:

```
Retrieved token for user michaelmaratita


---------------------------------------------------------------------------------

                                          -                                
                                          -----                           -
                                          ---------                      --
                                          ---------  -                -----
                                           ---------  ------        -------
                                             -------  ---------  ----------
                                                ----  ---------- ----------
                                                  --  ---------- ----------
   Welcome to Terraform Cloud!                     -  ---------- -------
                                                      ---  ----- ---
   Documentation: terraform.io/docs/cloud             --------   -
                                                      ----------
                                                      ----------
                                                       ---------
                                                           -----
                                                               -


   New to TFC? Follow these steps to instantly apply an example configuration:

   $ git clone https://github.com/hashicorp/tfc-getting-started.git
   $ cd tfc-getting-started
   $ scripts/setup.sh
```
**Unsuccessful logins** may show up as follows
```
Token for app.terraform.io:
  Enter a value: 

╷
│ Error: Token is invalid: unauthorized
│ 
│ 
╵
```

> NOTE: PATH to where terraform token is saved
>
>   **/home/gitpod/.terraform.d/credentials.tfrc.json**
> 
Example json format for token:

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "ThI$1s@n3x@m9l370k3n"
    }
  }
}
```

### Terraform Lock Files

`terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VSC), e.g. GitHub

### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure. 

This file **SHOULD NOT be committed** to your VSC.

This file can contain sensitive data. 

If you lose this file, you lose information about the state of your infrastructure.

`.terrafrom.tfstate.backup` is the previous state file version.

### Terraform Directory

`.terraform` directory contains binaries of terraform providers.

## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login`, the instructions may seem unclear. Follow steps provided in [Terraform Login](####Terraform-Login). 

The workaround is to manually [generate a token](https://app.terraform.io/app/settings/tokens) in Terraform Cloud and modify the `/home/gitpod/.terraform.d/credentials.tfrc.json` file.

Then create the file manually here and replace the `"token"` value:

```
$ vim /home/gitpod/.terraform.d/credentials.tfrc.json
{
  "credentials": {
    "app.terraform.io": {
      "token": "ThI$1s@n3x@m9l370k3n"
    }
  }
}
```
- `wq!` to save and exit

Automated the process using workaround with the following bash script [generate_tfrc_credentials](bin/generate_tfrc_credentials)