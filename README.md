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
[Shebang Unix](https://en.wikipedia.org/wiki/Shebang_(Unix))
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