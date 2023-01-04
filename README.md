# Initialization

```
$ terraform init
Initializing modules...
- null in null-module

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/null...
- Installing hashicorp/null v3.2.1...
- Installed hashicorp/null v3.2.1 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```
$ terraform -version
Terraform v1.3.6
on linux_amd64
+ provider registry.terraform.io/hashicorp/null v3.2.1
```

# Test performance for 1000 null modules

## plan
```
$ time terraform plan

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.null[0].null_resource.null will be created
  + resource "null_resource" "null" {
      + id       = (known after apply)
      + triggers = {
          + "num" = "0"
        }
    }
...
  # module.null[999].null_resource.null will be created
  + resource "null_resource" "null" {
      + id       = (known after apply)
      + triggers = {
          + "num" = "999"
        }
    }

Plan: 1000 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

real    0m1,848s
user    0m2,268s
sys     0m0,483s
```

## apply 1

```
$ time terraform apply -auto-approve
...
module.null[506].null_resource.null: Creating...
module.null[609].null_resource.null: Creation complete after 0s [id=7825907187090359924]
module.null[506].null_resource.null: Creation complete after 1s [id=3946535415560348112]
module.null[890].null_resource.null: Creation complete after 1s [id=3580958328384460550]
module.null[138].null_resource.null: Creation complete after 1s [id=3235302908864257966]

Apply complete! Resources: 1000 added, 0 changed, 0 destroyed.

real    0m17,904s
user    0m19,861s
sys     0m2,217s
```

## apply 2

```
$ time terraform apply -auto-approve
...
module.null[306].null_resource.null: Refreshing state... [id=721503844459168506]
module.null[311].null_resource.null: Refreshing state... [id=7439823931381282110]
module.null[548].null_resource.null: Refreshing state... [id=7779743455862926383]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

real    0m2,804s
user    0m3,106s
sys     0m0,783s
```

## destroy 1

```
$ time terraform apply -destroy -auto-approve
...
module.null[602].null_resource.null: Destroying... [id=4282613589462247445]
module.null[133].null_resource.null: Destruction complete after 1s
module.null[413].null_resource.null: Destruction complete after 0s
module.null[225].null_resource.null: Destruction complete after 0s
module.null[602].null_resource.null: Destruction complete after 0s

Apply complete! Resources: 0 added, 0 changed, 1000 destroyed.

real    0m28,285s
user    0m30,417s
sys     0m2,436s
```

## destroy 2

```
$ time terraform apply -destroy -auto-approve

No changes. No objects need to be destroyed.

Either you have not created any objects yet or the existing objects were already deleted outside of Terraform.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

real    0m0,180s
user    0m0,158s
sys     0m0,021s
```
