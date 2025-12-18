SELECT Router_Diagnostic_Logs__dlm.device_mac__c as Device_ID__c,
       DATE_TRUNC('DAY', Router_Diagnostic_Logs__dlm.timestamp_utc__c) as Log_Date__c,
       COUNT(Router_Diagnostic_Logs__dlm.log_id__c) as Critical_Event_Count__c,
       MAX(Router_Diagnostic_Logs__dlm.packet_loss_pct__c) as Peak_Packet_Loss__c
FROM Router_Diagnostic_Logs__dlm
WHERE Router_Diagnostic_Logs__dlm.packet_loss_pct__c > 1.0
GROUP BY Router_Diagnostic_Logs__dlm.device_mac__c,
         DATE_TRUNC('DAY', Router_Diagnostic_Logs__dlm.timestamp_utc__c)