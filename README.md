# Deploy a Static Website on AWS using Terraform

## Objective
Create an AWS infrastructure to host a static website using Terraform. The infrastructure will include AWS S3 for storing the website files, CloudFront for content delivery, and Route 53 for domain name management. Additional configurations will involve setting up IAM roles and policies, API Gateway, and SSL certificates.

## Prerequisites

- AWS Account
- Domain name registered in Route 53
- Terraform installed on your local machine

## Tasks

### 1. Initialize the Terraform Project

1. Open a terminal and navigate to the project directory.
2. Run `terraform init` to initialize the Terraform project.

### 2. Creation of modules
 To ensure code is reusable, modules are created for each resource and variables are declared in each module. Each module has its own main.tf, variables.tf and output.tf files.
 Here is a picture of the file structure
 ![file structure for terraform infrastructure](readme-images/Screenshot%20(201).png)


### 3. Configure S3 bucket

In the s3_bucket module [here](./modules/s3_bucket/), the main.tf file contails all configurations necessary for s3 bucket creation and upload of objects into the bucket. Outputs are also printed out [here](./modules/s3_bucket/output.tf) to be used in other modules.
On the aws console the s3 bucket created on using terraform can be seen

### 4. Set up CloudFront Distribution
In the cloudfront module, the code in the main.tf file [here](./modules/cloudffront/main.tf), sets up a CloudFront distribution to serve its content securely. It includes a policy allowing CloudFront to access the bucket and configures the distribution to use a custom domain with an SSL certificate for HTTPS. The CloudFront distribution is set to redirect HTTP to HTTPS and uses the provided ACM certificate for secure connections. outputs for use in the route53 module are also printed here [here](./modules/cloudffront/output.tf)

cloudfront domain hosting static website

### 5. Manage Domain with Route 53
The Route53 module configures Route 53 to manage a custom domain, creating a hosted zone and setting up DNS records. It creates an "A" record to point the domain to the CloudFront distribution and a "CNAME" record for the same purpose, with a TTL of 300 seconds. The CNAME record maps the domain to the CloudFront domain, ensuring proper DNS resolution. The code is seen in the main.tf file here [here](./modules/route53/main.tf)
To transfer a custom domain to AWS, the domain must be managed from the original registrar by updating the name servers to those provided by AWS as seen here:
![management of custom domain](readme-images/Screenshot%20(200).png)

### 6. Security and Access Management
The iam_roles module creates an IAM role named "S3AccessRole" allowing EC2 instances to assume it. It defines an IAM policy "S3AccessPolicy" that provides access to a specific S3 bucket using a policy defined in an external JSON file [here](./modules/iam_roles/s3_access_policy.json). Finally, it attaches this policy to the IAM role, enabling the specified permissions for the role [here](./modules/iam_roles/s3_access_role.tf).

### 7. SSL_certificate configuration
The certificate module provisions an SSL certificate for the domain "temitope.i.ng" using AWS ACM with DNS validation in the main.tf file [here](./modules/certificate/main.tf). It creates the necessary Route 53 DNS records for validation and ensures the certificate is validated before being fully created. The certificate is tagged for identification, and a lifecycle rule ensures the certificate is created before being destroyed during updates.

### 8. Deployment and Testing
After all infrastructure has been created, it can be tested on the terminal to ensure there are no errors using `terraform validate`. If there are no errors, `terraform apply --auto-approve` is used to deploy the infrastructure.