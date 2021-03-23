# hsdp-function-streaming-backup

A Docker image that you can schedule on HSDP IronIO to perform PostgreSQL backups to an S3 bucket

# Features
- Streaming backups so not dependent on runner disk storage
- Compresses backups

# Usage

```hcl
module "siderite_backend" {
  source = "philips-labs/siderite-backend/cloudfoundry"

  cf_region   = "eu-west"
  cf_org_name = "hsdp-demo-org"
  cf_user     = var.cf_user
  iron_plan   = "medium-encrypted-4GB"
}

resource "hsdp_function" "psql_backup" {
  name         = "psql_backup"
  docker_image = "philipslabs/hsdp-function-streaming-backup:v0.1.0"
  command      = ["/app/backup.sh"]

  environment = {
    DB_HOST               = "postgres-xxx.eu-west-1.rds.amazonaws.com"
    DB_PORT               = "5432"
    DB_USER               = "[REDACTED]"
    DB_PASSWORD           = "[REDACTED]"
    DB_NAME               = "mydb"

    BACKUP_NAME           = "backups/mydb"
    S3_ENDPOINT           = "s3-eu-west-1.amazonaws.com"
    S3_BUCKET             = "cf-s3-xxx"
    AWS_ACCESS_KEY_ID     = "[REDACTED]"
    AWS_SECRET_ACCESS_KEY = "[REDACTED]"
  }

  schedule {
    run_every = "7d"
  }

  backend {
    type        = "siderite"
    credentials = module.siderite_backend.credentials
  }
}
```

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
