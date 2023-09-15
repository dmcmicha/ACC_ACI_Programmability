resource "aci_tenant" "new_tenant" {
  name             = "${var.new_tenant}"
}

resource "aci_vrf" "new_vrf" {
  tenant_dn         = aci_tenant.new_tenant.id
  name              = "${var.new_vrf}"
}

resource "aci_bridge_domain" "new_bridges" {
    for_each = var.bridge_domains
    tenant_dn             = aci_tenant.new_tenant.id
    relation_fv_rs_ctx    = aci_vrf.new_vrf.id
    name                  = each.value.name
    arp_flood             = each.value.arp_flood
    ip_learning           = each.value.ip_learning
    unicast_route         = each.value.unicast_route
}

resource "aci_subnet" "new_subnets" {
    for_each = var.bridge_domains
    parent_dn            = aci_bridge_domain.new_bridges[each.key].id
    ip                   = each.value.subnet
    scope                = each.value.subnet_scope
}

resource "aci_application_profile" "new_ap" {
  tenant_dn         = aci_tenant.new_tenant.id
  name              = "new_ap"
}

resource "aci_contract" "new_con" {
  tenant_dn                 = aci_tenant.new_tenant.id
  name                        = "new_contract"
}

 resource "aci_contract_subject" "new_sub" {
   contract_dn                  = aci_contract.new_con.id
   name                         = "new_subject"
   relation_vz_rs_subj_filt_att = [aci_filter.allow_icmp.id]
}

 resource "aci_filter" "allow_icmp" {
   tenant_dn = aci_tenant.new_tenant.id
   name      = "allow_icmp"
}

 resource "aci_filter_entry" "icmp" {
   name        = "icmp"
   filter_dn   = aci_filter.allow_icmp.id
   ether_t     = "ip"
   prot        = "icmp"
   stateful    = "yes"
}

resource "aci_application_epg" "new_point_groups" {
  for_each = var.end_point_groups

  application_profile_dn  = aci_application_profile.new_ap.id
  name                    = each.value.name
  relation_fv_rs_bd       = aci_bridge_domain.new_bridges[each.value.bd].id
  relation_fv_rs_cons     = [aci_contract.new_con.id]
  relation_fv_rs_prov     = [aci_contract.new_con.id]
}
