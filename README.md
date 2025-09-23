# 🌩️ Cloud Resume Challenge

A full-stack **serverless web application** built as part of the Cloud Resume Challenge.  
This project showcases my ability to design, implement, and manage **cloud-native solutions** using **AWS services** with a strong emphasis on **scalability, cost optimization, security, and Infrastructure as Code (IaC)**.

---

## Key Design
- Static resume website hosted on **Amazon S3**, distributed globally with **CloudFront**
- Infrastructure fully defined and deployed with **Terraform** (IaC)
- **Custom domain with HTTPS** secured via **AWS Certificate Manager (ACM)**
  - 1x ACM certificate for CloudFront
  - 1x ACM certificate for API Gateway  
- **Unique visitor counter**:
  - Tracks visitors for the past 7 days using **cookie-based logic**
  - Cookies stored on the client, validated against **DynamoDB**
  - DynamoDB **TTL** automatically expires entries after 7 days
- **Periodic updates** ensure the visitor counter reflects near-current traffic using API Gatewa
- End-to-end **serverless and event-driven** design (zero server maintenance, pay-per-use cost model)
- Designed with **future scalability in mind** — can easily scale from a few daily visits to thousands without architectural changes

---

## Architecture & Design

### High-Level Flow