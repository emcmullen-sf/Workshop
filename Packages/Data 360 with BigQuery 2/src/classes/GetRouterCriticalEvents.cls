public class GetRouterCriticalEvents {

    public virtual class CdpQueryExecutor {
        public virtual ConnectApi.CdpQueryOutput execute(ConnectApi.CdpQueryInput input) {
            // This is the real call that runs in production
            return ConnectApi.CdpQuery.queryAnsiSql(input);
        }
    }

    @TestVisible
    private static CdpQueryExecutor executor = new CdpQueryExecutor();

    public class Request {
        @InvocableVariable(label='Device ID (MAC Address)' required=true)
        public String deviceId;
    }

    public class Result {
        @InvocableVariable(label='Instability Events Collection')
        public List<InsightRow> events;
    }

    @InvocableMethod(label='Get Critical Instability Events' description='Queries Data Cloud Calculated Insight for Device History' category='Data Cloud')
    public static List<Result> getInsights(List<Request> requests) {
        List<Result> output = new List<Result>();

        for (Request req : requests) {
            Result res = new Result();
            res.events = new List<InsightRow>();
            
            String escapedId = String.escapeSingleQuotes(req.deviceId);
            String sql = 'SELECT Device_ID__c, Log_Date__c, Peak_Packet_Loss__c, Critical_Event_Count__c ' + 
                         'FROM Router_Critical_Instability_Events__cio ' + 
                         'WHERE Device_ID__c = \'' + escapedId + '\' ' +
                         'ORDER BY Log_Date__c DESC LIMIT 100';

            ConnectApi.CdpQueryInput queryInput = new ConnectApi.CdpQueryInput();
            queryInput.sql = sql;

            try {
                // --- 3. CRITICAL CHANGE: USE 'executor.execute' NOT 'ConnectApi...' ---
                ConnectApi.CdpQueryOutput response = executor.execute(queryInput);
                
                // This is Line 49+ that was missing coverage
                if (response != null && response.data != null) {
                    for (Object rowObj : response.data) {
                        Map<String, Object> rowData = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(rowObj)); 

                        InsightRow insight = new InsightRow();
                        
                        if (rowData.containsKey('Device_ID__c')) insight.deviceId = (String)rowData.get('Device_ID__c');
                        if (rowData.containsKey('Log_Date__c')) insight.logDate = (String)rowData.get('Log_Date__c');
                        
                        if (rowData.get('Peak_Packet_Loss__c') != null) {
                            insight.peakPacketLoss = Double.valueOf(rowData.get('Peak_Packet_Loss__c'));
                        }
                        
                        if (rowData.get('Critical_Event_Count__c') != null) {
                            insight.criticalEventCount = Double.valueOf(rowData.get('Critical_Event_Count__c'));
                        }
                        
                        res.events.add(insight);
                    }
                }
            } catch (Exception e) {
                System.debug('Error querying Data Cloud: ' + e.getMessage());
            }
            
            output.add(res);
        }
        return output;
    }
}