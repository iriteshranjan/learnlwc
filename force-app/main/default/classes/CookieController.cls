public with sharing class CookieController {
    @AuraEnabled
    public static Id createCookieRecord(String cookieData) {
        if (String.isBlank(cookieData)) {
            throw new AuraHandledException('No cookie data provided');
        }

        // Parse the incoming JSON so we can use IP as Name
        String ip = 'UNKNOWN';
        try {
            Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(cookieData);
            if (parsed.containsKey('ipInfo')) {
                Map<String, Object> ipInfo = (Map<String, Object>) parsed.get('ipInfo');
                if (ipInfo.containsKey('ip')) {
                    ip = String.valueOf(ipInfo.get('ip'));
                }
            }
        } catch (Exception e) {
            System.debug('⚠️ Could not parse IP from payload: ' + e.getMessage());
        }

        // Store record
        Cookie__c c = new Cookie__c();
        c.Name = ip;
        c.Cookiee__c = cookieData;
        insert c;

        return c.Id;
    }
}