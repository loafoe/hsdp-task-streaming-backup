# hsdp-function-streaming-backup

A Docker image that you can schedule on HSDP IronIO to perform PostgreSQL backups to an S3 bucket

# Features
- Streaming backups so not dependent on runner disk storage
- Compresses and encrypts backups

# Usage

```hcl
```

### AWS_ACCESS_KEY_ID
This should be the `api_key` of the HSDP S3 Bucket you provisioned

### AWS_SECRET_ACCESS_KEY
This should be the `secret_key` of the HSDP S3 Bucket you provisioned

### S3_BUCKET
This should be the `bucket` of the HSDP S3 Bucket you provisioned

# Bucket lifecycle policy
It is advised to set a S3 Bucket lifecycle policy. A good practice is to move your database backups to the `GLACIER` storage class after a couple of days and to set a expiration date to automatically delete older backups. The below policy moves dumps to `CLACIER` after 7 days and deletes them after 6 months (180 days)

```json
[
  {
    "Expiration": {
      "Days": 180
    },
    "ID": "Move to Glacier and expire after 6 months",
    "Prefix": "",
    "Status": "Enabled",
    "Transitions": [
      {
        "Days": 7,
        "StorageClass": "GLACIER"
      }
    ]
  }
]
```

# License

License is MIT
