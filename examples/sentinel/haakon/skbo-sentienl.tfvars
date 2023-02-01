AR_FILE_PATH = [
    rohit  = { 
        defination = ./ref/AuditLogs/UserAddedtoAdminRole.yaml
        frequency = 1h
        enabled = false
        paramerer = {
            subscription = [p-subscription]
        }
    }
    haakon = { defination = ./ref/AuditLogs/UserAddedtoAdminRole.yaml}
    aidan  = { 
        query        = <<QUERY
            AzureActivity |
            where OperationName == "Create or Update Virtual Machine" or OperationName =="Create Deployment" |
            where ActivityStatus == "Succeeded" |
            make-series dcount(ResourceId) default=0 on EventSubmissionTimestamp in range(ago(7d), now(), 1d) by Caller
            QUERY
    }

    Damian = { 
        defination = ./cust/AuditLogs/UserRemovedFromAdminRole.yaml
    }
]



severiti
querytactics
frequency
period
opperator
threshold
