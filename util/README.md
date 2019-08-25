# Info

The files in this directory are unused by normal terraform deployments. They are
to support Oracle Resource Manager (ORM) and Marketplace deployments

# Files
- Build scripts:
  - `build_mkpl.sh`, packages TF/scripts with mkpl specific files. Output: `mkpl.zip`
  - `build_mkpl_byol.sh`, packages TF/scripts with mkpl specific files against byol image. Output: `mkpl-byol.zip`
  - `build_zip.sh`, packages TF/scripts for ORM *TESTING, NOT READY*. Output: `package.zip`
- Files for builds:
  - `image_subscription.tf`, added to `mkpl.zip` and `mkpl-byol.zip`
  - `mkpl-schema.yaml`, added to `mkpl.zip`
  - `mkpl-variables.tf` added to `mkpl.zip`
  - `mkpl-variables-byol.tf` added to `mkpl-byol.zip`
  - `schema.yaml` added to `package.zip`
