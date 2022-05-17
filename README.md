# packer-vsphere-debian11
Image building of Debian 11 (Bullseye) with Packer for vSphere 7

An exemplary repository on how to create a Debian 11 (Bullseye) image on vSphere using Packer. It demonstrates

- splitting the configuration into multiple files for easier management
- pre-populating variables with defaults (e.g. `vsphere.pkr.hcl`) and overwriting the defaults in a seperate file (`vsphere.auto.pkrvars.hcl`)
- using shell provisioners to prepare the system and ansible as a local runner to configure the system later on 

## Usage

Clone the repository and change into the repository on a shell. Run the build command `packer build .`. This will load all `.hcl` files in the directory, combining them into the running config.

## Naming conventions

The main Packer file is called as the containing directory to easily identify the entry-point. Other configurations needed are grouped and if there is a significant number of grouped configurations, I create a seperate configuration file that is automatically loaded by Packer during the build process. 

These additional configurations come in one or two files: `.pkr.hcl` contain variable definitions with default values and an optional `.auto.pkrvars.hcl` to overwrite these defaults for all or a subset of the variables. 

The filename used is the prefix for all variables contained within that file, e.g. the file `vsphere.pkr.hcl` defines a variable called `vsphere_vcenter`. This naming convention makes it very easy to identfy the file specifying the variable to make necessary changes later on.


## Credentials

I tend to store all credentials used in a seperate file that I can exclude from version controlling. Inspired by `.env` and `env.example` I commit an exemplary `credentials.auto.pkvars` that can easily be renamed and adjusted.

## Notes

- **Guest OS Identifier** - this should normally be set to `debian11_64Guest`. If you want to use the image created by Packer to deploy VMs with Terraform and include Linux guest OS customization to vSphere, it will ultimatively fail. The only working and not totally incorrect value I found being supported in combination with Debian is `otherLinux64Guest`