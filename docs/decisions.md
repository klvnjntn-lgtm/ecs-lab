## ⚖️ ECS (Fargate) vs Kubernetes (EKS)

This project uses ECS Fargate instead of EKS to prioritize simplicity, faster iteration, and reduced operational overhead.

---

### Decision Drivers

**Lower Operational Complexity**

ECS with Fargate removes the need to manage control planes, worker nodes, and cluster networking.

Kubernetes (EKS) introduces additional operational overhead:
- Cluster provisioning and upgrades
- Node scaling and maintenance
- Networking complexity (CNI, service mesh, etc.)

**Faster Iteration**
ECS enables quicker deployments with fewer moving parts, making it more suitable for small-to-medium scale systems and rapid development cycles.

**Cost Efficiency (at smaller scale)**
Fargate uses a pay-per-resource model (CPU/memory), avoiding always-on compute costs required by EKS worker nodes.

---

### Tradeoffs

**Reduced Flexibility**
Kubernetes provides:
- Greater control over scheduling and networking
- Rich ecosystem (Helm, operators, custom controllers)
- Better portability across cloud providers

---

### Decision Summary

ECS Fargate was chosen to focus on core infrastructure reliability (networking, scaling, failure handling) without introducing unnecessary orchestration complexity.

This decision favors execution speed and operational simplicity over maximum flexibility.

---

## 💸 Cost Considerations

The architecture balances reliability with cost, intentionally accepting higher spend in exchange for resilience and reduced operational risk.

---

### Key Cost Drivers

**Fargate (Pay-as-you-go)**
- No idle EC2 instances
- Cost scales directly with workload

**NAT Gateway (Primary Cost Risk)**
- High outbound traffic can significantly increase cost
- Tradeoff: required to keep ECS services in private subnets

Mitigation:
- VPC endpoints used where possible to reduce NAT usage

**Multi-AZ Deployment**
- Improves availability and fault tolerance
- Increases cost due to resource duplication across AZs

**RDS Multi-AZ**
- Provides automatic failover
- Roughly doubles database cost compared to single-AZ

**Managed Services Tradeoff**

Services like Amazon RDS, Application Load Balancer, and Amazon ECS:
- Increase direct cost
- Reduce operational overhead and failure recovery time

---

### Decision Summary

Higher cost is intentionally accepted to:
- Improve system reliability
- Reduce manual intervention during failures
- Minimize operational complexity

---