## 💥 Failure Handling & Technical Challenges
This project wasn't just about successful deployments; it was a journey of navigating complex cloud dependencies and security bottlenecks. Below are the primary technical hurdles encountered and the solutions applied.

---

## 1. The S3 Backend "Catch-22" (State Management Architecture)

Problem:
Terraform backend (S3) was managed inside the same root module.

Impact:
terraform destroy failed because it attempted to delete the S3 bucket while it was still being used to store the state → blocked full teardown of infrastructure.

Root Cause:
Recursive dependency between infrastructure state and infrastructure resources.

Solution:
- Moved backend resources to separate /bootstrap module
- Managed with local state
- Ensured backend remains independent and persistent

Result:
Infrastructure can now be safely destroyed and recreated without corrupting state.

---

## 2. IAM OIDC Permission Scoping (The "Identity-Based Access" Challenge)

Problem:
GitHub Actions failed with AccessDenied when creating IAM roles.

Impact:
CI/CD pipeline was blocked — deployments could not proceed.

Root Cause:
- Incorrect resource scoping (logs/sns tied to IAM ARNs)
- OIDC policy did not match dynamically created IAM role names

Solution:
- Split IAM policies into:
  - Scoped IAM actions (prefix-based)
  - Global service permissions (logs, cloudwatch, sns)
- Fixed naming pattern alignment for OIDC trust policy

Result:
CI/CD pipeline successfully provisions infrastructure with least-privilege access.

---

## 3. CloudWatch Log Group Collision (State Drift & Dependency Race)

Problem:
Terraform redeployments failed with ResourceAlreadyExistsException for the VPC Flow Logs log group.

Impact:
Repeated terraform apply/destroy cycles became unreliable, slowing down iteration and making infrastructure changes harder to test.

Root Cause:
- AWS implicitly recreated the log group when VPC Flow Logs were still active, causing state drift
- Terraform attempted to delete the log group while it was still receiving log streams
- Resulted in orphaned resources not tracked in Terraform state

Solution:
- Added explicit dependency to ensure flow logs are destroyed before the log group:
  depends_on = [aws_cloudwatch_log_group.vpc_flow_logs]
- Implemented lifecycle { create_before_destroy = true } to avoid naming conflicts
- Used terraform import to re-sync orphaned resources into state when necessary

Result:
Stable and repeatable deployments with proper resource lifecycle management and reduced state drift issues. This highlighted how AWS-managed services can introduce implicit resources, requiring careful state management in Terraform.

---

## 4. ECR Authorization Failure (CI/CD Pipeline Blocker)

Problem:
Docker image push to ECR failed with 403 Access Denied during CI/CD execution.

Impact:
CI/CD pipeline was blocked, preventing new application versions from being deployed.

Root Cause:
Missing ecr:GetAuthorizationToken permission for the GitHub Actions IAM role, which is required for authenticating Docker to ECR.

Solution:
- Granted ecr:GetAuthorizationToken to the CI/CD IAM role
- Verified full authentication flow:
  GitHub Actions → AWS OIDC → ECR login → Docker push

Result:
CI/CD pipeline successfully authenticates and pushes images to ECR without manual intervention.

---

## 🧠 Key Learnings

- Terraform state must be treated as critical infrastructure, not just configuration
- IAM failures are often due to incorrect resource scoping, not missing permissions
- AWS services can create implicit resources, leading to state drift
- Observability is essential for debugging distributed systems

---