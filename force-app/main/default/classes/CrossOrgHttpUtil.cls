public with sharing class CrossOrgHttpUtil {

    public static HttpResponse send(String namedCredentialName, String method, String relativeUrl, String body) {
        System.debug('CrossOrgHttpUtil.send => method=' + method +
                     ', url=' + relativeUrl +
                     ', body=' + body);

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint('callout:' + namedCredentialName + relativeUrl);
        req.setMethod(method);
        req.setHeader('Accept', 'application/json');

        if (body != null) {
            req.setHeader('Content-Type', 'application/json');
            req.setBody(body);
        }

        HttpResponse resp = h.send(req);
        System.debug('CrossOrgHttpUtil.send <= status=' + resp.getStatusCode() +
                     ', body=' + resp.getBody());
        return resp;
    }
 public static HttpResponse get(String namedCredentialName, String relativeUrl) {
        System.debug('CrossOrgHttpUtil.get => url=' + relativeUrl);
        return send(namedCredentialName, 'GET', relativeUrl, null);
    }

    public static HttpResponse postJson(String namedCredentialName, String relativeUrl, String body) {
        System.debug('CrossOrgHttpUtil.postJson => url=' + relativeUrl +
                     ', body=' + body);
        return send(namedCredentialName, 'POST', relativeUrl, body);
    }
}