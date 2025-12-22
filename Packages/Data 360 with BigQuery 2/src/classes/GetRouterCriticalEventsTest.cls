@IsTest
public class GetRouterCriticalEventsTest {

    // Mock Class that generates data manually to ensure lines 49-71 are hit
    public class MockCdpQueryExecutor extends GetRouterCriticalEvents.CdpQueryExecutor {
        private Boolean throwError;
        
        public MockCdpQueryExecutor(Boolean throwError) {
            this.throwError = throwError;
        }

        public override ConnectApi.CdpQueryOutput execute(ConnectApi.CdpQueryInput input) {
            if (this.throwError) {
                throw new CalloutException('Simulated Data Cloud Error');
            }

            // Create the response object directly
            ConnectApi.CdpQueryOutput output = new ConnectApi.CdpQueryOutput();
            output.data = new List<Object>();
            
            // Row 1: Fully populated
            Map<String, Object> row1 = new Map<String, Object>();
            row1.put('Device_ID__c', 'MAC-001');
            row1.put('Log_Date__c', '2023-01-01T12:00:00Z');
            row1.put('Peak_Packet_Loss__c', 10.5);
            row1.put('Critical_Event_Count__c', 5);
            output.data.add(row1);

            // Row 2: Partial data (test null checks)
            Map<String, Object> row2 = new Map<String, Object>();
            row2.put('Device_ID__c', 'MAC-001');
            row2.put('Log_Date__c', '2023-01-02T12:00:00Z');
            // Missing packet loss and event count to test null handling
            output.data.add(row2);
            
            return output;
        }
    }

    @IsTest
    static void testGetInsights_Success() {
        // 1. INJECT THE MOCK
        // This forces the main class to use our fake data instead of calling the real API
        GetRouterCriticalEvents.executor = new MockCdpQueryExecutor(false);

        GetRouterCriticalEvents.Request req = new GetRouterCriticalEvents.Request();
        req.deviceId = 'MAC-001';
        List<GetRouterCriticalEvents.Request> requests = new List<GetRouterCriticalEvents.Request>{ req };

        // 2. RUN TEST
        Test.startTest();
        List<GetRouterCriticalEvents.Result> results = GetRouterCriticalEvents.getInsights(requests);
        Test.stopTest();

        // 3. ASSERTIONS
        // If these pass, your loop (lines 49-71) definitely ran.
        System.assertEquals(1, results.size());
        GetRouterCriticalEvents.Result res = results[0];
        
        System.assertNotEquals(null, res.events, 'Events list should not be null');
        System.assertEquals(2, res.events.size(), 'Should have looped twice');

        // Verify Data Mapping
        InsightRow r1 = res.events[0];
        System.assertEquals(10.5, r1.peakPacketLoss);
        
        InsightRow r2 = res.events[1];
        System.assertEquals(null, r2.peakPacketLoss, 'Should be null for missing data');
    }

    @IsTest
    static void testGetInsights_Exception() {
        // Inject Error Mock
        GetRouterCriticalEvents.executor = new MockCdpQueryExecutor(true);

        GetRouterCriticalEvents.Request req = new GetRouterCriticalEvents.Request();
        req.deviceId = 'MAC-ERR';
        List<GetRouterCriticalEvents.Request> requests = new List<GetRouterCriticalEvents.Request>{ req };

        Test.startTest();
        List<GetRouterCriticalEvents.Result> results = GetRouterCriticalEvents.getInsights(requests);
        Test.stopTest();

        // Verify exception was caught
        System.assertEquals(1, results.size());
        System.assertEquals(0, results[0].events.size());
    }
}