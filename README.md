<a id="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Unlicense License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
<br>

![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)<br>
[![Infrastructure CI][ci-shield]][ci-url]
[![Production Deployment][cd-shield]][cd-url]
[![Update Documentation][docs-shield]][docs-url]

<div>
  <p>
    <strong>Notice:</strong> This project has been migrated from a monolithic collection at <a href="https://github.com/ShenLoong99/my-terraform-aws-projects-2025">my-terraform-aws-projects-2025</a> to this dedicated repository for better project isolation and CI/CD management.<br>
    To review the full development lifecycle, including initial architectural decisions and incremental code changes, please refer to the original commit history in the source repository.
  </p>

  <h1>📷 AWS Image Labels Generator</h1>
    <img src="assets/cats-ui-output.png" alt="cats-ui-output" width="800">
    <p>
        The <strong>AWS Image Labels Generator</strong> is a cloud-native automated solution designed to detect and catalog objects, scenes, and concepts within images. By leveraging advanced machine learning, this project allows users to upload images to a secure cloud storage environment and receive detailed metadata labels with high confidence scores.
        <br />
      <a href="#about-the-project"><strong>Explore the docs »</strong></a>
    </p>
</div>

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#built-with">Built With</a></li>
    <li><a href="#use-cases">Use Cases</a></li>
    <li><a href="#architecture">Architecture</a></li>
    <li><a href="#file-structure">File Structure</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#challenges-faced">Challenges</a></li>
    <li><a href="#cost-optimization">Cost Optimization</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<h2 id="about-the-project">About The Project</h2>
<p>
    This project was built to demonstrate a modern <strong>GitOps workflow</strong> and <strong>Infrastructure as Code (IaC)</strong> principles using Terraform Cloud. It provides a bridge between raw image data and actionable insights, suitable for applications ranging from automated media tagging to brand coverage analysis.
</p>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="built-with">Built With</h2>
<p>
  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/terraform/terraform-original.svg" alt="terraform" width="45" height="45" style="margin: 10px;"/>
  <img src="https://raw.githubusercontent.com/weibeld/aws-icons-svg/main/q1-2022/Resource-Icons_01312022/Res_Storage/Res_48_Light/Res_Amazon-Simple-Storage-Service_S3-Standard_48_Light.svg" alt="s3" width="45" height="45" style="margin: 10px;"/>
  <img src="https://raw.githubusercontent.com/weibeld/aws-icons-svg/main/q1-2022/Architecture-Service-Icons_01312022/Arch_Machine-Learning/48/Arch_Amazon-Rekognition_48.svg" alt="rekognition" width="45" height="45" style="margin: 10px;"/>
  <img src="https://raw.githubusercontent.com/weibeld/aws-icons-svg/main/q1-2022/Architecture-Service-Icons_01312022/Arch_Security-Identity-Compliance/48/Arch_AWS-Identity-and-Access-Management_48.svg" alt="iam" width="45" height="45" style="margin: 10px;"/>
  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="45" height="45" style="margin: 10px;"/>
</p>
<ul>
  <li><strong>Terraform:</strong> Used for Infrastructure as Code to provision and manage AWS resources.</li>
  <li><strong>Terraform Cloud:</strong> Manages the VCS-driven workflow and state for the infrastructure.</li>
  <li><strong>AWS S3:</strong> Provides highly durable and scalable object storage for the source images.</li>
  <li><strong>Amazon Rekognition:</strong> A deep-learning-based service that performs the heavy lifting of image analysis and label detection.</li>
  <li><strong>AWS IAM:</strong> Ensures secure, least-privilege access for the application code to interact with AWS services.</li>
  <li><strong>Python (Boto3):</strong> The programming language and SDK used to execute the label detection logic.</li>
</ul>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="use-cases">Use Cases</h2>
<p>
    Amazon Rekognition is a highly versatile service with applications across many industries. This project can be adapted for the following real-world scenarios:
</p>
<ul>
    <li><strong>Smart Surveillance Systems:</strong> Automatically recognize suspicious objects or activities on roads to enhance public safety.</li>
    <li><strong>Inventory Management:</strong> Identify and catalog products in a store environment to streamline supply chain operations.</li>
    <li><strong>Retail Analytics:</strong> Analyze customer behavior within physical stores to optimize layouts and marketing strategies.</li>
    <li><strong>Accessibility Solutions:</strong> Provide automated descriptions of surroundings to assist individuals who are visually impaired.</li>
</ul>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="architecture">Architecture</h2>
<p align="center">
  <img src="assets/AWS-Image-Labels-Generator.jpg" alt="Architecture Diagram" width="800">
</p>
<p>
  The system follows a serverless-inspired architecture to ensure scalability and cost-efficiency:
</p>
<ol>
  <li><strong>Storage & Trigger:</strong> An image is uploaded to the S3 Bucket. This action automatically triggers an S3 Event Notification.</li>
  <li><strong>Compute: AWS Lambda</strong> receives the event, extracts the image metadata, and sends it to Amazon Rekognition.</li>
  <li><strong>Analysis:</strong> Rekognition performs label detection and returns the results to the Lambda function.</li>
  <li><strong>Logging:</strong> Results and confidence scores are streamed to Amazon CloudWatch Logs for real-time monitoring.</li>
</ol>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="file-structure">File Structure</h2>
<pre>.
├── assets/                     # Architecture diagrams and UI screenshots
├── lambda/                     # Backend Serverless Logic
│   ├── detect_labels.py        # Python script for Rekognition & CloudWatch logging
│   └── function.zip            # Optimized deployment package (<1KB)
├── main.tf                     # Core IaC: Provisions S3, Lambda, and Rekognition IAM
├── output.tf                   # Defines S3 bucket names and IAM role ARNs for CLI use
├── terraform.tf                # Terraform Cloud backend & workspace configuration
├── variable.tf                 # Input variables for AWS Region and resource tagging
├── .gitignore                  # Prevents tracking of .terraform and local state backups
├── .terraform.lock.hcl         # Ensures consistent provider versions across environments
└── README.md                   # Project documentation and setup guide
</pre>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="getting-started">Getting Started</h2>
<h3>Prerequisites</h3>
<ul>
    <li>An active <strong>AWS Account</strong>.</li>
    <li><strong>Terraform CLI / Terraform Cloud(optional)</strong> for IaC deployment.</li>
    <li><strong>Python 3.x</strong> installed locally for running the detection script.</li>
    <li><strong>Set your AWS Region:</strong> Set to whatever <code>aws_region</code> you want in <code>variables.tf</code>.</li>
</ul>

<h3>Terraform State Management</h3>
<p>Select one:</p>
<ol>
   <li>Terraform Cloud</li>
   <li>Terraform Local CLI</li>
</ol>

<h4>Terraform Cloud Configuration</h4>
<p>If you choose Terraform Cloud, please follow the steps below:</p>
<ol>
   <li>Create a new <strong>Workspace</strong> in Terraform Cloud.</li>
   <li>In the Variables tab, add the following <strong>Terraform Variables:</strong>
   </li>
   <li>
    Add the following <strong>Environment Variables</strong> (AWS Credentials):
    <ul>
      <li><code>AWS_ACCESS_KEY_ID</code></li>
      <li><code>AWS_SECRET_ACCESS_KEY</code></li>
   </ul>
   </li>
</ol>

<h4>Terraform Local CLI Configuration</h4>
<p>If you choose Terraform Local CLI, please follow the steps below:</p>
<ol>
   <li>
      Comment the <code>backend</code> block in <code>terraform.tf</code>:
      <pre># backend "remote" {
#   hostname     = "app.terraform.io"
#   organization = "my-terraform-aws-projects-2025"
#   workspaces {
#     name = "AWS-Image-Labels-Generator"
#   }
# }</pre>
   </li>
   <li>
    Add the following <strong>Environment Variables</strong> (AWS Credentials):
    <pre>git bash command:
export AWS_ACCESS_KEY_ID=&lt;your-aws-access-key-id&gt;
export AWS_SECRET_ACCESS_KEY=&lt;your-aws-secret-access-key&gt;
</ol>

<h3>Installation & Deployment</h3>
<ol>
    <li>
        <strong>Clone the Repository</strong>
    </li>
    <li>
        <strong>Provision Infrastructure:</strong>
        <ul>
          <li>
            <strong>Terraform Cloud</strong> → <strong>Initialize & Apply:</strong> Push your code to GitHub. Terraform Cloud will automatically detect the change, run a <code>plan</code>, and wait for your approval.
          </li>
          <li>
            <strong>Terraform CLI</strong> → <strong>Initialize & Apply:</strong> Run <code>terraform init</code> → <code>terraform plan</code> → <code>terraform apply</code>, and wait for your approval.
          </li>
        </ul>
    </li>

</ol>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="usage">Usage & Testing</h2>
<p>
  To generate labels for an image, follow these steps:
</p>
<ol>
  <li>
    Upload an image (e.g., <code>busy-traffic-road.jpg</code>) to the S3 bucket created by Terraform.<br>
    <pre>aws s3 cp &lt;your-image-file-name&gt; s3://&lt;your-s3-bucket-name&gt;</pre>
    <img src="assets/busy-traffic-road.jpg" alt="busy-traffic-road" width="400">
  </li>
  <li>
    <strong>Start the Log Stream:</strong> Open your VS Code terminal and run the following command to see results as they happen.<br>
    <pre>aws logs tail /aws/lambda/&lt;your-lambda-function-name&gt; --follow</pre>
    Use the command below if on Git Bash Terminal: <br>
    <pre>MSYS_NO_PATHCONV=1 aws logs tail /aws/lambda/&lt;your-lambda-function-name&gt; --follow</pre>
  </li>
  <li>
    <strong>View Results:</strong> The detection results will appear instantly in your VS Code terminal.<br>
    AWS Console CloudWatch Log Output: <br>
    <img src="assets/aws-cloudwatch-logs-output.png" alt="busy-traffic-road" width="800"><br>
    Terminal Output: <br>
    <img src="assets/cloudwatch-logs-output-cli.png" alt="busy-traffic-road" width="800"><br>
    Sample result: <br>
    <pre>
      [
        {
          "Name": "Animal",
          "Confidence": 99.993408203125,
          "Instances": [],
          "Parents": [],
          "Aliases": [],
          "Categories": [
            {
              "Name": "Animals and Pets"
            }
          ]
        },
        {
          "Name": "Cat",
          "Confidence": 99.993408203125,
          "Instances": [
            {
              "BoundingBox": {
                "Width": 0.3602134585380554,
                "Height": 0.670926570892334,
                "Left": 0.5902238488197327,
                "Top": 0.13030071556568146
              },
              "Confidence": 89.81806945800781
            },
            {
              "BoundingBox": {
                "Width": 0.24711352586746216,
                "Height": 0.6337666511535645,
                "Left": 0.39016199111938477,
                "Top": 0.16519160568714142
              },
              "Confidence": 82.076171875
            },
            {
              "BoundingBox": {
                "Width": 0.4233805239200592,
                "Height": 0.7645028829574585,
                "Left": 0.024279789999127388,
                "Top": 0.012194041162729263
              },
              "Confidence": 80.09024047851562
            },
            {
              "BoundingBox": {
                "Width": 0.23163087666034698,
                "Height": 0.7965526580810547,
                "Left": 0.24353167414665222,
                "Top": 0.009294004179537296
              },
              "Confidence": 73.9099349975586
            }
          ],
          "Parents": [
            {
              "Name": "Animal"
            },
            {
              "Name": "Mammal"
            },
            {
              "Name": "Pet"
            }
          ],
          "Aliases": [],
          "Categories": [
            {
              "Name": "Animals and Pets"
            }
          ]
        },
        {
          "Name": "Kitten",
          "Confidence": 99.993408203125,
          "Instances": [],
          "Parents": [
            {
              "Name": "Animal"
            },
            {
              "Name": "Cat"
            },
            {
              "Name": "Mammal"
            },
            {
              "Name": "Pet"
            }
          ],
          "Aliases": [],
          "Categories": [
            {
              "Name": "Animals and Pets"
            }
          ]
        },
        {
          "Name": "Mammal",
          "Confidence": 99.993408203125,
          "Instances": [],
          "Parents": [
            {
              "Name": "Animal"
            }
          ],
          "Aliases": [],
          "Categories": [
            {
              "Name": "Animals and Pets"
            }
          ]
        },
        {
          "Name": "Pet",
          "Confidence": 99.993408203125,
          "Instances": [],
          "Parents": [
            {
              "Name": "Animal"
            }
          ],
          "Aliases": [],
          "Categories": [
            {
              "Name": "Animals and Pets"
            }
          ]
        },
        {
          "Name": "Grass",
          "Confidence": 99.5927734375,
          "Instances": [],
          "Parents": [
            {
              "Name": "Plant"
            }
          ],
          "Aliases": [],
          "Categories": [
            {
              "Name": "Plants and Flowers"
            }
          ]
        },
        {
          "Name": "Plant",
          "Confidence": 99.5927734375,
          "Instances": [],
          "Parents": [],
          "Aliases": [],
          "Categories": [
            {
              "Name": "Plants and Flowers"
            }
          ]
        }
      ]
    </pre>
  </li>
</ol>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="roadmap">Project Roadmap</h2>
<ul>
  <li>[x] <strong>Storage Setup:</strong> Create a private Amazon S3 bucket to act as the central repository for your source images.</li>
  <li>[x] <strong>Environment Config:</strong> Install and configure the AWS CLI and Python environment (boto3, Pillow) to communicate with cloud services.</li>
  <li>[x] <strong>Logic Development:</strong> Develop the Python script using the detect_labels function to send images to Amazon Rekognition.</li>
  <li>[x] <strong>Execution & Verification:</strong> Run the script to generate metadata tags and verify object detection results with bounding boxes.</li>
</ul>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="challenges-faced">Challenges</h2>
<table>
    <thead>
        <tr>
            <th>Challenge</th>
            <th>Solution</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><strong>Lambda Zip Too Large</strong></td>
            <td>
                Removed <code>Pillow/Matplotlib</code> bloat; switched to passing S3 references directly to Rekognition (reduced size from 70MB to <1KB).
            </td>
        </tr>
        <tr>
            <td><strong>Manual Workflow</strong></td>
            <td>
                Replaced manual script execution with S3 Event Notifications to trigger Lambda automatically on every upload.
            </td>
        </tr>
        <tr>
            <td><strong>CLI Path Errors</strong></td>
            <td>
                Resolved Git Bash path mangling on Windows by using MSYS_NO_PATHCONV=1 for real-time log streaming.
            </td>
        </tr>
        <tr>
            <td><strong>Timeout Issues</strong></td>
            <td>
                Optimized performance by increasing <strong>Memory (256MB)</strong> and <strong>Timeout (10s)</strong> in Terraform to handle high-res image latency.
            </td>
        </tr>
        <tr>
            <td><strong>Security Risks</strong></td>
            <td>
                Eliminated long-lived IAM Access Keys; implemented IAM Execution Roles for secure, temporary credentialing.
            </td>
        </tr>
    </tbody>
</table>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="cost-optimization">Cost Optimization (Free Tier)</h2>
<p>
  To keep the project budget-friendly, the following strategies are implemented or recommended:
</p>
<ul>
  <li><strong>S3 Lifecycle Policies:</strong> Automatically transition images to <em>S3 Standard-IA</em> or <em>Glacier</em> after 30 days of inactivity to reduce storage costs.</li>
  <li><strong>Confidence Thresholds:</strong> By setting a <code>MIN_CONFIDENCE</code> level (e.g., 70%), we filter out low-certainty results, reducing unnecessary data processing.</li>
  <li><strong>Free Tier Utilization:</strong> Amazon Rekognition and S3 both offer free tier limits for the first 12 months, which this project stays within for light usage.</li>
  <li><strong>Manual Apply in TFC:</strong> Set Terraform Cloud to "Manual Apply" to prevent accidental resource creation and associated costs.</li>
  <li><strong>Serverless Execution:</strong> By using Lambda instead of a local environment, you only pay for the milliseconds the code is actually running (1M free requests/month).</li>
  <li><strong>Log Retention:</strong> Added a CloudWatch Log Group with a 7-day retention policy to avoid long-term storage costs for test logs.</li>
</ul>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

<h2 id="acknowledgements">Acknowledgements</h2>
<p>
  Special thanks to <strong>Tech with Lucy</strong> for the architectural inspiration and excellent AWS tutorials that helped shape this pipeline.
</p>
<ul>
  <li>
    See her youtube channel here: <a href="https://www.youtube.com/@TechwithLucy" target="_blank">Tech With Lucy</a>
  </li>
  <li>
    Watch her video here: <a href="https://www.youtube.com/watch?v=0hJxcBdRlYw" target="_blank">5 Intermediate AWS Cloud Projects To Get You Hired (2025)</a>
  </li>
</ul>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>

## Technical Reference
This section is automatically updated with the latest infrastructure details.

[contributors-shield]: https://img.shields.io/github/contributors/ShenLoong99/aws-terraform-image-labels-generator.svg?style=for-the-badge
[contributors-url]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/ShenLoong99/aws-terraform-image-labels-generator.svg?style=for-the-badge
[forks-url]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/network/members

[stars-shield]: https://img.shields.io/github/stars/ShenLoong99/aws-terraform-image-labels-generator.svg?style=for-the-badge
[stars-url]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/stargazers

[issues-shield]: https://img.shields.io/github/issues/ShenLoong99/aws-terraform-image-labels-generator.svg?style=for-the-badge
[issues-url]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/issues

[license-shield]: https://img.shields.io/github/license/ShenLoong99/aws-terraform-image-labels-generator.svg?style=for-the-badge
[license-url]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/blob/master/LICENSE.txt

[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/si-kai-tan/

[ci-shield]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/actions/workflows/ci.yml/badge.svg
[ci-url]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/actions/workflows/ci.yml

[cd-shield]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/actions/workflows/cd.yml/badge.svg
[cd-url]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/actions/workflows/cd.yml

[docs-shield]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/actions/workflows/update-readme.yml/badge.svg
[docs-url]: https://github.com/ShenLoong99/aws-terraform-image-labels-generator/actions/workflows/update-readme.yml

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.6.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_access_key.project_user_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_group.developer_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.developer_team](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy_attachment.group_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.rekognition_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.rekognition_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.project_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_lambda_function.rekognition_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_s3_bucket.images_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.images_bucket_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_public_access_block.images_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning_images_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_secretsmanager_secret.dev_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.dev_keys_val](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [local_file.python_config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_id.bucket_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [terraform_data.setup_script](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy resources | `string` | `"ap-southeast-1"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name prefix | `string` | `"rekognition-image-labels"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | The AWS region where resources are deployed |
| <a name="output_developer_access_key_id"></a> [developer\_access\_key\_id](#output\_developer\_access\_key\_id) | Access key ID for the developer IAM user |
| <a name="output_lambda_execution_role_arn"></a> [lambda\_execution\_role\_arn](#output\_lambda\_execution\_role\_arn) | IAM role ARN assumed by Lambda for S3 + Rekognition access |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Rekognition Lambda function name |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | IAM role name for Lambda |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | S3 bucket name for image uploads |
<!-- END_TF_DOCS -->