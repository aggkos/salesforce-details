public with sharing class DetailsCntrl {

    @AuraEnabled
    public static List<CustomFieldDto> getFieldsDetails(String objectName, String layoutName) {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(Url.getSalesforceBaseUrl().toExternalForm() + '/services/data/v53.0/sobjects/' + objectName + '/describe/layouts/' + layoutName);
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse response = http.send(request);

        return (parseLayoutResponse(response.getBody()));
    }

    private static List<CustomFieldDto> parseLayoutResponse(String responseBody) {
        List<CustomFieldDto> fieldsList = new List<CustomFieldDto>();
        Map<String, Object> layoutInfo = (Map<String, Object>)JSON.deserializeUntyped(responseBody);

        List<Object> layouts = (List<Object>) layoutInfo.get('layouts');
        if (layouts != null && !layouts.isEmpty()) {
            Map<String, Object> layout = (Map<String, Object>)layouts[0]; // Assuming only one layout returned
            List<Object> layoutSections = (List<Object>)layout.get('layoutSections');
            for (Object section : layoutSections) {
                Map<String, Object> layoutSection = (Map<String, Object>)section;
                List<Object> layoutColumns = (List<Object>)layoutSection.get('layoutColumns');
                for (Object column : layoutColumns) {
                    Map<String, Object> layoutColumn = (Map<String, Object>)column;
                    List<Object> layoutItems = (List<Object>)layoutColumn.get('layoutItems');
                    for (Object item : layoutItems) {
                        Map<String, Object> layoutItem = (Map<String, Object>)item;
                        CustomFieldDto fieldDto = new CustomFieldDto();
                        fieldDto.Label = (String)layoutItem.get('label');
                        fieldDto.APIName = (String)layoutItem.get('fieldApiName');
                        fieldDto.Column = (Integer)layoutColumn.get('layoutComponents');
                        fieldDto.ReadOnly = (Boolean)layoutItem.get('readOnly');
                        fieldsList.add(fieldDto);
                    }
                }
            }
        }
        return fieldsList;
    }

    public class CustomFieldDto {
        @AuraEnabled
        public String Label { get; set; }
        @AuraEnabled
        public String APIName { get; set; }
        @AuraEnabled
        public Integer Column { get; set; }
        @AuraEnabled
        public Boolean ReadOnly { get; set; }
    }
}
