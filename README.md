# **Terraform Azure Infrastructure Deployment**

This project uses Terraform to deploy and manage Azure infrastructure, including a resource group, virtual network, subnet, virtual machine, storage account, key vault, and other necessary resources.  

## **Project Structure**
- **`main.tf`** – Contains the primary Terraform configuration for defining Azure resources.  
- **`terraform.vars`** – Stores variable values used across the Terraform configuration.  
- **`variables.tf`** – Defines input variables for better modularity and reusability.  
- **`prod.tf`** – Defines production-specific configurations or additional resources required for the production environment.  

## **Prerequisites**
Ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)  
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)  
- An active **Azure subscription**  

## **Setup & Usage**
### **1. Authenticate with Azure**
Login to Azure CLI:  
```sh
az login
```
Set the subscription (if multiple exist):  
```sh
az account set --subscription "<your-subscription-id>"
```

### **2. Initialize Terraform**
Run the following command to download required providers:  
```sh
terraform init
```

### **3. Plan the Deployment**
Check what changes Terraform will apply:  
```sh
terraform plan
```

### **4. Apply the Deployment**
To create the resources on Azure:  
```sh
terraform apply -auto-approve
```

### **5. Destroy Resources**
If you need to delete the infrastructure:  
```sh
terraform destroy -auto-approve
```

## **Configuration Details**
The project includes:
- **Resource Group**: Manages Azure resources in a specific location.  
- **Virtual Network & Subnet**: Defines networking infrastructure.  
- **Public IP & Network Interface**: Allows external access to the VM.  
- **Virtual Machine**: Deploys an Ubuntu VM.  
- **Storage Account**: Provides cloud storage.  
- **Key Vault**: Manages sensitive data securely.  

## **Security Considerations**
🚨 **DO NOT** commit secrets (client secrets, passwords) to source control. Instead:
- Use **Azure Key Vault** to manage secrets securely.  
- Store sensitive values in a `.tfvars` file and add it to `.gitignore`.  

## **Next Steps**
- Implement Terraform **remote state** using Azure Storage.  
- Improve security by using **Service Principal** authentication instead of hardcoded credentials.  

---

Let me know if you need modifications! 🚀

