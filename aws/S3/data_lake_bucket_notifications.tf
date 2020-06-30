resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.data_lake.id

  queue {
    queue_arn = var.snowpipe_queue_arn
    events    = ["s3:ObjectCreated:*"]
  }
}
