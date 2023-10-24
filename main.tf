resource "azurerm_virtual_machine_extension" "res-0" {
  auto_upgrade_minor_version = true
  name                       = "MDE.Linux"
  publisher                  = "Microsoft.Azure.AzureDefenderForServers"
  settings                   = "{\"autoUpdate\":true,\"azureResourceId\":\"/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Compute/virtualMachines/TestVm\",\"forceReOnboarding\":false,\"vNextEnabled\":false}"
  type                       = "MDE.Linux"
  type_handler_version       = "1.0"
  virtual_machine_id         = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Compute/virtualMachines/TestVm"
  depends_on = [
    azurerm_linux_virtual_machine.res-3,
  ]
}
resource "azurerm_resource_group" "res-1" {
  location = "australiaeast"
  name     = "aateterraorst-khq-dev2-aks-australiaeast"
}
resource "azurerm_managed_disk" "res-2" {
  create_option        = "Empty"
  location             = "australiaeast"
  name                 = "1TestVm-DataDisk0"
  resource_group_name  = azurerm_resource_group.res-1.name
  storage_account_type = "Standard_LRS"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_linux_virtual_machine" "res-3" {
  admin_username        = "karbon-admin"
  location              = "australiaeast"
  name                  = "TestVm"
  network_interface_ids = ["/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/networkInterfaces/TestVmNic"]
  resource_group_name   = azurerm_resource_group.res-1.name
  size                  = "Standard_DS3_v2"
  admin_ssh_key {
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0BIS5akGWvfu6nWL/pQ1sQGlbWWRde5/NQotdsNYAZsM6LQ6Z+HqtqLh8KiI3XBeF+6sxQFL0q4tWbYP2gWzjmflwr/b+gDIbqODuF9lR2Syk2ymx2Bue7dbkwwTOtcG3foGgW/XkTAXxIAK1mOHpQRvOv03uNxFlTYdjjdCfIWxn/oTcs4Udew+nVS9QzqsgLeqPykQJo+4DsUE9yOm8O5DU6UXntyIIHQIqTxMy98Evgnjbi+/SMR5AACDYvcg/b1tOTL5zvuKZczqUaHodKzHh+RA6CVSRS0zpCahtWtWynWY5zW6k1qUEhycEb1/R8gjNwzy/nYx+jh956/dikjpZoQsdgmtsf8peZIvU20dVoJ0iehe9QzqC/UkaJvs66JDqJt91PI4lSbW89j692ivDq7ybvbmiNuwiVx75APVj82MAkGxVCJv26FKgEQkIEsNvqERszB02qHRLaNxxMafuZf64Z+bXZpZvTBAj8aaLFG/b82NbmisRsccVwHXpinQfs7nriZtUYIME8cCxxJNzA8LYGm+N7DvTXKGaSZ7qcew/Ydxyfsejcz5fSMUXNbA1kZ1nLpkQCfoSxAjKjWpGpTuH6lHAevFPh+2VHiGpCteDPCS0Z/t4c0LZrPDUcpdNFUvTqQ5Nu69N4BRVT5vsdxHkV9BNx1O/pRdjLw== leszek@override.tech"
    username   = "karbon-admin"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-25,
  ]
}
resource "azurerm_virtual_machine_data_disk_attachment" "res-4" {
  caching            = "ReadWrite"
  create_option      = "Empty"
  lun                = 0
  managed_disk_id    = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Compute/disks/TestVm-DataDisk0"
  virtual_machine_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Compute/virtualMachines/TestVm"
  depends_on = [
    azurerm_managed_disk.res-2,
    azurerm_linux_virtual_machine.res-3,
  ]
}
resource "azurerm_virtual_machine_extension" "res-5" {
  auto_upgrade_minor_version = true
  name                       = "DependencyAgent"
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentLinux"
  type_handler_version       = "9.10"
  virtual_machine_id         = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Compute/virtualMachines/TestVm"
  depends_on = [
    azurerm_linux_virtual_machine.res-3,
  ]
}
resource "azurerm_virtual_machine_extension" "res-6" {
  name                 = "LogAnalytics"
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  settings             = "{\"stopOnMultipleConnections\":false,\"workspaceId\":\"824bbda9-f7b1-4204-9460-57e2b9443019\"}"
  type                 = "OmsAgentForLinux"
  type_handler_version = "1.12"
  virtual_machine_id   = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Compute/virtualMachines/TestVm"
  depends_on = [
    azurerm_linux_virtual_machine.res-3,
  ]
}
resource "azurerm_kubernetes_cluster" "res-11" {
  azure_policy_enabled = true
  dns_prefix           = "aks-australiaeast"
  location             = "australiaeast"
  name                 = "1aks-australiaeast"
  oidc_issuer_enabled  = true
  resource_group_name  = "aatest-khq-dev2-aks-australiaeast"
  tags = {
    createdBy    = "Terraform"
    resourceType = "AKS Cluster"
  }
  workload_identity_enabled = true
  azure_active_directory_role_based_access_control {
    admin_group_object_ids = ["ed671711-cfec-443f-848e-1c59ae13aade"]
    azure_rbac_enabled     = true
    managed                = true
    tenant_id              = "28b85670-622f-484c-a296-3819be61c9eb"
  }
  default_node_pool {
    enable_auto_scaling = true
    max_count           = 5
    min_count           = 1
    name                = "system"
    pod_subnet_id       = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/PodSubnet"
    vm_size             = "Standard_A2_v2"
    vnet_subnet_id      = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/AksSystemSubnet"
  }
  identity {
    identity_ids = ["/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks-australiaeastManagedIdentity"]
    type         = "UserAssigned"
  }
  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0BIS5akGWvfu6nWL/pQ1sQGlbWWRde5/NQotdsNYAZsM6LQ6Z+HqtqLh8KiI3XBeF+6sxQFL0q4tWbYP2gWzjmflwr/b+gDIbqODuF9lR2Syk2ymx2Bue7dbkwwTOtcG3foGgW/XkTAXxIAK1mOHpQRvOv03uNxFlTYdjjdCfIWxn/oTcs4Udew+nVS9QzqsgLeqPykQJo+4DsUE9yOm8O5DU6UXntyIIHQIqTxMy98Evgnjbi+/SMR5AACDYvcg/b1tOTL5zvuKZczqUaHodKzHh+RA6CVSRS0zpCahtWtWynWY5zW6k1qUEhycEb1/R8gjNwzy/nYx+jh956/dikjpZoQsdgmtsf8peZIvU20dVoJ0iehe9QzqC/UkaJvs66JDqJt91PI4lSbW89j692ivDq7ybvbmiNuwiVx75APVj82MAkGxVCJv26FKgEQkIEsNvqERszB02qHRLaNxxMafuZf64Z+bXZpZvTBAj8aaLFG/b82NbmisRsccVwHXpinQfs7nriZtUYIME8cCxxJNzA8LYGm+N7DvTXKGaSZ7qcew/Ydxyfsejcz5fSMUXNbA1kZ1nLpkQCfoSxAjKjWpGpTuH6lHAevFPh+2VHiGpCteDPCS0Z/t4c0LZrPDUcpdNFUvTqQ5Nu69N4BRVT5vsdxHkV9BNx1O/pRdjLw== leszek@override.tech"
    }
  }
  
  oms_agent {
    log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  }
  workload_autoscaler_profile {
    keda_enabled = true
  }
  depends_on = [
    azurerm_user_assigned_identity.res-21,
    azurerm_log_analytics_workspace.res-37,
    # One of azurerm_subnet.res-30,azurerm_subnet_nat_gateway_association.res-31 (can't auto-resolve as their ids are identical)
    # One of azurerm_subnet.res-32,azurerm_subnet_nat_gateway_association.res-33 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_kubernetes_cluster_node_pool" "res-12" {
  enable_auto_scaling   = true
  kubernetes_cluster_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.ContainerService/managedClusters/aks-australiaeast"
  max_count             = 5
  min_count             = 1
  mode                  = "System"
  name                  = "system"
  pod_subnet_id         = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/PodSubnet"
  vm_size               = "Standard_A2_v2"
  vnet_subnet_id        = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/AksSystemSubnet"
  depends_on = [
    azurerm_kubernetes_cluster.res-11,
    # One of azurerm_subnet.res-30,azurerm_subnet_nat_gateway_association.res-31 (can't auto-resolve as their ids are identical)
    # One of azurerm_subnet.res-32,azurerm_subnet_nat_gateway_association.res-33 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_kubernetes_cluster_node_pool" "res-13" {
  enable_auto_scaling   = true
  eviction_policy       = "Delete"
  kubernetes_cluster_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.ContainerService/managedClusters/aks-australiaeast"
  max_count             = 5
  min_count             = 1
  name                  = "user"
  node_taints           = ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]
  pod_subnet_id         = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/PodSubnet"
  priority              = "Spot"
  vm_size               = "Standard_A2_v2"
  vnet_subnet_id        = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/AksSystemSubnet"
  depends_on = [
    azurerm_kubernetes_cluster.res-11,
    # One of azurerm_subnet.res-30,azurerm_subnet_nat_gateway_association.res-31 (can't auto-resolve as their ids are identical)
    # One of azurerm_subnet.res-32,azurerm_subnet_nat_gateway_association.res-33 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_monitor_action_group" "res-15" {
  name                = "emailActionGroupName"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  short_name          = "string"
  email_receiver {
    email_address           = "email@example.com"
    name                    = "Example"
    use_common_alert_schema = true
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_monitor_activity_log_alert" "res-16" {
  description         = "All azure advisor alerts"
  name                = "1AllAzureAdvisorAlert"
  resource_group_name = "aatest-khq-dev2-aks-australiaeast"
  scopes              = ["/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast"]
  action {
    action_group_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Insights/actionGroups/emailActionGroupName"
  }
  criteria {
    category       = "Recommendation"
    operation_name = "Microsoft.Advisor/recommendations/available/action"
  }
  depends_on = [
    azurerm_monitor_action_group.res-15,
  ]
}
resource "azurerm_user_assigned_identity" "res-17" {
  location            = "australiaeast"
  name                = "1aks-australiaeast-simple-message-processor"
  resource_group_name = "aatest-khq-dev2-aks-australiaeastt"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_federated_identity_credential" "res-18" {
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://australiaeast.oic.prod-aks.azure.com/28b85670-622f-484c-a296-3819be61c9eb/652e330d-b27f-4c99-ac02-f5443e9bc803/"
  name                = "1kedaOperator"
  parent_id           = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks-australiaeast-simple-message-processor"
  resource_group_name = "aatest-khq-dev2-aks-australiaeast"
  subject             = "system:serviceaccount:kube-system:keda-operator"
  depends_on = [
    azurerm_user_assigned_identity.res-17,
  ]
}
resource "azurerm_federated_identity_credential" "res-19" {
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://australiaeast.oic.prod-aks.azure.com/28b85670-622f-484c-a296-3819be61c9eb/652e330d-b27f-4c99-ac02-f5443e9bc803/"
  name                = "1myFedIdentity"
  parent_id           = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks-australiaeast-simple-message-processor"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  subject             = "system:serviceaccount:default:workload-identity"
  depends_on = [
    azurerm_user_assigned_identity.res-17,
  ]
}
resource "azurerm_user_assigned_identity" "res-20" {
  location            = "australiaeast"
  name                = "1aks-australiaeastAadPodManagedIdentity"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_user_assigned_identity" "res-21" {
  location            = "australiaeast"
  name                = "1aks-australiaeastManagedIdentity"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_user_assigned_identity" "res-22" {
  location            = "australiaeast"
  name                = "1deployment-script"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_nat_gateway" "res-23" {
  location            = "australiaeast"
  name                = "1aks-australiaeastNatGateway"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_nat_gateway_public_ip_prefix_association" "res-24" {
  nat_gateway_id      = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/natGateways/aks-australiaeastNatGateway"
  public_ip_prefix_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/publicIPPrefixes/aks-australiaeastPublicIpPrefix"
  depends_on = [
    azurerm_nat_gateway.res-23,
    azurerm_public_ip_prefix.res-28,
  ]
}
resource "azurerm_network_interface" "res-25" {
  location            = "australiaeast"
  name                = "1TestVmNic"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/VmSubnet"
  }
  depends_on = [
    # One of azurerm_subnet.res-34,azurerm_subnet_nat_gateway_association.res-35,azurerm_subnet_network_security_group_association.res-36 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_security_group" "res-26" {
  location            = "australiaeast"
  name                = "1VmSubnetNsg"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_network_security_rule" "res-27" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "1AllowSshInbound"
  network_security_group_name = "VmSubnetNsg"
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = "1test-khq-dev2-aks-australiaeast"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-26,
  ]
}
resource "azurerm_public_ip_prefix" "res-28" {
  location            = "australiaeast"
  name                = "1aks-australiaeastPublicIpPrefix"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_virtual_network" "res-29" {
  address_space       = ["10.0.0.0/8"]
  location            = "australiaeast"
  name                = "1aks-australiaeastVnet"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-30" {
  address_prefixes     = ["10.0.0.0/16"]
  name                 = "1AksSystemSubnet"
  resource_group_name  = "1test-khq-dev2-aks-australiaeast"
  virtual_network_name = "1aks-australiaeastVnet"
  depends_on = [
    azurerm_virtual_network.res-29,
  ]
}
resource "azurerm_subnet_nat_gateway_association" "res-31" {
  nat_gateway_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/natGateways/aks-australiaeastNatGateway"
  subnet_id      = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/AksSystemSubnet"
  depends_on = [
    azurerm_nat_gateway.res-23,
    azurerm_subnet.res-30,
  ]
}
resource "azurerm_subnet" "res-32" {
  address_prefixes     = ["10.1.0.0/16"]
  name                 = "1PodSubnet"
  resource_group_name  = "1test-khq-dev2-aks-australiaeast"
  virtual_network_name = "1aks-australiaeastVnet"
  delegation {
    name = "Microsoft.ContainerService/managedClusters"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.ContainerService/managedClusters"
    }
  }
  depends_on = [
    azurerm_virtual_network.res-29,
  ]
}
resource "azurerm_subnet_nat_gateway_association" "res-33" {
  nat_gateway_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/natGateways/aks-australiaeastNatGateway"
  subnet_id      = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/PodSubnet"
  depends_on = [
    azurerm_nat_gateway.res-23,
    azurerm_subnet.res-32,
  ]
}
resource "azurerm_subnet" "res-34" {
  address_prefixes     = ["10.2.0.0/24"]
  name                 = "VmSubnet"
  resource_group_name  = "1test-khq-dev2-aks-australiaeast"
  virtual_network_name = "1aks-australiaeastVnet"
  depends_on = [
    azurerm_virtual_network.res-29,
  ]
}
resource "azurerm_subnet_nat_gateway_association" "res-35" {
  nat_gateway_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/natGateways/aks-australiaeastNatGateway"
  subnet_id      = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/VmSubnet"
  depends_on = [
    azurerm_nat_gateway.res-23,
    # One of azurerm_subnet.res-34,azurerm_subnet_network_security_group_association.res-36 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-36" {
  network_security_group_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/networkSecurityGroups/VmSubnetNsg"
  subnet_id                 = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.Network/virtualNetworks/aks-australiaeastVnet/subnets/VmSubnet"
  depends_on = [
    azurerm_network_security_group.res-26,
    # One of azurerm_subnet.res-34,azurerm_subnet_nat_gateway_association.res-35 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_log_analytics_workspace" "res-37" {
  location            = "australiaeast"
  name                = "1aks-australiaeastworkspace"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-38" {
  category                   = "General Exploration"
  display_name               = "All Computers with their most recent data"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "LogManagement(aks-australiaeastworkspace)_General|AlphabeticallySortedComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize AggregatedValue = max(TimeGenerated) by Computer | limit 500000 | sort by Computer asc\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) by Computer | top 500000 | Sort Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-39" {
  category                   = "General Exploration"
  display_name               = "Stale Computers (data older than 24 hours)"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "LogManagement(aks-australiaeastworkspace)_General|StaleComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize lastdata = max(TimeGenerated) by Computer | limit 500000 | where lastdata < ago(24h)\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) as lastdata by Computer | top 500000 | where lastdata < NOW-24HOURS // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-40" {
  category                   = "General Exploration"
  display_name               = "Which Management Group is generating the most data points?"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "LogManagement(aks-australiaeastworkspace)_General|dataPointsPerManagementGroup"
  query                      = "search * | summarize AggregatedValue = count() by ManagementGroupName\r\n// Oql: * | Measure count() by ManagementGroupName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-41" {
  category                   = "General Exploration"
  display_name               = "Distribution of data Types"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "LogManagement(aks-australiaeastworkspace)_General|dataTypeDistribution"
  query                      = "search * | extend Type = $table | summarize AggregatedValue = count() by Type\r\n// Oql: * | Measure count() by Type // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-42" {
  category                   = "Log Management"
  display_name               = "All Events"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|AllEvents"
  query                      = "Event | sort by TimeGenerated desc\r\n// Oql: Type=Event // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-43" {
  category                   = "Log Management"
  display_name               = "All Syslogs"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|AllSyslog"
  query                      = "Syslog | sort by TimeGenerated desc\r\n// Oql: Type=Syslog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-44" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by Facility"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|AllSyslogByFacility"
  query                      = "Syslog | summarize AggregatedValue = count() by Facility\r\n// Oql: Type=Syslog | Measure count() by Facility // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-45" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by ProcessName"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|AllSyslogByProcessName"
  query                      = "Syslog | summarize AggregatedValue = count() by ProcessName\r\n// Oql: Type=Syslog | Measure count() by ProcessName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-46" {
  category                   = "Log Management"
  display_name               = "All Syslog Records with Errors"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|AllSyslogsWithErrors"
  query                      = "Syslog | where SeverityLevel == \"error\" | sort by TimeGenerated desc\r\n// Oql: Type=Syslog SeverityLevel=error // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-47" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|AverageHTTPRequestTimeByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by cIP\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-48" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by HTTP Method"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|AverageHTTPRequestTimeHTTPMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by csMethod\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-49" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|CountIISLogEntriesClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by cIP\r\n// Oql: Type=W3CIISLog | Measure count() by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-50" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP Request Method"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|CountIISLogEntriesHTTPRequestMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csMethod\r\n// Oql: Type=W3CIISLog | Measure count() by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-51" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP User Agent"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|CountIISLogEntriesHTTPUserAgent"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUserAgent\r\n// Oql: Type=W3CIISLog | Measure count() by csUserAgent // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-52" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Host requested by client"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|CountOfIISLogEntriesByHostRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csHost\r\n// Oql: Type=W3CIISLog | Measure count() by csHost // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-53" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL for the host \"www.contoso.com\" (replace with your own)"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|CountOfIISLogEntriesByURLForHost"
  query                      = "search csHost == \"www.contoso.com\" | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog csHost=\"www.contoso.com\" | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-54" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL requested by client (without query strings)"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|CountOfIISLogEntriesByURLRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-55" {
  category                   = "Log Management"
  display_name               = "Count of Events with level \"Warning\" grouped by Event ID"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|CountOfWarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event EventLevelName=warning | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-56" {
  category                   = "Log Management"
  display_name               = "Shows breakdown of response codes"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|DisplayBreakdownRespondCodes"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by scStatus\r\n// Oql: Type=W3CIISLog | Measure count() by scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-57" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Log"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|EventsByEventLog"
  query                      = "Event | summarize AggregatedValue = count() by EventLog\r\n// Oql: Type=Event | Measure count() by EventLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-58" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Source"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|EventsByEventSource"
  query                      = "Event | summarize AggregatedValue = count() by Source\r\n// Oql: Type=Event | Measure count() by Source // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-59" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event ID"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|EventsByEventsID"
  query                      = "Event | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-60" {
  category                   = "Log Management"
  display_name               = "Events in the Operations Manager Event Log whose Event ID is in the range between 2000 and 3000"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|EventsInOMBetween2000to3000"
  query                      = "Event | where EventLog == \"Operations Manager\" and EventID >= 2000 and EventID <= 3000 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Operations Manager\" EventID:[2000..3000] // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-61" {
  category                   = "Log Management"
  display_name               = "Count of Events containing the word \"started\" grouped by EventID"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|EventsWithStartedinEventID"
  query                      = "search in (Event) \"started\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event \"started\" | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-62" {
  category                   = "Log Management"
  display_name               = "Find the maximum time taken for each page"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|FindMaximumTimeTakenForEachPage"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = max(TimeTaken) by csUriStem\r\n// Oql: Type=W3CIISLog | Measure Max(TimeTaken) by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-63" {
  category                   = "Log Management"
  display_name               = "IIS Log Entries for a specific client IP Address (replace with your own)"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|IISLogEntriesForClientIP"
  query                      = "search cIP == \"192.168.0.1\" | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc | project csUriStem, scBytes, csBytes, TimeTaken, scStatus\r\n// Oql: Type=W3CIISLog cIP=\"192.168.0.1\" | Select csUriStem,scBytes,csBytes,TimeTaken,scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-64" {
  category                   = "Log Management"
  display_name               = "All IIS Log Entries"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|ListAllIISLogEntries"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc\r\n// Oql: Type=W3CIISLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-65" {
  category                   = "Log Management"
  display_name               = "How many connections to Operations Manager's SDK service by day"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|NoOfConnectionsToOMSDKService"
  query                      = "Event | where EventID == 26328 and EventLog == \"Operations Manager\" | summarize AggregatedValue = count() by bin(TimeGenerated, 1d) | sort by TimeGenerated desc\r\n// Oql: Type=Event EventID=26328 EventLog=\"Operations Manager\" | Measure count() interval 1DAY // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-66" {
  category                   = "Log Management"
  display_name               = "When did my servers initiate restart?"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|ServerRestartTime"
  query                      = "search in (Event) \"shutdown\" and EventLog == \"System\" and Source == \"User32\" and EventID == 1074 | sort by TimeGenerated desc | project TimeGenerated, Computer\r\n// Oql: shutdown Type=Event EventLog=System Source=User32 EventID=1074 | Select TimeGenerated,Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-67" {
  category                   = "Log Management"
  display_name               = "Shows which pages people are getting a 404 for"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|Show404PagesList"
  query                      = "search scStatus == 404 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog scStatus=404 | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-68" {
  category                   = "Log Management"
  display_name               = "Shows servers that are throwing internal server error"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|ShowServersThrowingInternalServerError"
  query                      = "search scStatus == 500 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by sComputerName\r\n// Oql: Type=W3CIISLog scStatus=500 | Measure count() by sComputerName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-69" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each Azure Role Instance"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|TotalBytesReceivedByEachAzureRoleInstance"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by RoleInstance\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by RoleInstance // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-70" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each IIS Computer"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|TotalBytesReceivedByEachIISComputer"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by Computer | limit 500000\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-71" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|TotalBytesRespondedToClientsByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-72" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by each IIS ServerIP Address"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by sIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by sIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-73" {
  category                   = "Log Management"
  display_name               = "Total Bytes sent by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|TotalBytesSentByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-74" {
  category                   = "Log Management"
  display_name               = "All Events with level \"Warning\""
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|WarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLevelName=warning // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-75" {
  category                   = "Log Management"
  display_name               = "Windows Firewall Policy settings have changed"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|WindowsFireawallPolicySettingsChanged"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-76" {
  category                   = "Log Management"
  display_name               = "On which machines and how many times have Windows Firewall Policy settings changed"
  log_analytics_workspace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  name                       = "1LogManagement(aks-australiaeastworkspace)_LogManagement|WindowsFireawallPolicySettingsChangedByMachines"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | summarize AggregatedValue = count() by Computer | limit 500000\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 | measure count() by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_log_analytics_solution" "res-555" {
  location              = "australiaeast"
  resource_group_name   = "1test-khq-dev2-aks-australiaeast"
  solution_name         = "ContainerInsights"
  workspace_name        = "1aks-australiaeastworkspace"
  workspace_resource_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.OperationalInsights/workspaces/aks-australiaeastworkspace"
  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
  depends_on = [
    azurerm_log_analytics_workspace.res-37,
  ]
}
resource "azurerm_servicebus_namespace" "res-556" {
  location            = "australiaeast"
  name                = "servicebus1-ebda6356-664c-5c51-bcdc-f88f8e6e1fe4"
  resource_group_name = "1test-khq-dev2-aks-australiaeast"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_servicebus_namespace_authorization_rule" "res-557" {
  listen       = true
  manage       = true
  name         = "1RootManageSharedAccessKey"
  namespace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.ServiceBus/namespaces/servicebus-ebda6356-664c-5c51-bcdc-f88f8e6e1fe4"
  send         = true
  depends_on = [
    # One of azurerm_servicebus_namespace.res-556,azurerm_servicebus_namespace_network_rule_set.res-558 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_servicebus_namespace_network_rule_set" "res-558" {
  namespace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.ServiceBus/namespaces/servicebus-ebda6356-664c-5c51-bcdc-f88f8e6e1fe4"
  depends_on = [
    azurerm_servicebus_namespace.res-556,
  ]
}
resource "azurerm_servicebus_queue" "res-559" {
  name         = "simple1-queue"
  namespace_id = "/subscriptions/f75a4a4f-13c2-4338-899d-9b21afaadb4d/resourceGroups/1test-khq-dev2-aks-australiaeast/providers/Microsoft.ServiceBus/namespaces/servicebus-ebda6356-664c-5c51-bcdc-f88f8e6e1fe4"
  depends_on = [
    # One of azurerm_servicebus_namespace.res-556,azurerm_servicebus_namespace_network_rule_set.res-558 (can't auto-resolve as their ids are identical)
  ]
}
