# Terraform-Ansible Lab 🚀

This project demonstrates an automated infrastructure provisioning and configuration management workflow using **Terraform**, **Packer**, and **Ansible**. It showcases how to create a golden AMI, deploy infrastructure on AWS, and configure it with Ansible to run a basic Nginx web server.

---

## 📁 Project Structure

```
terraform-ansible-lab/
│
├── installation-setup.sh          # Optional: Setup helper script
│
├── ansible/
│   └── nginx.yml                  # Ansible playbook to install and configure Nginx
│
├── packer/
│   ├── golden-ami.pkr.hcl         # Packer template to build a golden AMI
│   └── scripts/
│       └── baseline_packages.sh   # Bash script for baseline image setup
│
├── terraform/
│   ├── main.tf                    # Terraform config to deploy infrastructure
│   └── inventory.tmpl             # Template for dynamic Ansible inventory
│
└── README.md                      # Project documentation
```

---

## 🧰 Tools & Technologies

- **Terraform** – Infrastructure as Code (IaC)
- **Packer** – AMI image creation
- **Ansible** – Configuration management
- **AWS EC2** – Cloud infrastructure provider
- **Shell Script** – Utility setup script

---

## 🔧 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/terraform-ansible-lab.git
cd terraform-ansible-lab
```

### 2. Build the Golden AMI

Make sure you have AWS credentials configured and Packer installed.

```bash
cd packer
packer init .
packer build golden-ami.pkr.hcl
```

### 3. Deploy Infrastructure with Terraform

```bash
cd ../terraform
terraform init
terraform apply -auto-approve
```

### 4. Run Ansible to Configure Instances

Ensure your EC2 instances are accessible (e.g., via SSH key).

```bash
ansible-playbook -i inventory.txt ../ansible/nginx.yml
```

---

## 🌐 Outcome

After running this project:
- A custom AMI with baseline packages will be built using Packer.
- Infrastructure will be deployed via Terraform (e.g., EC2 instance).
- Ansible will configure the instance and install Nginx.

Access the Nginx web page via your EC2 public IP once deployment is complete.

---

## 📝 Notes

- Make sure your AWS account has appropriate IAM permissions for AMI creation and EC2 provisioning.
- Customize `terraform/variables.tf` (if used) to manage your deployment variables.

---

## 📜 License

MIT License. Feel free to use and modify.

---

## 🙌 Acknowledgements

Special thanks to the open-source community for Terraform, Ansible, and Packer.
