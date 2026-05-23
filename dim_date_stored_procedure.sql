{
    "name": "PL_Child_Staging",
    "properties": {
        "activities": [
            {
                "name": "Get Config",
                "type": "Lookup",
                "dependsOn": [],
                "policy": {
                    "timeout": "0.12:00:00",
                    "retry": 0,
                    "retryIntervalInSeconds": 30,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "source": {
                        "type": "JsonSource",
                        "storeSettings": {
                            "type": "AzureBlobFSReadSettings",
                            "recursive": true,
                            "enablePartitionDiscovery": false
                        },
                        "formatSettings": {
                            "type": "JsonReadSettings"
                        }
                    },
                    "dataset": {
                        "referenceName": "ds_config_tables_Json",
                        "type": "DatasetReference"
                    },
                    "firstRowOnly": false
                }
            },
            {
                "name": "Loop Tables",
                "type": "ForEach",
                "dependsOn": [
                    {
                        "activity": "Truncate staging table",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "userProperties": [],
                "typeProperties": {
                    "items": {
                        "value": "@activity('Get Config').output.value[0].tables",
                        "type": "Expression"
                    },
                    "batchCount": 3,
                    "activities": [
                        {
                            "name": "Cp_stg_data",
                            "type": "Copy",
                            "dependsOn": [],
                            "policy": {
                                "timeout": "0.12:00:00",
                                "retry": 0,
                                "retryIntervalInSeconds": 30,
                                "secureOutput": false,
                                "secureInput": false
                            },
                            "userProperties": [],
                            "typeProperties": {
                                "source": {
                                    "type": "DelimitedTextSource",
                                    "storeSettings": {
                                        "type": "AzureBlobFSReadSettings",
                                        "recursive": true,
                                        "enablePartitionDiscovery": false
                                    },
                                    "formatSettings": {
                                        "type": "DelimitedTextReadSettings"
                                    }
                                },
                                "sink": {
                                    "type": "AzureSqlSink",
                                    "writeBehavior": "insert",
                                    "sqlWriterUseTableLock": false
                                },
                                "enableStaging": false,
                                "translator": {
                                    "type": "TabularTranslator",
                                    "typeConversion": true,
                                    "typeConversionSettings": {
                                        "allowDataTruncation": true,
                                        "treatBooleanAsNumber": false
                                    }
                                }
                            },
                            "inputs": [
                                {
                                    "referenceName": "ds_csv_2",
                                    "type": "DatasetReference",
                                    "parameters": {
                                        "fileName": {
                                            "value": "@item().source_file",
                                            "type": "Expression"
                                        }
                                    }
                                }
                            ],
                            "outputs": [
                                {
                                    "referenceName": "ds_sql_2",
                                    "type": "DatasetReference",
                                    "parameters": {
                                        "schemaName": {
                                            "value": "@{item().schema}",
                                            "type": "Expression"
                                        },
                                        "tableName": {
                                            "value": "@{item().staging_table}",
                                            "type": "Expression"
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            },
            {
                "name": "Truncate staging table",
                "type": "SqlServerStoredProcedure",
                "dependsOn": [
                    {
                        "activity": "Get Config",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "policy": {
                    "timeout": "0.12:00:00",
                    "retry": 0,
                    "retryIntervalInSeconds": 30,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "storedProcedureName": "[ubereats_stg_schema].[sp_truncate_staging]"
                },
                "linkedServiceName": {
                    "referenceName": "Ls_AzureSqlDatabase",
                    "type": "LinkedServiceReference"
                }
            }
        ],
        "annotations": [],
        "lastPublishTime": "2026-04-27T01:34:09Z"
    },
    "type": "Microsoft.DataFactory/factories/pipelines"
}