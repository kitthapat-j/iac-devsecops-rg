resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location
} 

resource "azurerm_network_security_group" "example_nsg" {
    name                = "iac-devops-nsg"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_network_security_rule" "insecure_ssh" {
    name                        = "Allow-SSH-Public"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = azurerm_network_security_group.example_nsg.name
    resource_group_name         = azurerm_resource_group.rg.name
}