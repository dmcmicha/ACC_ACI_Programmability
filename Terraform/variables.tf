variable "apic_url" {}
variable "apic_username" {}
variable "apic_password" {}
variable "new_tenant" {}
variable "new_vrf" {}

variable "bridge_domains" {
  type = map
  default = {
    app_db = {
      name             = "bd_app"
      description      = "Application Core bridge"
      arp_flood        = "no"
      ip_learning      = "yes"
      unicast_route    = "yes"
      subnet           = "1.1.20.1/24"
      subnet_scope     = ["private"]
    },
    web_bd = {
      name             = "bd_web"
      description      = "Web/Apache Front End bridge"
      arp_flood        = "yes"
      ip_learning      = "yes"
      unicast_route    = "yes"
      subnet           = "1.1.30.1/24"
      subnet_scope     = ["private"]
    },
  }
}

variable "end_point_groups" {
  type = map
  default = {
      web_epg = {
          name = "epg_web",
          bd   = "web_bd"

      },
      app_epg = {
          name = "epg_app",
          bd   = "app_db"
      }
  }
}
