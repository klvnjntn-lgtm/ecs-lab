## 🛠️ Installation & Setup

### 📋 Prerequisites

Make sure the following are installed and configured:

- AWS Account with sufficient IAM permissions
- Terraform (v1.x recommended)
- AWS CLI

Set required environment variable:

```bash
export TF_VAR_discord_webhook_url="https://discord.com/api/webhooks/..."
```

### 🔐 Configure AWS Credentials
aws configure

Provide:

Access Key
Secret Key
Region
Output format (default is fine)

### 📦 Clone Repository

``` bash git clone https://github.com/klvnjntn-lgtm/cloud-infrastructure-project-kj.git
cd cloud-infrastructure-project-kj
```

### ⚙️ Configuration

Update budget notification email in:

```hcl
budgets.tf
```
```hcl
subscriber_email_addresses = ["your-email@example.com"]
```

### 🧪 Initialize Terraform

```bash
terraform init
```

### 🔍 Review Execution Plan

```bash
terraform plan
```

Review carefully before applying.

### 🚀 Deploy Infrastructure
```bash
terraform apply
```

Type `yes` when prompted.

⏳ Provisioning may take several minutes due to:

Amazon RDS instance creation
NAT Gateway setup

### 🌐 Access the Application

After deployment, Terraform outputs:

```bash
alb_dns_name
```

Open in browser:

```bash
http://<alb-dns-name>
```

### ⚠️ Note:

Initial startup may take 2–3 minutes while ECS tasks pass health checks

### 🧹 Cleanup

```bash
terraform destroy
```

### ⚠️ Cost Awareness

This project uses real AWS resources. Costs may accumulate if left running.

Major Cost Drivers
NAT Gateway → hourly + data processing
Amazon RDS Multi-AZ → ~2× Single-AZ cost
Amazon ECS Fargate → per vCPU & memory usage

💡 Recommendation:
Always run `terraform destroy` after testing to avoid unnecessary charges.

---