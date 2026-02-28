variable "ssh_authorized_keys" {
  description = "One or more SSH public keys for instance access. For example: [\"ssh-rsa AAAA...key1\", \"ssh-rsa AAAA...key2\"]"
  type        = list(string)
}

variable "compartment_id" {
  description = "The OCID of the compartment. Find it: Profile → Tenancy: youruser → Tenancy information → OCID https://cloud.oracle.com/tenancy"
  type        = string
}

variable "source_image_id" {
  description = "Source Ubuntu 22.04 image OCID. Find the right one for your region: https://docs.oracle.com/en-us/iaas/images/image/128dbc42-65a9-4ed0-a2db-be7aa584c726/index.htm"
  type        = string
}

variable "num_worker_instances" {
  description = "Number of Dokploy worker instances to deploy. Max 3 for Always Free tier (3 workers + 1 main = 4 instances, 4 OCPUs, 24 GB total)."
  type        = number
  default     = 3
}

variable "availability_domain_main" {
  description = "Availability domain for dokploy-main instance. Find it Core Infrastructure → Compute → Instances → Availability domain (left menu). For example: WBJv:EU-FRANKFURT-1-AD-1"
  type        = string
}

variable "availability_domain_workers" {
  description = "Availability domain for dokploy-worker instances. Find it Core Infrastructure → Compute → Instances → Availability domain (left menu). For example: WBJv:EU-FRANKFURT-1-AD-2"
  type        = string
}

variable "instance_shape" {
  description = "The shape of the instance. VM.Standard.A1.Flex is free tier eligible."
  type        = string
  default     = "VM.Standard.A1.Flex" # OCI Free
}

variable "memory_in_gbs" {
  description = "Memory in GBs per instance. At 6 GB with 4 instances (1 main + 3 workers), total is 24 GB — the Always Free ceiling."
  type        = string
  default     = "6" # OCI Free
}

variable "ocpus" {
  description = "OCPUs per instance. At 1 OCPU with 4 instances (1 main + 3 workers), total is 4 OCPUs — the Always Free ceiling."
  type        = string
  default     = "1" # OCI Free
}

variable "admin_cidr" {
  description = "CIDR block allowed to access the Dokploy admin dashboard (port 3000). Restrict this to your IP for better security, e.g. '1.2.3.4/32'. Defaults to open — change before production use."
  type        = string
  default     = "0.0.0.0/0"
}
