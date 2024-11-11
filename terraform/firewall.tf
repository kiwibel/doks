resource "digitalocean_firewall" "k8s_api_server_firewall" {
  name = "k8s-api-server-firewall"

  # REstrict traffic  to Kubernetes API port (6443)
  inbound_rule {
    protocol          = "tcp"
    port_range        = "6443"
    source_addresses  = ["XX.XX.XX.XX/32"]  # Secure access to K8s API
  }

  # Allow traffic from the LoadBalancer to the application on port 5000
  inbound_rule {
    protocol          = "tcp"
    port_range        = "32269"
    source_addresses  = ["10.126.0.2/32"]  # Allow traffic from anywhere (or restrict to LoadBalancer IP range)
  }

inbound_rule {
  protocol          = "tcp"
  port_range        = "5000"
  source_addresses  = ["10.126.0.2/32"]  # Allow traffic from anywhere (or restrict to LoadBalancer IP range)
}

  outbound_rule {
    protocol          = "tcp"
    port_range        = "1-65535"  # Allow all outbound traffic
    destination_addresses = ["0.0.0.0/0"]  # Allow traffic to anywhere
  }

  // Will need to use data source when more than 1 worker node in k8s cluster
  droplet_ids = [digitalocean_kubernetes_cluster.main.node_pool[0].nodes[0].droplet_id]
}
