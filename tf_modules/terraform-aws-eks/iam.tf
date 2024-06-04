# --------------------------------------------------------------------
# IAM Policies and Roles for EKS (masters & workers)
# --------------------------------------------------------------------

data "aws_iam_policy_document" "k8s_masters_role_policy_document" {
  statement {
    sid    = "EKSMasterAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

## Role and policies needed by the K8S masters to make AWS API calls
resource "aws_iam_role" "k8s_masters_role" {
  count              = var.create_master_role ? 1 : 0
  name               = "K8sMastersRole"
  assume_role_policy = data.aws_iam_policy_document.k8s_masters_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  count      = var.create_master_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8s_masters_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  count      = var.create_master_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.k8s_masters_role[0].name
}

data "aws_iam_policy_document" "k8s_workers_role_role_policy_document" {
  statement {
    sid    = "EKSWorkerAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

## Role and policies needed by the K8S workers/nodes
resource "aws_iam_role" "k8s_workers_role" {
  count              = var.create_workers_role ? 1 : 0
  name               = "K8sWorkersRole"
  assume_role_policy = data.aws_iam_policy_document.k8s_workers_role_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count      = var.create_workers_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.k8s_workers_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  count      = var.create_workers_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.k8s_workers_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  count      = var.create_workers_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8s_workers_role[0].name
}

resource "aws_iam_instance_profile" "iam_workers_profile" {
  count = var.create_workers_role ? 1 : 0
  name  = "K8sWorkersProfile"
  role  = aws_iam_role.k8s_workers_role[0].name
}

data "aws_iam_policy_document" "autoscaling_policy_document" {
  statement {
    sid    = "AutoScalingRightsForK8s"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]

    resources = [
      "*",
    ]
  }
}

## EKS Workers: Policy to allow the K8S cluster auto-scaler feature to adjust the size of an ASG
resource "aws_iam_policy" "autoscaling_policy" {
  count       = var.create_autoscaling_policy ? 1 : 0
  name        = "K8AutoscalerPolicy"
  description = "Allows K8S cluster auto-scaler to adjust the ASG size"
  policy      = data.aws_iam_policy_document.autoscaling_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_autoscaling_policy" {
  count      = var.create_autoscaling_policy && var.create_workers_role ? 1 : 0
  policy_arn = aws_iam_policy.autoscaling_policy[0].arn
  role       = aws_iam_role.k8s_workers_role[0].name
}

data "aws_iam_policy_document" "route53_recordsets_policy_document" {
  statement {
    sid    = "ExternalDNSChangeResourceRecordSets"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }

  statement {
    sid    = "ExternalDNSListRoute53Resources"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = [
      "*",
    ]
  }
}

## EKS Workers: Policy to allow external-dns Chart to update recordsets in a given Hosted Zone
resource "aws_iam_policy" "route53_recordsets_policy" {
  count       = var.create_route53_policy && var.create_workers_role ? 1 : 0
  name        = "UpdateRoute53Recordsets"
  description = "Allow external-dns chart to update recordsets in Route53 hosted zones"
  policy      = data.aws_iam_policy_document.route53_recordsets_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_route53_policy" {
  count      = var.create_route53_policy && var.create_workers_role ? 1 : 0
  policy_arn = aws_iam_policy.route53_recordsets_policy[0].arn
  role       = aws_iam_role.k8s_workers_role[0].name
}

data "aws_iam_policy_document" "k8s_ng_role_policy_document" {
  statement {
    sid    = "EKSNodeGroupTrustPolicy"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ng" {
  count              = var.create_ng_role ? 1 : 0
  name               = "EksNodeGroupRole"
  assume_role_policy = data.aws_iam_policy_document.k8s_ng_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ng-AmazonEKSWorkerNodePolicy" {
  count      = var.create_ng_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ng[0].name
}

resource "aws_iam_role_policy_attachment" "ng-AmazonEKS_CNI_Policy" {
  count      = var.create_ng_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ng[0].name
}

resource "aws_iam_role_policy_attachment" "ng-AmazonEC2ContainerRegistryReadOnly" {
  count      = var.create_ng_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ng[0].name
}

resource "aws_iam_role_policy_attachment" "ng-attach_autoscaling_policy" {
  count      = var.create_autoscaling_policy && var.create_ng_role ? 1 : 0
  policy_arn = aws_iam_policy.autoscaling_policy[0].arn
  role       = aws_iam_role.ng[0].name
}

resource "aws_iam_role_policy_attachment" "ng-attach_route53_policy" {
  count      = var.create_route53_policy && var.create_ng_role ? 1 : 0
  policy_arn = aws_iam_policy.route53_recordsets_policy[0].arn
  role       = aws_iam_role.ng[0].name
}
