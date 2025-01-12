resource "aws_iam_policy" "ec2_infrastructure" {
    name = "EC2_infrastructure"
    policy = file("${path.cwd}/ec2_infrastructure.json")
}

resource "aws_iam_policy" "elb_management" {
    name = "ELBManagement"
    policy = file("${path.cwd}/elb_management.json")
}

resource "aws_iam_policy" "route53_management" {
    name = "Route53Management"
    policy = file("${path.cwd}/route53_management.json")
}

resource "aws_iam_policy" "s3_management" {
    name = "S3Management"
    policy = file("${path.cwd}/s3_management.json")
}

resource "aws_iam_policy" "iam_policy" {
    name = "IAMPolicy"
    policy = file("${path.cwd}/iam_management.json")
}