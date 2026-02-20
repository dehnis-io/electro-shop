terraform { 

  backend "local" { 

    path = "./terraform.tfstate" 

  } 

} 

# This configuration specifies a local backend for storing Terraform state on a local filesystem