datacenter = "dc1"
data_dir = "/consul/data"
log_level = "INFO"
server = true
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
bootstrap_expect = 1
ui_config {
  enabled = true
}

connect {
  enabled = true
}

# Session configuration for LiteFS leases
session_ttl_min = "10s"