# DevOps

Herein this repo is a library of cheat sheets and examples that can be used to start up or maintain any task involved in packaging and shipping software.

DevOps is a set of practices, tools, and a cultural philosophy aimed at improving collaboration between development (Dev) and operations (Ops) teams. Its primary goal is to shorten the software development lifecycle while delivering high-quality software in a continuous and automated manner. Here’s a summary of its scope:

1. **Collaboration and Communication**
   - **Cultural Shift:** DevOps promotes collaboration between development, IT operations, and quality assurance (QA) teams. Breaking down silos is essential to streamline the software release process.
   
2. **[Automation](./automation/)**
   - **Continuous Integration (CI):** Automates code integration from multiple developers into a shared repository. Tools like Jenkins, GitLab CI, or CircleCI are commonly used.
   - **Continuous Delivery/Deployment (CD):** Ensures code changes are automatically tested and prepared for release to production. This minimizes manual intervention in deployments.
   - **Infrastructure as Code (IaC):** Managing infrastructure (e.g., servers, networks) using code, allowing versioning, automation, and consistency. Tools include Terraform, Ansible, and AWS CloudFormation.

3. **[Database Management](./databases/)**
   - **Database Automation:** Integrating databases into CI/CD pipelines by automating schema migrations, version control, and updates using tools like Liquibase or Flyway.
   - **Monitoring Databases:** Continuous monitoring of database performance, availability, and health to avoid bottlenecks. Tools such as Prometheus, Datadog, and New Relic are often used for this.
   - **Backup and Recovery:** Automating database backups, replication, and disaster recovery processes to ensure data availability and integrity.

4. **[Monitoring and Feedback](./logging/**
   - **Continuous Monitoring:** Real-time performance monitoring and alerting on applications, servers, and networks, using tools like Prometheus, Grafana, or ELK Stack (Elasticsearch, Logstash, and Kibana).
   - **Incident Response:** Detecting and addressing performance bottlenecks, bugs, or security issues in production environments. Feedback loops provide insights for development teams to improve the product.

5. **[Security](./security/)**
   - **DevSecOps:** Integrating security practices throughout the development and operational processes. Security automation tools like vulnerability scanners (e.g., SonarQube, Aqua) help ensure compliance and reduce risks.

6. **Scalability and Reliability**
   - **High Availability:** Ensuring systems are designed for fault tolerance and reliability, often with cloud-native architectures.
   - **Elastic Scaling:** Automating scaling based on demand using cloud platforms such as AWS, Azure, and GCP.

7. **[Virtualization](./virtualization/)**
   - **Cloud Computing:** Use of public or private cloud services for on-demand resources and infrastructure.
   - **Containerization:** Packaging applications with all dependencies to run consistently across environments using Docker and Kubernetes for orchestration.
   
8. **Configuration Management**
   - **Standardization:** Ensuring system configurations are consistent and repeatable across environments through tools like Puppet or Chef.

In summary, DevOps is about improving speed, quality, and efficiency in software delivery through a combination of automation, continuous feedback, and cultural collaboration. It touches every phase of the software lifecycle, from planning to development, deployment, and monitoring.

## Further Reading

1. [Linux Directory Structure - Hierarchy](https://eng.libretexts.org/Bookshelves/Computer_Science/Operating_Systems/Linux_-_The_Penguin_Marches_On_(McClanahan)/04%3A_Managing_Linux_Storage/5.12%3A_Linux_Directory_Structure/5.12.01%3A_Linux_Directory_Structure_-_Hierarchy)
2. [Linux Directory Structure (File System Structure)](https://www.thegeekstuff.com/2010/09/linux-file-system-structure/)
3. [How to use GitHub Personal Access Token (PAT) in VSCode](https://linuxpip.org/use-github-personal-access-token-in-vscode/)