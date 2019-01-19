{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "allowAll",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchDeleteImage",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:CreateRepository",
        "ecr:DeleteRepository",
        "ecr:DeleteRepositoryPolicy",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:SetRepositoryPolicy",
        "ecr:UploadLayerPart"
      ],
      "Principal": {
          "AWS": [
          "arn:aws:iam::${aws_tools_account_id}:root"
          ]
      },
      "Effect": "Allow"
    },
    {
      "Sid": "allowPull",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:ListImages"
      ],
      "Principal": {
          "AWS": [
            "arn:aws:iam::${aws_dev_account_id}:root",
            "arn:aws:iam::${aws_qa_account_id}:root",
            "arn:aws:iam::${aws_prod_account_id}:root"
          ]
      },
      "Effect": "Allow"
    }
  ]
}
