terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Store state locally for now
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "main" {
    name    = "my-k8s-cluster"
    region  = "syd1"
    version = "1.31.1-do.4"  // doctl kubernetes options versions

    node_pool {
        name       = "worker-pool"
        size       = "s-1vcpu-2gb" // list of all available sizes https://slugs.do-api.dev/ or `doctl compute size list`
        node_count = 1
    }

    
}

output "kube_config" {
  sensitive = true
  value = digitalocean_kubernetes_cluster.main.kube_config[0].raw_config
}

# Create a new container registry to store images; 500MB storage free at starter layer
resource "digitalocean_container_registry" "main" {
  name                   = "main-vadim-nz"
  subscription_tier_slug = "starter"
}
