
output "loadbalancer" {
  description = "this is the loadblancer name of APP server: "
  value       = module.load-balancer.loadbalancer
}
output "loadbalancer2" {
  description = "this is the loadblancer name of web server: "
  value       = module.load-balancer.loadbalancer2
}

output "rds_endpoint" {
  description = "rds"
  value       = module.database.rdsendpoint
}

