<a id="readme-top"></a>

<div>
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
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#challenges-faced">Roadmap</a></li>
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

<h2 id="getting-started">Getting Started</h2>
<h3>Prerequisites</h3>
<ul>
    <li>An active <strong>AWS Account</strong>.</li>
    <li><strong>Terraform CLI / Terraform Cloud(optional)</strong> for IaC deployment.</li>
    <li><strong>Python 3.x</strong> installed locally for running the detection script.</li>
</ul>

<h3>Installation & Deployment</h3>
<ol>
    <li>
        <strong>Clone the Repository:</strong>
    </li>
    <li>
        <strong>Provision Infrastructure:</strong>
        Push your changes to the <code>main</code> branch to trigger a Terraform Cloud plan. Once approved, Terraform will provision your S3 bucket and IAM resources.
    </li>
    <li>
        <strong>Configure Local Environment:</strong>
        Create a <code>.env</code> file or export your AWS credentials and the S3 bucket name (found in the Terraform output) to your environment variables.
    </li>
    <li>
        <strong>Install Python Dependencies:</strong>
        <code>pip install -r requirements.txt</code>
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
    <pre>aws logs tail /aws/lambda/ &lt;your-s3-bucket-name&gt; --follow</pre>
    Use the command below if on Git Bash Terminal: <br>
    <pre>MSYS_NO_PATHCONV=1 aws logs tail /aws/lambda/ &lt;your-s3-bucket-name&gt; --follow</pre>
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

<h2 id="contact">Contact</h2>
<p>Tan Si Kai - <a href="https://linkedin.com/in/si-kai-tan">LinkedIn</a></p>
<p>Project Link: <a href="https://github.com/ShenLoong99/my-terraform-aws-projects-2025/tree/main/AWS-Image-Labels-Generator">Image Labels Generator</a></p>
<div align="right"><a href="#readme-top">↑ Back to Top</a></div>