public class InsightRow {
    @InvocableVariable @AuraEnabled
    public String deviceId;
    
    @InvocableVariable @AuraEnabled
    public String logDate; // Keeping as String is safest, can be parsed to DateTime if needed
    
    @InvocableVariable @AuraEnabled
    public Double peakPacketLoss;
    
    @InvocableVariable @AuraEnabled
    public Double criticalEventCount;
}