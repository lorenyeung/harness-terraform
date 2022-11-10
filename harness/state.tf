resource "aws_kms_key" "terraform-bucket-key" {
 description             = "This key is used to encrypt bucket objects"
 deletion_window_in_days = 10
 enable_key_rotation     = true
}

terraform {
 backend "s3" {
   //bucket         = local.BUCKET_NAME
   //key            = "state/terraform.tfstate<+pipeline.identifier><+pipeline.sequenceId>" //this needs to be dynamic and unique
   region         = "us-west-1"
   encrypt        = true
   kms_key_id     = "alias/aws/s3"
   //dynamodb_table = "terraform-state"
 }
}

