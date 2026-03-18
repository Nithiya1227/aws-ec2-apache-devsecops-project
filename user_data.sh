#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# Fetch metadata using IMDSv2
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
-s http://169.254.169.254/latest/meta-data/public-ipv4)

REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
-s http://169.254.169.254/latest/meta-data/placement/region)

DATE=$(date)

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Nithya DevSecOps Project</title>
    <style>
        body {
            font-family: Arial;
            background-color: #0f172a;
            color: white;
            text-align: center;
            padding-top: 100px;
        }
        .box {
            border: 2px solid #38bdf8;
            padding: 30px;
            margin: auto;
            width: 60%;
            border-radius: 10px;
            background-color: #1e293b;
        }
        h1 {
            color: #38bdf8;
        }
    </style>
</head>
<body>
    <div class="box">
        <h1>Automated Apache Deployment on AWS EC2</h1>
        <h2>Deployed by Nithya</h2>
        <p>Hosted on AWS EC2 using Apache HTTP Server with automated provisioning</p>

        <p><b>Instance Type:</b> t3.micro</p>
        <p><b>Region:</b> $REGION</p>
        <p><b>Public IP:</b> $IP</p>
        <p><b>Deployed At:</b> $DATE</p>

        <hr>

        <p><b>✔ Security:</b> SSH restricted to My IP (Principle of Least Privilege)</p>
        <p><b>✔ Automation:</b> Configured using user_data script</p>
        <p><b>✔ Web Server:</b> Apache installed automatically</p>

        <hr>

        <p><b>Project Source:</b> https://github.com/Nithiya1227/aws-ec2-apache-devsecops-project</p>

        <p>Project successfully deployed</p>
    </div>
</body>
</html>
EOF
