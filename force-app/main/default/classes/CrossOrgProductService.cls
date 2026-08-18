public with sharing class CrossOrgProductService {

    private static final String NAMED_CREDENTIAL = 'SalesforceNamedCreds';

    public class CrossOrgProductException extends Exception {}

    public class ProductInput {
        public String name;
        public String productCode;
        public String description;
        public Boolean isActive;
        public Decimal unitPrice;
        public String pricebook2Id;      
        public String currencyIsoCode;   
    }

    public class ProductResult {
        public Boolean success;
        public String message;
        public String product2Id;
        public String pricebookEntryId;
    }

    public static ProductResult createProductFromJson(String payloadJson) {
        System.debug('Product payload JSON ==> ' + payloadJson);

        if (String.isBlank(payloadJson)) {
            ProductResult r = new ProductResult();
            r.success = false;
            r.message = 'Request body (JSON) is empty.';
            return r;
        }

        Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(payloadJson);

        ProductInput input = new ProductInput();
        input.name           = (String) root.get('name');
        input.productCode    = (String) root.get('productCode');
        input.description    = (String) root.get('description');
        input.isActive       = (Boolean) root.get('isActive');
        input.pricebook2Id   = (String) root.get('pricebook2Id');
        input.currencyIsoCode = (String) root.get('currencyIsoCode');
        if (root.containsKey('unitPrice') && root.get('unitPrice') != null) {
            input.unitPrice = (Decimal) root.get('unitPrice');
        }

        return createProduct(input);
    }

    public static ProductResult createProduct(ProductInput input) {
        ProductResult res = new ProductResult();

        try {
            if (input == null) {
                throw new CrossOrgProductException('Input is null.');
            }
            if (String.isBlank(input.name)) {
                throw new CrossOrgProductException('Product Name is required.');
            }
            if (String.isBlank(input.productCode)) {
                throw new CrossOrgProductException('Product Code is required (mandatory for all products).');
            }
            if (input.unitPrice == null || input.unitPrice <= 0) {
                throw new CrossOrgProductException('Unit Price must be greater than zero.');
            }
            if (String.isBlank(input.pricebook2Id)) {
                throw new CrossOrgProductException('Target Pricebook2 Id is required.');
            }
            if (String.isBlank(input.currencyIsoCode)) {
                throw new CrossOrgProductException('CurrencyIsoCode is required (e.g. "INR").');
            }

            Map<String, Object> prodMap = new Map<String, Object>();
            prodMap.put('Name', input.name);
            prodMap.put('ProductCode', input.productCode);
            prodMap.put('IsActive', (input.isActive == null) ? true : input.isActive);
            prodMap.put('CurrencyIsoCode', input.currencyIsoCode);

            if (!String.isBlank(input.description)) {
                prodMap.put('Description', input.description);
            }

            String prodBody = JSON.serialize(prodMap);
            System.debug('Product2 request body ==> ' + prodBody);

            // HttpResponse prodResp = calloutToTargetOrg(
            //     'POST',
            //     '/services/data/v65.0/sobjects/Product2',
            //     prodBody
            // );

            HttpResponse prodResp = CrossOrgHttpUtil.postJson(NAMED_CREDENTIAL, '/services/data/v65.0/sobjects/Product2', prodBody);

            System.debug('Product2 status: ' + prodResp.getStatusCode() + ' - ' + prodResp.getBody());

            if (prodResp.getStatusCode() < 200 || prodResp.getStatusCode() >= 300) {
                res.success = false;
                res.message = 'Failed to create Product2 in target org. Status: ' +
                              prodResp.getStatusCode() + ' - ' + prodResp.getBody();
                return res;
            }

            Map<String, Object> prodRespMap = (Map<String, Object>) JSON.deserializeUntyped(prodResp.getBody());

            Boolean prodOk = (Boolean) prodRespMap.get('success');
            String product2Id = (String) prodRespMap.get('id');

            if (!prodOk) {
                List<Object> errors = (List<Object>) prodRespMap.get('errors');
                List<String> msgs = new List<String>();
                for (Object eObj : errors) {
                    Map<String, Object> eMap = (Map<String, Object>) eObj;
                    String msg = (String) eMap.get('message');
                    if (msg != null) msgs.add(msg);
                }
                res.success = false;
                res.message = 'Target org Product2 errors: ' + String.join(msgs, ' | ');
                return res;
            }

            Map<String, Object> pbeMap = new Map<String, Object>();
            pbeMap.put('Product2Id', product2Id);
            pbeMap.put('Pricebook2Id', input.pricebook2Id);
            pbeMap.put('UnitPrice', input.unitPrice);
            pbeMap.put('IsActive', true);
            pbeMap.put('UseStandardPrice', false);
            pbeMap.put('CurrencyIsoCode', input.currencyIsoCode);

            String pbeBody = JSON.serialize(pbeMap);
            System.debug('PricebookEntry request body ==> ' + pbeBody);

            // HttpResponse pbeResp = calloutToTargetOrg(
            //     'POST',
            //     '/services/data/v65.0/sobjects/PricebookEntry',
            //     pbeBody
            // );

            HttpResponse pbeResp = CrossOrgHttpUtil.postJson(NAMED_CREDENTIAL, '/services/data/v65.0/sobjects/PricebookEntry', pbeBody);

            System.debug('PricebookEntry status: ' + pbeResp.getStatusCode() + ' - ' + pbeResp.getBody());

            if (pbeResp.getStatusCode() < 200 || pbeResp.getStatusCode() >= 300) {
                res.success = false;
                res.message = 'Product2 created (Id = ' + product2Id + '), but failed to create PricebookEntry. Status: ' +
                              pbeResp.getStatusCode() + ' - ' + pbeResp.getBody();
                res.product2Id = product2Id;
                return res;
            }

            Map<String, Object> pbeRespMap = (Map<String, Object>) JSON.deserializeUntyped(pbeResp.getBody());

            Boolean pbeOk = (Boolean) pbeRespMap.get('success');
            String pricebookEntryId = (String) pbeRespMap.get('id');

            if (!pbeOk) {
                List<Object> errors = (List<Object>) pbeRespMap.get('errors');
                List<String> msgs = new List<String>();
                for (Object eObj : errors) {
                    Map<String, Object> eMap = (Map<String, Object>) eObj;
                    String msg = (String) eMap.get('message');
                    if (msg != null) msgs.add(msg);
                }
                res.success = false;
                res.message = 'Product2 created (Id = ' + product2Id + '), but PricebookEntry errors: ' +
                              String.join(msgs, ' | ');
                res.product2Id = product2Id;
                return res;
            }

            res.success = true;
            res.product2Id = product2Id;
            res.pricebookEntryId = pricebookEntryId;
            res.message = 'Product2 and PricebookEntry created in target org. Product2Id = ' +
                          product2Id + ', PricebookEntryId = ' + pricebookEntryId;

            return res;

        } catch (Exception ex) {
            res.success = false;
            res.message = 'Exception: ' + ex.getMessage();
            return res;
        }
    }
}