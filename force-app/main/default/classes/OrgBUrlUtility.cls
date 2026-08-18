public class OrgBUrlUtility {
    public static String getOrgBaseUrl() {
        PageReference ref = new PageReference('/home/home.jsp');
        String orgBaseUrl = ref.getUrl();
        // This will give you the relative URL, you can manipulate to get the base URL
        String[] urlParts = orgBaseUrl.split('/');
        
        return urlParts[0] + '//' + urlParts[2];
    }
}