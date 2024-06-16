# Multi-Regional 2-Tier Web Architecture on GCP

## Project Overview

This project demonstrates the construction of a robust, scalable, and highly available 2-tier web architecture spread across multiple Google Cloud Platform (GCP) regions.

## Architecture Design

The architecture separates the web and database layers, ensuring better performance and manageability. The core components include:

![Architecture Diagram](https://github.com/ThulithaNawagamuwa/gcp-terraform-project/assets/84464963/4835a0a3-2834-498a-a316-a277b4a37e61)

- **Cloud DNS**: Provides scalable, reliable, and managed authoritative Domain Name System (DNS) service.
- **Cloud Load Balancing**: Distributes incoming traffic across multiple Compute Engine instances to ensure high availability and reliability.
- **Cloud CDN**: Caches content at edge locations to improve load times and reduce latency for end-users.
- **Cloud Storage**: Stores static content, including static web pages and backend web pages.
- **Cloud IAM**: Manages access control and ensures that only authorized entities can access resources.
- **Secret Manager**: Stores and manages sensitive information such as API keys and database passwords securely.
- **Cloud NAT**: Provides outbound internet access for instances in private networks.
- **Compute Engine**: Hosts the web and application servers.
- **Cloud SQL**: Manages relational databases with high availability configurations.

## System Design Best Practices

Incorporating system design best practices, the architecture focuses on:

- **Load Balancing**: Ensures even distribution of traffic and reduces the risk of any single point of failure.
- **Caching**: Improves performance by storing frequently accessed data closer to the end-users.
- **High Availability**: Achieved through redundancy and failover mechanisms across multiple regions.
- **Scalability**: Allows the infrastructure to handle increased load by automatically scaling resources.
- **Enhanced Security**: Implements stringent access controls, encryption, and secure management of secrets.
- **Versioning**: Keeps track of changes to the infrastructure code, enabling rollbacks and better collaboration.

## Infrastructure as Code (IaC) Perspective

The primary focus of this project is provisioning the architecture with an Infrastructure as Code (IaC) approach. IaC is a versatile method for designing cloud infrastructure, offering various capabilities such as:

- **Versioning**: Track changes to the infrastructure configuration, allowing for easy rollbacks and auditing.
- **Collaboration**: Multiple team members can work on the infrastructure code simultaneously, improving productivity and reducing errors.
- **Reusability**: Templates and modules can be reused across different projects, ensuring consistency and saving time.

I have used Terraform as the IaC tool in this project due to its powerful features and community support. Terraform allows us to define the infrastructure in declarative configuration files, which can be version-controlled and shared.

## Continuous Deployment with GitHub Actions

For the continuous deployment part, I utilized GitHub Actions. GitHub Actions is a flexible CI/CD tool that automates the deployment process. Key benefits include:

- **Automation**: Automatically deploy changes to the infrastructure when updates are pushed to the repository.
- **Integration**: Seamlessly integrates with GitHub repositories, triggering workflows based on specific events.
- **Scalability**: Handles complex workflows and parallel job executions.
