resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location
} 

resource "azurerm_network_security_group" "example_nsg" {
    name                = "iac-devops-nsg-909"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_resource_group_lock" "rg_lock" {
  // ตั้งชื่อ Lock
  name                = "rg-do-not-delete-lock"
  // เลือกระดับการ Lock: CanNotDelete หรือ ReadOnly
  lock_level          = "CanNotDelete"
  // เชื่อมโยงกับ Resource Group ที่มีอยู่
  resource_group_name = azurerm_resource_group.rg.name
  
  notes               = "Prevents accidental deletion of this critical Resource Group."
}


resource "azurerm_network_security_rule" "insecure_ssh" {
    name                        = "Allow-SSH-Public"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "10.0.0.4/32"
    destination_address_prefix  = "*"
    network_security_group_name = azurerm_network_security_group.example_nsg.name
    resource_group_name         = azurerm_resource_group.rg.name
}