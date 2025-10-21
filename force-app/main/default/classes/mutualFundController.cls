public class mutualFundController {
        //mutualFundInsertQueueable=>mutualFundInsertQueueable=>mutualFundController

    public static void mutualFundOverNightInserter()
    {
        Http h = new Http();
HttpRequest req = new HttpRequest();
req.setEndpoint('https://groww.in/v1/api/search/v1/derived/scheme?size=1900');
req.setMethod('GET');
HttpResponse res = h.send(req);

System.debug('response => ' + res.getStatusCode());
System.debug('data => ' + res.getBody());

List<mutualFund__c> mfList = new List<mutualFund__c>();

if(res.getStatusCode() == 200) {
    Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
    System.debug('map => ' + data);

    List<Object> mapdata = (List<Object>) data.get('content');
    System.debug('mapdata => ' + mapdata);

    for(Object test : mapdata) {
        Map<String, Object> data1 = (Map<String, Object>) test;
        System.debug('mapdata1 => ' + data1);
        System.debug('mapdata2 => ' + data1.get('tags'));

        mutualFund__c mf = new mutualFund__c(
            name=String.valueOf(data1.get('fund_house')),

            // -----------------------------
            // BOOLEAN FIELDS
            // -----------------------------
            sip_allowed__c = Boolean.valueOf(data1.get('sip_allowed')),
            lumpsum_allowed__c = Boolean.valueOf(data1.get('lumpsum_allowed')),
            index__c = Boolean.valueOf(data1.get('index')),
            doc_required__c = Boolean.valueOf(data1.get('doc_required')),

            // -----------------------------
            // STRING FIELDS
            // -----------------------------
            plan_type__c = String.valueOf(data1.get('plan_type')),
            fund_manager__c = String.valueOf(data1.get('fund_manager')),
            sub_category__c = String.valueOf(data1.get('sub_category')),
            logo_url__c = String.valueOf(data1.get('logo_url')),
            doc_type__c = String.valueOf(data1.get('doc_type')),
            scheme_type__c = String.valueOf(data1.get('scheme_type')),
            sub_sub_category__c = String.valueOf(data1.get('sub_sub_category')),
            scheme_code__c = Integer.valueOf(data1.get('scheme_code')),
            mutualfundId__c = String.valueOf(data1.get('id')),
            direct_scheme_name__c = String.valueOf(data1.get('direct_scheme_name')),
            fund_house__c = String.valueOf(data1.get('fund_house')),
            fund_name__c = String.valueOf(data1.get('fund_name')),
            search_id__c = String.valueOf(data1.get('search_id')),
            tags__c = String.valueOf(data1.get('tags')),
            scheme_name__c = String.valueOf(data1.get('scheme_name')),
            direct_fund__c = String.valueOf(data1.get('direct_fund')),
            amc__c = String.valueOf(data1.get('amc')),
            risk__c = String.valueOf(data1.get('risk')),
            launch_date__c = String.valueOf(data1.get('launch_date')),
            category__c = String.valueOf(data1.get('category')),
            direct_search_id__c = String.valueOf(data1.get('direct_search_id')),
            exit_load__c = String.valueOf(data1.get('exit_load')),

            // -----------------------------
            // INTEGER FIELDS
            // -----------------------------
            normalized_views__c = Integer.valueOf(data1.get('normalized_views')),
            risk_rating__c = Integer.valueOf(data1.get('risk_rating')),
            term_page_view__c = Integer.valueOf(data1.get('term_page_view')),
            return1y__c = Integer.valueOf(data1.get('return1y')),
            available_for_investment__c = Integer.valueOf(data1.get('available_for_investment')),
            return1d__c = Integer.valueOf(data1.get('return1d')),
            min_investment_amount__c = Integer.valueOf(data1.get('min_investment_amount')),
            min_sip_investment__c = Integer.valueOf(data1.get('min_sip_investment')),
            aum__c = Integer.valueOf(data1.get('aum')),
            page_view__c = Integer.valueOf(data1.get('page_view')),
            return3y__c = Integer.valueOf(data1.get('return3y')),
            groww_verdict_score__c = Integer.valueOf(data1.get('groww_verdict_score')),
            groww_rating__c = Integer.valueOf(data1.get('groww_rating')),
            expense_ratio__c = String.valueOf(data1.get('expense_ratio')),
            nav__c = Integer.valueOf(data1.get('nav')),
            sipReturn1y__c = Integer.valueOf(data1.get('sipReturn1y')),
            return6m__c = Integer.valueOf(data1.get('return6m')),
            sipReturn3m__c = Integer.valueOf(data1.get('sipReturn3m')),
            return3m__c = Integer.valueOf(data1.get('return3m')),
            sipReturn6m__c = Integer.valueOf(data1.get('sipReturn6m'))
        );

        mfList.add(mf);
    }
}

insert mfList;

    }

}