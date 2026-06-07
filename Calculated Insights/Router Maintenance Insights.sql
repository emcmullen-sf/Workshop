SELECT
  Router_Diagnostic_Logs__dlm.device_mac__c AS device_mac__c,
  COUNT(Router_Diagnostic_Logs__dlm.packet_loss_pct__c) AS high_packet_loss_log_count__c
FROM
  Router_Diagnostic_Logs__dlm
WHERE
  Router_Diagnostic_Logs__dlm.packet_loss_pct__c > 5.0
GROUP BY
  Router_Diagnostic_Logs__dlm.device_mac__c