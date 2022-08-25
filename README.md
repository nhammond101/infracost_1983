# infracost_1983

Repo for replicating missing RDS instance in infracost breakdown generation.


## Commands
### Init

Run `make init` to install Terraform modules

### Breakdown

Run `make breakdown` to run the Infracost breakdown command

## Issue

### Problem 

The database module is factored in the costing breakdown

### Expected Outcome

The primary and replica database instances are included in the costing breakdown

```shell

module.database.module.primary.module.db_instance.aws_db_instance.this[0]                                                 
 ├─ Database instance (on-demand, Multi-AZ, db.t4g.small)                              730  hours                   $47.45 
 ├─ Storage (general purpose SSD, gp2)                                                  10  GB                       $2.30 
 └─ Additional backup storage                                               Monthly cost depends on usage: $0.095 per GB   
                                                                                                                           
 module.database.module.replica.module.db_instance.aws_db_instance.this[0]                                                 
 ├─ Database instance (on-demand, Single-AZ, db.t4g.small)                             730  hours                   $23.36 
 └─ Storage (general purpose SSD, gp2)                                                  10  GB                       $1.15
```

### Actual Outcome

Only the replica is included, and at 0 cost

```shell
 module.database.module.replica.module.db_instance.aws_db_instance.this[0]                                                 
 ├─ Database instance (on-demand, Single-AZ, db.t4g.small)                             730  hours                    $0.00 
 └─ Storage (general purpose SSD, gp2)                                                  10  GB                       $1.15
```

### Workaround

Ensure all "depended-on" modules are included in the [main.tf](./main.tf) **prior** to the module depending on them

