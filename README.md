# terraform-aws-aurora-serverless

This module is used to create serverless aws aurora cluster with aurora-mysql and aurora-postgresql as database engine. 
It is used to create aws glue catalog database and aws crawler runs in rds database to populate the glue catalog database.
RDS database and glue catalog database is connected using jdbc.
This module also creates a vpc with 3 private subnets and a public subnet.