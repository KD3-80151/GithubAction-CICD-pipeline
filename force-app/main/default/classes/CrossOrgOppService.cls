public with sharing class CrossOrgOppService {

    private static final String NAMED_CREDENTIAL = 'SalesforceNamedCreds';

    public class CrossOrgOppException extends Exception {}

    
    public class ProductLineInput {
        public String productCode;  
        public Decimal quantity;    
        public Decimal unitPrice;  
    }

    public class errorResultWrapper {
        public Boolean success;
        public String message;
        public String targetOpportunityId;
    }

    public static errorResultWrapper createOppWithLinesFromJson(String payloadJson) {
        system.debug('createOppWithLinesFromJson get calleld:::::::>>');
        system.debug('payLoadjson::>>' +payloadJson);

        if (String.isBlank(payloadJson)) {
            errorResultWrapper error1 = new errorResultWrapper();
            error1.success = false;
            error1.message = 'empty json body';
            return error1;
        }

        //!parse json into map ----------------------------
        Map<String, Object> oppFields    = (Map<String, Object>) JSON.deserializeUntyped(payloadJson);
        String oppName              = (String) oppFields.get('oppName');
        String stageName            = (String) oppFields.get('stageName');
        String closeDateStr         = (String) oppFields.get('closeDate');
        system.debug('closeDateStr::>>' + closeDateStr);
        String accountIdInTarget    = (String) oppFields.get('accountIdInTarget');
        String pricebook2IdInTarget = (String) oppFields.get('pricebook2IdInTarget');

        Date closeDate;
        if (!String.isBlank(closeDateStr)) {
            closeDate = Date.valueOf(closeDateStr);
            
        }
        system.debug('closeDate::>>' + closeDate);

        //!parse productline array  // read productlines from json array  
        List<Object> prodDlines = (List<Object>) oppFields.get('productLines');
        system.debug('prodDlines::>>' + prodDlines);
        List<ProductLineInput> productLines = new List<ProductLineInput>();

        if (prodDlines != null) {
            for (Object objTOUpdaate : prodDlines) {
                Map<String, Object> lineMap = (Map<String, Object>) objTOUpdaate; //!-- for each item cast to map string
                System.debug('lienMapo:::::>>' + lineMap);
                ProductLineInput pli = new ProductLineInput();
                pli.productCode = (String) lineMap.get('productCode');
                pli.quantity    = (lineMap.containsKey('quantity') && lineMap.get('quantity') != null) ? (Decimal) lineMap.get('quantity') : null;
                pli.unitPrice   = (lineMap.containsKey('unitPrice') && lineMap.get('unitPrice') != null) ? (Decimal) lineMap.get('unitPrice') : null;
                productLines.add(pli);
            }
        }
        return createOppWithLines(oppName, stageName, closeDate, accountIdInTarget, pricebook2IdInTarget, productLines);
    }

    public static errorResultWrapper createOppWithLines(String oppName, String stageName, Date closeDate, String accountIdInTarget, String pricebook2IdInTarget, List<ProductLineInput> productLines) {
        System.debug('createOppWithLines get callled::::::::');
        System.debug('oppName: ' + oppName);
        System.debug('stageName: ' + stageName);
        System.debug('closeDate: ' + closeDate);
        System.debug('accountIdInTarget: ' + accountIdInTarget);
        System.debug('pricebook2IdInTarget: ' + pricebook2IdInTarget);
        System.debug('productLines: ' + productLines);

        //!---------------now need to prepare response objects::::----------
        errorResultWrapper res = new errorResultWrapper();

        try {
            validateRequest(oppName, stageName, closeDate, accountIdInTarget, pricebook2IdInTarget, productLines);

            Map<String, PricebookEntryInfo> pbeByCode = fetchPricebookEntriesByProductCode(productLines, pricebook2IdInTarget);
            System.debug('pbeByCOde:::::>>>' + pbeByCode);
            List<String> missingCodes = new List<String>(); //to check for missing product codes 
            for (ProductLineInput pli : productLines) {
                if (!pbeByCode.containsKey(pli.productCode.trim())) {
                    missingCodes.add(pli.productCode);
                }
            }
            if (!missingCodes.isEmpty()) {
                res.success = false;
                res.message = 'These Product Codes do not exist in the selected Pricebook in target org: '
                              + String.join(missingCodes, ', ');
                return res;
            }

            String requestBody = compPayLOadCreated(oppName, stageName, closeDate, accountIdInTarget, pricebook2IdInTarget, productLines, pbeByCode);
            
            // HttpResponse postResp = calloutToTargetOrg(
            //     'POST',
            //     '/services/data/v65.0/composite/tree/Opportunity',
            //     requestBody
            // );

            HttpResponse postResp = CrossOrgHttpUtil.postJson(NAMED_CREDENTIAL, '/services/data/v65.0/composite/tree/Opportunity', requestBody);

            if (postResp.getStatusCode() >= 200 && postResp.getStatusCode() < 300) {
                Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(postResp.getBody());

                Boolean hasErrors = (Boolean) body.get('hasErrors');

                if (hasErrors == true) {
                    List<Object> resultList = (List<Object>) body.get('results');
                    List<String> errorMessages = new List<String>();

                    for (Object requestObject : resultList) {
                        Map<String, Object> requestedMapping = (Map<String, Object>) requestObject;
                        List<Object> errsObject = (List<Object>) requestedMapping.get('errors');
                        if (errsObject != null && !errsObject.isEmpty()) {
                            for (Object toShowErrors : errsObject) {
                                Map<String, Object> errorMap = (Map<String, Object>) toShowErrors;
                                String msg = (String) errorMap.get('message');
                                if (msg != null) errorMessages.add(msg);
                            }
                        }
                    }

                    res.success = false;
                    res.message = 'Target org returned errors: ' + String.join(errorMessages, ' | ');
                } else {
                    String oppId = null;
                    List<Object> resultList = (List<Object>) body.get('results');
                    for (Object requestObject : resultList) {
                        Map<String, Object> requestedMapping = (Map<String, Object>) requestObject;
                        String refId = (String) requestedMapping.get('referenceId');
                        if (refId == 'refOpp1') {
                            oppId = (String) requestedMapping.get('id');
                            break;
                        }
                    }

                    res.success = true;
                    res.targetOpportunityId = oppId;
                    res.message = 'Opportunity and line items created successfully in target org. Opp Id: ' + oppId;
                }
            } else {
                res.success = false;
                res.message = 'HTTP POST failed: Status ' + postResp.getStatusCode() +
                              ' - ' + postResp.getStatus() + ' - Body: ' + postResp.getBody();
            }
        } catch (Exception ex) {
            res.success = false;
            res.message = 'Exception: ' + ex.getMessage();
        }

        return res;
    }

    private static void validateRequest(String oppName, String stageName, Date closeDate, String accountIdInTarget, String pricebook2IdInTarget, List<ProductLineInput> productLines) {
        system.debug('validateRequestss gets calledddddddddddddddd:::--- ');
        system.debug('productLines::>>' + productLines);
        if (String.isBlank(oppName)) {
            throw new CrossOrgOppException('Opportunity Name is required.');
        }
        if (String.isBlank(stageName)) {
            throw new CrossOrgOppException('StageName is required.');
        }
        if (closeDate == null) {
            throw new CrossOrgOppException('CloseDate is required.');
        }
        if (String.isBlank(accountIdInTarget)) {
            throw new CrossOrgOppException('Target Account Id is required.');
        }
        if (String.isBlank(pricebook2IdInTarget)) {
            throw new CrossOrgOppException('Target Pricebook2 Id is required.');
        }
        if (productLines == null || productLines.isEmpty()) {
            throw new CrossOrgOppException('At least one product line is required.');
        }

        for (ProductLineInput pli : productLines) {
            System.debug('pli::>>' + pli);
            if (pli == null || String.isBlank(pli.productCode)) {
                throw new CrossOrgOppException('Product Code is mandatory for all product lines.');
            }
            if (pli.quantity == null || pli.quantity <= 0) {
                throw new CrossOrgOppException('Quantity must be greater than zero for product code: ' + pli.productCode);
            }
        }
    }

    private class PricebookEntryInfo {
        String id;
        String productCode;
        Decimal unitPrice;
    }

    //!::::::::::to fetch Pricebook entry records by product code:::::::::::::::::
    private static Map<String, PricebookEntryInfo> fetchPricebookEntriesByProductCode(list<ProductLineInput> productLines, String pricebook2Id) {
        System.debug('fetchPricebookEntriesByProductCode called::::::::::::::::::');
        system.debug('productLines::>>' + productLines);
        system.debug('pricevbpook12Ids::::' + pricebook2Id);

        Set<String> codeSet = new Set<String>(); 
        for (ProductLineInput pli : productLines) {
            if (!String.isBlank(pli.productCode)) {
                codeSet.add(pli.productCode.trim());
            }
        }

        if (codeSet.isEmpty()) {
            throw new CrossOrgOppException('No Product Codes found to validate.');
        }

        List<String> codeList = new List<String>();
        for (String codeSetToReplace : codeSet) {
            String escaped = codeSetToReplace.replace('\'', '\\\'');
            codeList.add('\'' + escaped + '\'');
        }
        String inClause = String.join(codeList, ','); //!-------------converting to string
        system.debug('codeList:::>>>>>>' + codeList);
        system.debug('inClause:::>>>>>>' + inClause);
        
        String escapedPbId = pricebook2Id.replace('\'', '\\\'');
        System.debug('eescapedPbId::>>' + escapedPbId);
        String soql =
            'SELECT Id, Product2.ProductCode, Pricebook2Id, UnitPrice ' +
            'FROM PricebookEntry ' +
            'WHERE IsActive = true ' +
            'AND Pricebook2Id = \'' + escapedPbId + '\' ' +
            'AND Product2.ProductCode IN (' + inClause + ')';

        String encodedSoql = EncodingUtil.urlEncode(soql, 'UTF-8');
        system.debug('soql:::>>>>>>' + soql);
        system.debug('encodedSoql:::>>>>>>' + encodedSoql);
        String url = '/services/data/v65.0/query/?q=' + encodedSoql;
        system.debug('url:::>>>>>>' + url);
        system.debug('NAMED_CREDENTIAL:::>>>>>>' + NAMED_CREDENTIAL);        //HttpResponse resp = calloutToTargetOrg('GET', url, null);
        HttpResponse resp = CrossOrgHttpUtil.get(NAMED_CREDENTIAL, url);
        system.debug('resp:::>>>>>>' + resp);

        if (resp.getStatusCode() < 200 || resp.getStatusCode() >= 300) {
            throw new CrossOrgOppException(
                'Failed to fetch PricebookEntries from target org. Status: ' +
                resp.getStatusCode() + ' - ' + resp.getStatus() + ' - Body: ' + resp.getBody()
            );
        }

        Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
        List<Object> records = (List<Object>) body.get('records');
        system.debug('records:::>>>>>>>>>>>' + records);

        Map<String, PricebookEntryInfo> result = new Map<String, PricebookEntryInfo>();

        //!if prcebook is there parse json and create pricebookentryinfo and fill id, unit price and product code
        for (Object oppRecords : records) {
            Map<String, Object> rec = (Map<String, Object>) oppRecords;

            PricebookEntryInfo info = new PricebookEntryInfo();
            info.id = (String) rec.get('Id');
            system.debug('info.id:::>>>>>>' + info.id);
            info.unitPrice = (Decimal) rec.get('UnitPrice');

            system.debug('info.unitPrice:::>>>>>>' + info.unitPrice);
            Map<String, Object> prod = (Map<String, Object>) rec.get('Product2');
            if (prod != null) {
                info.productCode = (String) prod.get('ProductCode');
            }

            if (!String.isBlank(info.productCode)) {
                result.put(info.productCode.trim(), info);
            }
        }

        return result;
    }

    //!to build json compatible with: /services/data/v65.0/composite/tree/Opportunity
    private static String compPayLOadCreated(String oppName, String stageName, Date closeDate, String accountIdInTarget, String pricebook2IdInTarget, List<ProductLineInput> productLines, Map<String, PricebookEntryInfo> pbeByCode) {
        system.debug('compPayLOadCreated callledddddddddddddddddd');
        List<Object> oliRecords = new List<Object>();
        Integer index = 1;

        for (ProductLineInput pli : productLines) {
            String trimmedCode = pli.productCode.trim();
            System.debug('trimmedCOde::::' + trimmedCode);
            PricebookEntryInfo pbeInfo = pbeByCode.get(trimmedCode);

            //for opportunity line items
            system.debug('pbeInfo::>>' + pbeInfo);
            system.debug('pli::>>' + pli);
            Map<String, Object> oli = new Map<String, Object>();
            oli.put('attributes', new Map<String, Object>{
                'type' => 'OpportunityLineItem',
                'referenceId' => 'refOLI' + String.valueOf(index)
            });
            oli.put('PricebookEntryId', pbeInfo.id);
            oli.put('Quantity', pli.quantity);

            Decimal finalUnitPrice = (pli.unitPrice != null) ? pli.unitPrice : pbeInfo.unitPrice;
            system.debug('finalUnitPrice::>>' + finalUnitPrice);
            oli.put('UnitPrice', finalUnitPrice);

            oliRecords.add(oli);
            index++;
        }

        Map<String, Object> opp = new Map<String, Object>();
        opp.put('attributes', new Map<String, Object>{
            'type' => 'Opportunity',
            'referenceId' => 'refOpp1'
        });
        opp.put('Name', oppName);
        opp.put('StageName', stageName);
        opp.put('CloseDate', closeDate);
        opp.put('AccountId', accountIdInTarget);
        opp.put('Pricebook2Id', pricebook2IdInTarget);

        opp.put('OpportunityLineItems', new Map<String, Object>{
            'records' => oliRecords
        });

        system.debug('opp::>>' + opp);

        Map<String, Object> oppFields1 = new Map<String, Object>();
        oppFields1.put('records', new List<Object>{ opp });
        System.debug('oppFields1::>>' + oppFields1);
        return JSON.serialize(oppFields1);
    }

}