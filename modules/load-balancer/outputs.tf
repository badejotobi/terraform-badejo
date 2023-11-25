output "loadbalancer" {
  description = "this is the loadblancer name OF APP: "
  value       = aws_lb.loading.dns_name
}
output "loadbalancer2" {
  description = "this is the loadblancer name OF WEB: "
  value       = aws_lb.webload.dns_name
}
output "target_arn" {
    description = "target group arn for app server" 
    value = aws_lb_target_group.load-target.arn
}
output "target_arn2" {
 description = "target group arn for web server" 
    value = aws_lb_target_group.web-load-target.arn
}