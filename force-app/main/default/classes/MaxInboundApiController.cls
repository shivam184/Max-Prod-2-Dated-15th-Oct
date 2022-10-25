@RestResource(urlMapping='/maxapi/entity/*')
global class MaxInboundApiController {
    @HttpPOST
    global static void doCreateRecords(){
        Savepoint sp = Database.setSavepoint();
        try {
            RestRequest request = RestContext.request;
            String entityName = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            if(String.isNotBlank(request.requestBody.toString())) {
                
                system.debug('request.requestBody.toString()--->'+request.requestBody.toString());
                
                system.debug('entityName--->'+entityName);
                
                
                Map<String,Object> mapKeyToValue = (Map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
                List<Object> listObject = (List<Object>)mapKeyToValue.get('Data');
                
                if(listObject !=  NULL && listObject.size() > 0) {
                    if(String.isNotBlank(entityName)) {
                        if(entityName == Label.BillingSummary) {
                            List<Billing_Summary__c> listBillingSummary = new List<Billing_Summary__c>();
                            Map<Billing_Summary__c,List<Billing_Itemwise__c>> mapSummaryToListItem = new Map<Billing_Summary__c,List<Billing_Itemwise__c>>();
                            Set<String> setIPID = new Set<String>();   // Added on 01 May 2019
                            Set<String> setTransactionType = new Set<String>();
                            Set<String> setBillNo = new Set<String>();
                            // Added on 01 May 2019
                            
                            //-----------------------------Added on 21 May 2019-----------------------------------------------------------------------------
                            
                            Map<String,Id> mapAlltecCityToId = new Map<String,Id>();
                            Map<String,Id> mapAlltecCountryToId = new Map<String,Id>(); 
                            Map<String,Id> mapAlletecLocalityToId = new Map<String,Id>();
                            Map<String,Id> mapAlletecStateToId = new Map<String,Id>();
                            
                            for(Address_Master__c am : [SELECT Id, Recordtype.Name, alletec_cityid__c, alletec_countryid__c, alletec_localityid__c, alletec_state__c FROM Address_Master__c WHERE Recordtype.Name IN ('City','Country','Locality','State') AND Deleted__c = '0']){
                                if(am.RecordType.Name.equalsIgnoreCase('City'))
                                    mapAlltecCityToId.put(am.alletec_cityid__c,am.Id);  
                                if(am.RecordType.Name.equalsIgnoreCase('Country'))
                                    mapAlltecCountryToId.put(am.alletec_countryid__c,am.Id);     
                                if(am.RecordType.Name.equalsIgnoreCase('Locality'))
                                    mapAlletecLocalityToId.put(am.alletec_localityid__c,am.Id);
                                if(am.RecordType.Name.equalsIgnoreCase('State'))
                                    mapAlletecStateToId.put(am.alletec_state__c,am.Id); 
                            }
                                                        
                            
                            Map<String,Id> mapHisIdToBusinessUnitId = new Map<String,Id>();
                            for(Business_Unit__c bu : [SELECT Id,HIS_ID__c FROM Business_Unit__c])  
                                mapHisIdToBusinessUnitId.put(bu.HIS_ID__c,bu.Id);
                            Map<String,Id> mapHisIdToSpecializationId = new Map<String,Id>();
                            for(Speciality__c spc : [SELECT Id,HIS_ID__c FROM Speciality__c])
                                mapHisIdToSpecializationId.put(spc.HIS_ID__c,spc.Id);   
                            
                            Map<String,Id> mapAlletecIdToDepartmentId = new Map<String,Id>();
                            for(Department__c dep : [SELECT Id,alletec_id__c FROM Department__c])
                                mapAlletecIdToDepartmentId.put(String.valueOf(dep.alletec_id__c),dep.Id);    
                            //------------------------------------------------------------------------------------------------------------------------------
                            for(Integer i=0 ; i < listObject.size() ; i++) {
                                Map<String,Object> billingSummaryMap = (Map<String,Object>)listObject[i]; 
                                if(billingSummaryMap != NULL && billingSummaryMap.keySet().size() > 0) {
                                    Billing_Summary__c billingSummary = new Billing_Summary__c();
                                    if(billingSummaryMap.containsKey('AccountId') && billingSummaryMap.get('AccountId') != NULL)
                                        billingSummary.Account_ID__c = (String)billingSummaryMap.get('AccountId');
                                    
                                    //new field added on 1 nov 2021
                                    if(billingSummaryMap.containsKey('SubChannel') && billingSummaryMap.get('SubChannel') != NULL)
                                        billingSummary.Sub_channel__c = (String)billingSummaryMap.get('SubChannel');
                                    //new field Added by shivam on 8th Aug 2022
                                     if(billingSummaryMap.containsKey('AppointmentID') && billingSummaryMap.get('AppointmentID') != NULL)
                                        billingSummary.AppointmentID__c = (String)billingSummaryMap.get('AppointmentID');
                                    ////new field Added by shivam on 25th Aug 2022
                                  
                                    if(billingSummaryMap.containsKey('BalanceAmount') && billingSummaryMap.get('BalanceAmount') != NULL)
                                        billingSummary.Balance_Amount__c  = (String)billingSummaryMap.get('BalanceAmount');
                                    
                                    if(billingSummaryMap.containsKey('DiscountAmount') && billingSummaryMap.get('DiscountAmount') != NULL)
                                        billingSummary.Discount_Amount__c  = (String)billingSummaryMap.get('DiscountAmount');
                                    
                                    if(billingSummaryMap.containsKey('CGST') && billingSummaryMap.get('CGST') != NULL)
                                        billingSummary.CGST__c = (String)billingSummaryMap.get('CGST');
                                    
                                    if(billingSummaryMap.containsKey('SGST') && billingSummaryMap.get('SGST') != NULL)
                                        billingSummary.SGST__c = (String)billingSummaryMap.get('SGST');
                                    
                                    if(billingSummaryMap.containsKey('Surgery') && billingSummaryMap.get('Surgery') != NULL)
                                        billingSummary.Surgery__c = (String)billingSummaryMap.get('Surgery');
                                    
                                    if(billingSummaryMap.containsKey('Corporate TPA') && billingSummaryMap.get('Corporate TPA') != NULL)
                                        billingSummary.Corporate_TPA__c = (String)billingSummaryMap.get('Corporate TPA');
                                    
                                    if(billingSummaryMap.containsKey('CorporateTPAOther') && billingSummaryMap.get('CorporateTPAOther') != NULL)
                                        billingSummary.Corporate_TPA_Other__c = (String)billingSummaryMap.get('CorporateTPAOther');
                                   /////////////////////////////////////// 
                                    if(billingSummaryMap.containsKey('ADDRESS') && billingSummaryMap.get('ADDRESS') != NULL)
                                        billingSummary.billto_name__c = (String)billingSummaryMap.get('ADDRESS');
                                    if(billingSummaryMap.containsKey('AppointmentBookinId') && billingSummaryMap.get('AppointmentBookinId') != NULL)
                                        billingSummary.alletec_appointmentbookingid__c = (String)billingSummaryMap.get('AppointmentBookinId');
                                    if(billingSummaryMap.containsKey('BILLDATE') && billingSummaryMap.get('BILLDATE') != NULL) {
                                        String dateStr = (String)billingSummaryMap.get('BILLDATE');
                                        
                                        if(String.isNotBlank(dateStr))
                                            billingSummary.alletec_billdate__c = DateTime.valueOf((String)billingSummaryMap.get('BILLDATE'));    
                                    }
                                    if(billingSummaryMap.containsKey('BillNo') && billingSummaryMap.get('BillNo') != NULL) {
                                        billingSummary.invoicenumber__c  = (String)billingSummaryMap.get('BillNo');
                                        setIPID.add(billingSummary.invoicenumber__c); // Added on 2 May
                                    }
                                    
                                    if(billingSummaryMap.containsKey('CAMPAIGNCODE') && billingSummaryMap.get('CAMPAIGNCODE') != NULL)
                                        billingSummary.Campaign_Code__c = (String)billingSummaryMap.get('CAMPAIGNCODE');
                                    if(billingSummaryMap.containsKey('CASHORCREDIT') && billingSummaryMap.get('CASHORCREDIT') != NULL)
                                        billingSummary.alletec_cashorcredit__c   = (String)billingSummaryMap.get('CASHORCREDIT');
                                    if(billingSummaryMap.containsKey('CHANNELNAME') && billingSummaryMap.get('CHANNELNAME') != NULL)
                                        billingSummary.alletec_channeltype__c    = (String)billingSummaryMap.get('CHANNELNAME');
                                    if(billingSummaryMap.containsKey('CITY') && billingSummaryMap.get('CITY') != NULL) { // Changed on 21 May 2019
                                        if(mapAlltecCityToId.containsKey(((String)billingSummaryMap.get('CITY'))))
                                            billingSummary.City__c  = mapAlltecCityToId.get(((String)billingSummaryMap.get('CITY')));  
                                    }
                                    
                                   if(billingSummaryMap.containsKey('CompanyName') && billingSummaryMap.get('CompanyName') != NULL)
                                        billingSummary.alletec_companynametext_del__c = (String)billingSummaryMap.get('CompanyName');
                                    
                                    if(billingSummaryMap.containsKey('GLCode') && billingSummaryMap.get('GLCode') != NULL)
                                       billingSummary.GL_Code__c = (String)billingSummaryMap.get('GLCode');
                                     if(billingSummaryMap.containsKey('InsuranceCompanyName') && billingSummaryMap.get('InsuranceCompanyName') != NULL)
                                       billingSummary.Insurance_Company_Name__c = (String)billingSummaryMap.get('InsuranceCompanyName');
                                    
                                    if(billingSummaryMap.containsKey('CompanyShareAmount') && billingSummaryMap.get('CompanyShareAmount') != NULL) {
                                        billingSummary.alletec_companyshareamount__c = (Decimal)billingSummaryMap.get('CompanyShareAmount');    
                                    }
                                    
                                    if(billingSummaryMap.containsKey('COUNTRY') && billingSummaryMap.get('COUNTRY') != NULL) { //Changed on 21 May 2019
                                        if(mapAlltecCountryToId.containsKey(((String)billingSummaryMap.get('COUNTRY'))))
                                            billingSummary.Country__c = mapAlltecCountryToId.get(((String)billingSummaryMap.get('COUNTRY'))); 
                                    }
                                    
                                    if(billingSummaryMap.containsKey('DATEOFADMISSION') && billingSummaryMap.get('DATEOFADMISSION') != NULL) {
                                        String dateStr = (String)billingSummaryMap.get('DATEOFADMISSION');
                                        if(String.isNotBlank(dateStr))
                                            billingSummary.alletec_dateofadmission__c = DateTime.valueOf((String)billingSummaryMap.get('DATEOFADMISSION'));    
                                    }
                                    if(billingSummaryMap.containsKey('DATEOFDISCHARGE') && billingSummaryMap.get('DATEOFDISCHARGE') != NULL){
                                        String dateStr = (String)billingSummaryMap.get('DATEOFDISCHARGE');
                                        if(String.isNotBlank(dateStr))
                                            billingSummary.alletec_dateofdischarge__c = DateTime.valueOf((String)billingSummaryMap.get('DATEOFDISCHARGE'));    
                                    }
                                    if(billingSummaryMap.containsKey('DISCOUNT') && billingSummaryMap.get('DISCOUNT') != NULL)
                                        billingSummary.discountamount__c = (Decimal)billingSummaryMap.get('DISCOUNT');
                                    if(billingSummaryMap.containsKey('DiscountReason') && billingSummaryMap.get('DiscountReason') != NULL)
                                        billingSummary.alletec_discountreason__c = (String)billingSummaryMap.get('DiscountReason');
                                    if(billingSummaryMap.containsKey('doctor_employee_id') && billingSummaryMap.get('doctor_employee_id') != NULL)
                                        billingSummary.alletec_empid__c  = (String)billingSummaryMap.get('doctor_employee_id');
                                    if(billingSummaryMap.containsKey('DoctorID') && billingSummaryMap.get('DoctorID') != NULL) {
                                        String doctorId = (String)billingSummaryMap.get('DoctorID');
                                        if(String.isNotBlank(doctorId))
                                            billingSummary.alletec_doctorid__c = doctorId;    
                                    }
                                    if(billingSummaryMap.containsKey('DOCTORNAME') && billingSummaryMap.get('DOCTORNAME') != NULL)
                                        billingSummary.alletec_doctorname__c = (String)billingSummaryMap.get('DOCTORNAME');
                                    if(billingSummaryMap.containsKey('EmergencyNo') && billingSummaryMap.get('EmergencyNo') != NULL){
                                        String intStr = (String)billingSummaryMap.get('EmergencyNo');
                                        if(String.isNotBlank(intStr))
                                            billingSummary.alletec_emergencyno__c = Integer.valueOf((String)billingSummaryMap.get('EmergencyNo'));   
                                    }
                                    if(billingSummaryMap.containsKey('HOSPITALLOCATION') && billingSummaryMap.get('HOSPITALLOCATION') != NULL) { //Changed on 21 May 2019 
                                        String hospitalId = (String)billingSummaryMap.get('HOSPITALLOCATION');
                                        if(String.isNotBlank(hospitalId) && mapHisIdToBusinessUnitId.containsKey(hospitalId)) {
                                            billingSummary.Hospital_Location_HIS__c = hospitalId;
                                            string businessUnitId = mapHisIdToBusinessUnitId.get(hospitalId);
                                            if(String.isNotBlank(businessUnitId)) {
                                                billingSummary.alletec_hospitallocation__c = businessUnitId; 
                                                //setHospitalId.add(businessUnitId);    // Added on 01 May 2019
                                            }
                                        }
                                    }
                                    
                                    if(billingSummaryMap.containsKey('International') && billingSummaryMap.get('International') != NULL) {
                                        String international = (String)billingSummaryMap.get('International');  
                                        if(String.isNotBlank(international)) {
                                            if(international == 'True')
                                                billingSummary.alletec_isinternational__c = true;    
                                        }
                                    }
                                    if(billingSummaryMap.containsKey('IPID') && billingSummaryMap.get('IPID') != NULL) {
                                        String ipId = (String)billingSummaryMap.get('IPID');
                                        if(String.isNotBlank(ipId)) {
                                            billingSummary.alletec_ipid__c   = (String)billingSummaryMap.get('IPID');
                                            //setIPID.add(ipId);    // Added on 01 May 2019
                                        }
                                        
                                    }
                                    
                                    if(billingSummaryMap.containsKey('isbillcancelled') && billingSummaryMap.get('isbillcancelled') != NULL) {
                                        String billCancelled = (String)billingSummaryMap.get('isbillcancelled');
                                        if(String.isNotBlank(billCancelled)) {
                                            if(billCancelled == 'True')
                                                billingSummary.alletec_isbillcancelled__c = true;    
                                        }
                                    }
                                    
                                    if(billingSummaryMap.containsKey('LOCALITY') && billingSummaryMap.get('LOCALITY') != NULL) {//Changed on 21 May 2018
                                        billingSummary.alletec_locality__c  = (String)billingSummaryMap.get('LOCALITY');
                                        if(mapAlletecLocalityToId.containsKey((String)billingSummaryMap.get('LOCALITY')))
                                            billingSummary.Locality__c = mapAlletecLocalityToId.get((String)billingSummaryMap.get('LOCALITY'));
                                    }
                                    System.debug('Billing Summary Max ID line 174 ==>' + billingSummaryMap.get('MAXID'));
                                    if(billingSummaryMap.containsKey('MAXID') && billingSummaryMap.get('MAXID') != NULL)
                                        billingSummary.name__c  = (String)billingSummaryMap.get('MAXID');

                                    if(billingSummaryMap.containsKey('OP') && billingSummaryMap.get('OP') != NULL)
                                        billingSummary.alletec_op__c    = (String)billingSummaryMap.get('OP');
                                    if(billingSummaryMap.containsKey('PatientName') && billingSummaryMap.get('PatientName') != NULL)
                                        billingSummary.alletec_patientname__c   = (String)billingSummaryMap.get('PatientName');
                                    if(billingSummaryMap.containsKey('PINCODE') && billingSummaryMap.get('PINCODE') != NULL) {
                                        billingSummary.billto_postalcode__c = (String)billingSummaryMap.get('PINCODE');
                                    }
                                    if(billingSummaryMap.containsKey('PREADMITNO') && billingSummaryMap.get('PREADMITNO') != NULL){
                                        String intStr = (String)billingSummaryMap.get('PREADMITNO');
                                        if(String.isNotBlank(intStr))
                                            billingSummary.alletec_preadmitno__c    = Integer.valueOf((String)billingSummaryMap.get('PREADMITNO'));    
                                    }
                                    if(billingSummaryMap.containsKey('SOURCEOFINFO') && billingSummaryMap.get('SOURCEOFINFO') != NULL)
                                        billingSummary.alletec_sourceofinfo__c  = (String)billingSummaryMap.get('SOURCEOFINFO');
                                    if(billingSummaryMap.containsKey('SPECIALITY') && billingSummaryMap.get('SPECIALITY') != NULL) {// Changed on 21 May 2019
                                        String specialityId = (String)billingSummaryMap.get('SPECIALITYId');
                                        if(String.isNotBlank(specialityId) && mapAlletecIdToDepartmentId.containsKey(specialityId))
                                            billingSummary.alletec_department__c  = mapAlletecIdToDepartmentId.get(specialityId);    
                                    }
                                    
                                    if(billingSummaryMap.containsKey('SSNNo') && billingSummaryMap.get('SSNNo') != NULL)
                                        billingSummary.SSNo__c = (String)billingSummaryMap.get('SSNNo');
                                    if(billingSummaryMap.containsKey('State') && billingSummaryMap.get('State') != NULL) {//Changed on 21 May 2019
                                        billingSummary.alletec_state__c = (String)billingSummaryMap.get('State');
                                        if(String.isNotBlank(billingSummary.alletec_state__c) && mapAlletecStateToId.containsKey(billingSummary.alletec_state__c))
                                            billingSummary.State__c = mapAlletecStateToId.get(billingSummary.alletec_state__c);
                                    }
                                    
                                    if(billingSummaryMap.containsKey('SUBSPECIALITY') && billingSummaryMap.get('SUBSPECIALITY') != NULL)
                                        billingSummary.alletec_subspeciality__c  = (String)billingSummaryMap.get('SUBSPECIALITY');
                                    if(billingSummaryMap.containsKey('SUBSPECIALITYID') && billingSummaryMap.get('SUBSPECIALITYID') != NULL) {
                                        //String subSpecialityId = RecordCheckUtilityClass.checkRecord((String)billingSummaryMap.get('SUBSPECIALITYID'),(String)billingSummaryMap.get('SUBSPECIALITY'),Label.Specialization);        
                                        if(mapHisIdToSpecializationId.containsKey((String)billingSummaryMap.get('SUBSPECIALITYID')))
                                            billingSummary.alletec_speciality__c = mapHisIdToSpecializationId.get((String)billingSummaryMap.get('SUBSPECIALITYID'));   
                                    }
                                    if(billingSummaryMap.containsKey('TOTALAMOUNT') && billingSummaryMap.get('TOTALAMOUNT') != NULL) {
                                        billingSummary.alletec_hisamount__c = (Decimal)billingSummaryMap.get('TOTALAMOUNT');    
                                    }
                                    if(billingSummaryMap.containsKey('TRANSACTIONTYPE') && billingSummaryMap.get('TRANSACTIONTYPE') != NULL) {
                                        setTransactionType.add((String)billingSummaryMap.get('TRANSACTIONTYPE'));
                                        billingSummary.alletec_transactiontype__c   = (String)billingSummaryMap.get('TRANSACTIONTYPE');
                                    }
                                    
                                    
                                    //To exclude duplicate bills from the list of bills in the API request
                                    if(!setBillNo.contains(billingSummary.invoicenumber__c)) {
                                        setBillNo.add(billingSummary.invoicenumber__c);
                                        listBillingSummary.add(billingSummary);
                                        
                                        
                                        List<Billing_Itemwise__c> listItemWise = new List<Billing_Itemwise__c>();
                                        List<Object> listBillingItemWise = (List<Object>)billingSummaryMap.get('billingitemwise');
                                        if(listBillingItemWise !=  NULL && listBillingItemWise.size() > 0) {
                                            for(Integer j=0 ; j < listBillingItemWise.size() ; j++) {
                                                Map<String,Object> billingItemWiseMap = (Map<String,Object>)listBillingItemWise[j];
                                                if(billingItemWiseMap != NULL && billingItemWiseMap.keySet().size() > 0) {
                                                    Billing_Itemwise__c billingItem = new Billing_Itemwise__c();
                                                    if(billingItemWiseMap.containsKey('CampaignId') && billingItemWiseMap.get('CampaignId') != NULL)
                                                        billingItem.CampaignID__c = (String)billingItemWiseMap.get('CampaignId');
                                      
                                                    if(billingItemWiseMap.containsKey('DISCOUNT') && billingItemWiseMap.get('DISCOUNT') != NULL) {
                                                        String decStr = (String)billingItemWiseMap.get('DISCOUNT');
                                                        if(String.isNotBlank(decStr))
                                                            billingItem.manualdiscountamount__c = Decimal.valueOf((String)billingItemWiseMap.get('DISCOUNT'));     
                                                    }
                                                    if(billingItemWiseMap.containsKey('DiscountReason') && billingItemWiseMap.get('DiscountReason') != NULL) 
                                                        billingItem.alletec_discountreason__c = (String)billingItemWiseMap.get('DiscountReason');
                                                    if(billingItemWiseMap.containsKey('isitemcancelled') && billingItemWiseMap.get('isitemcancelled') != NULL) {
                                                        String isItemCancelled = (String)billingItemWiseMap.get('isitemcancelled');
                                                        if(String.isNotBlank(isItemCancelled)) {
                                                            if(isItemCancelled == 'True')
                                                                billingItem.alletec_isitemcancelled__c = true;  
                                                        }
                                                    }
                                                    if(billingItemWiseMap.containsKey('ITEM') && billingItemWiseMap.get('ITEM') != NULL) 
                                                        billingItem.alletec_item__c = (String)billingItemWiseMap.get('ITEM');
                                                    if(billingItemWiseMap.containsKey('ItemRecordId') && billingItemWiseMap.get('ItemRecordId') != NULL) 
                                                        billingItem.alletec_itemrecordid__c = (String)billingItemWiseMap.get('ItemRecordId');
                                                    if(billingItemWiseMap.containsKey('Orderid') && billingItemWiseMap.get('Orderid') != NULL) 
                                                        billingItem.alletec_orderid__c = Decimal.ValueOf((String)billingItemWiseMap.get('Orderid'));
                                                    if(billingItemWiseMap.containsKey('PRICE') && billingItemWiseMap.get('PRICE') != NULL)  {
                                                        String price = (String)billingItemWiseMap.get('PRICE');
                                                        if(String.isNotBlank(price))
                                                            billingItem.alletec_invoicelineamount__c = Decimal.ValueOf((String)billingItemWiseMap.get('PRICE'));   
                                                    }
                                                    if(billingItemWiseMap.containsKey('QUANTITY') && billingItemWiseMap.get('QUANTITY') != NULL) {
                                                        String quantity = (String)billingItemWiseMap.get('QUANTITY');
                                                        if(String.isNotBlank(quantity))
                                                            billingItem.quantity__c = Decimal.ValueOf((String)billingItemWiseMap.get('QUANTITY'));    
                                                    } 
                                                    if(billingItemWiseMap.containsKey('SERVICE') && billingItemWiseMap.get('SERVICE') != NULL) 
                                                        billingItem.alletec_service__c = (String)billingItemWiseMap.get('SERVICE');
                                                    if(billingItemWiseMap.containsKey('Vistaid') && billingItemWiseMap.get('Vistaid') != NULL) 
                                                        billingItem.alletec_vistaid__c = (String)billingItemWiseMap.get('Vistaid');
                                                    // code added by Icon for sending api data
                                                    if(billingItemWiseMap.containsKey('discountamount') && billingItemWiseMap.get('discountamount') != NULL) {
                                                      String decStr = billingItemWiseMap.get('discountamount')+'';
                                                       if(String.isNotBlank(decStr))
                                                       billingItem.manualdiscountamount__c = Decimal.valueOf(decStr);     
                                                    }
                                                    
                                                   if(billingItemWiseMap.containsKey('OPBillId') && billingItemWiseMap.get('OPBillId') != NULL) 
                                                   {
                                                      billingItem.alletec_orderid__c = Decimal.ValueOf(billingItemWiseMap.get('OPBillId')+'');
                                                   }
                                                   if(billingItemWiseMap.containsKey('ServiceId') && billingItemWiseMap.get('ServiceId') != NULL) 
                                                   {
                                                        billingItem.Service_ID__c = Integer.ValueOf(billingItemWiseMap.get('ServiceId')+'');
                                                   }
                                                    if(billingItemWiseMap.containsKey('Amount') && billingItemWiseMap.get('Amount') != NULL)  {
                                                        String price = billingItemWiseMap.get('Amount')+'';
                                                        if(String.isNotBlank(price))
                                                            billingItem.alletec_invoicelineamount__c = Decimal.ValueOf(billingItemWiseMap.get('Amount')+'');   
                                                    }
                                                    if(billingItemWiseMap.containsKey('ServiceName') && billingItemWiseMap.get('ServiceName') != NULL) 
                                                    {
                                                        billingItem.alletec_service__c = billingItemWiseMap.get('ServiceName')+'';
                                                    }
     
                                                    billingItem.invoiceid__r = billingSummary;
                                                    listItemWise.add(billingItem);
                                                    
                                                }    
                                            }
                                            mapSummaryToListItem.put(billingSummary,listItemWise);
                                        }
                                    }
                                }
                            }
                            
                            if(listBillingSummary != NULL && listBillingSummary.size() > 0) {
                                
                                //-----------------Added on 01 May 2019-------------------------
                                Map<String,String> mapIpIdHospitalLocationToBillingSummary = new Map<String,String>();     //  Added on 01 May 2019
                                //Map<String,Boolean> mapIpIdHospitalLocationToListItemInsert = new Map<String,Boolean>();    // Added on 01 May 2019
                                List<Billing_Summary__c> listBillingSummaryToInsert = new List<Billing_Summary__c>();
                                List<Billing_Summary__c> listBillingSummaryToUpdate = new List<Billing_Summary__c>();
                                if(setIPID != NULL && setIPID.size() > 0 && setTransactionType != NULL && setTransactionType.size() > 0) {
                                    for(Billing_Summary__c bs : [SELECT Id,alletec_transactiontype__c,invoicenumber__c FROM Billing_Summary__c 
                                                                 WHERE alletec_transactiontype__c IN :setTransactionType AND invoicenumber__c IN :setIPID]) 
                                    {
                                        mapIpIdHospitalLocationToBillingSummary.put(bs.alletec_transactiontype__c+'#'+bs.invoicenumber__c,bs.Id);
                                                                     //mapIpIdHospitalLocationToListItemInsert.put(bs.alletec_hospitallocation__c+'#'+bs.alletec_ipid__c,false);
                                                                 }    
                                }
                                System.debug('List of Billing summary ALL Data  => ' + listBillingSummary);
                                System.debug('List of Billing summary ALL Data Size  => ' + listBillingSummary.size());
                                for(Billing_Summary__c bs : listBillingSummary) {
                                    if(bs.alletec_transactiontype__c != NULL && bs.invoicenumber__c != NULL) {
                                        if(mapIpIdHospitalLocationToBillingSummary.containsKey(bs.alletec_transactiontype__c+'#'+bs.invoicenumber__c)) {
                                            bs.Id = mapIpIdHospitalLocationToBillingSummary.get(bs.alletec_transactiontype__c+'#'+bs.invoicenumber__c);
                                            listBillingSummaryToUpdate.add(bs);
                                        }
                                        else {
                                            listBillingSummaryToInsert.add(bs);
                                            
                                        }
                                    }
                                }
                                  System.debug('List of Billing summary to Insert => ' + listBillingSummaryToInsert);
                                System.debug('List of Billing summary to Insert size => ' + listBillingSummaryToInsert.size());
                                
                                //--------------------------------------------------------------
                                
                                
                    
                                list<id> idlist = new list<id>(); 
                                 list<id> erroridlist = new list<id>(); 
                                String Ids = '';
                                SeT<String> MaxIdNotPresentList = new SET<String>();
                                List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                              
                                
                                if(listBillingSummaryToInsert.size() > 0 ) {
                                    Database.SaveResult[] srList = Database.insert(listBillingSummaryToInsert,false);
                                    //system.debug('SrList Success Data 0 ==>' +srList[0].isSuccess());
                                    //system.debug('SrList Success Data 1 ==>' +srList[1].isSuccess());
                                    //system.debug('SrList Success Data 2 ==>' +srList[2].isSuccess());
                                    
                                    for(Integer i=0;i<srList.size();i++){
                                        if(!srList[i].isSuccess()){
                                            API_Error_Log__c apiError = new API_Error_Log__c();
                                            apiError.API_Name__c = 'Billing Summary';
                                            apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                                            apiError.Trigger_Point__c = 'billing-summary';
                                            apiError.Record_Identifier__c = '{"BillNo" : "'+listBillingSummaryToInsert[i].invoicenumber__c+'","Bill Date" : "'+listBillingSummaryToInsert[i].alletec_billdate__c+'","MAX ID" : "'+listBillingSummaryToInsert[i].name__c+'","IPID" : "'+listBillingSummaryToInsert[i].alletec_ipid__c+'"}';
                                           	apiError.Error_Bill_Number__c = listBillingSummaryToInsert[i].invoicenumber__c;
                                            apiError.Error_MAXID__c =listBillingSummaryToInsert[i].name__c;
                                            listApiErrorLog.add(apiError);
                                            MaxIdNotPresentList.add(listBillingSummaryToInsert[i].name__c);
                                           
                                             system.debug('if data ');
                                        }
                                        else {
                                            ids += srList[i].getId() + ',';
                                        	idlist.add(srList[i].getId());
                                             system.debug('Else data ');
                                        }
                                    }
                                    System.debug('MAX ID Not Present ==> ' + MaxIdNotPresentList);
                                     system.debug('listApiErrorLog ==> ' + listApiErrorLog);
                                    
                                    List<Billing_Itemwise__c> listBillItem = new List<Billing_Itemwise__c>();
                                    for(Billing_Summary__c bs : listBillingSummaryToInsert) {
                                        if(bs.Id != NULL) {
                                            if(mapSummaryToListItem.keySet().size() > 0 && mapSummaryToListItem.containsKey(bs)) {
                                                List<Billing_Itemwise__c> listBillingItemWise = mapSummaryToListItem.get(bs);
                                                if(listBillingItemWise != NULL && listBillingItemWise.size() > 0) {
                                                    for(Billing_Itemwise__c biw : listBillingItemWise) {
                                                        biw.invoiceid__c = bs.Id;
                                                        listBillItem.add(biw);
                                                    }
                                                }
                                            }    
                                        }
                                    }
                                    
                                    if(listBillItem != NULL && listBillItem.size() > 0)
                                        insert listBillItem;
                                }
                                
                                if(listBillingSummaryToUpdate.size() > 0) {
                                    Database.SaveResult[] srList1 = Database.update(listBillingSummaryToUpdate,false);
                                    
                                    for(Integer i=0;i<srList1.size();i++){
                                        if(!srList1[i].isSuccess()){
                                            API_Error_Log__c apiError = new API_Error_Log__c();
                                            apiError.API_Name__c = 'Billing Summary';
                                            apiError.Error_Message__c = String.valueOf(srList1[i].getErrors());
                                            apiError.Trigger_Point__c = 'billing-summary';
                                            apiError.Record_Identifier__c = '{"BillNo" : "'+listBillingSummaryToUpdate[i].invoicenumber__c+'","Bill Date" : "'+listBillingSummaryToUpdate[i].alletec_billdate__c+'","MAX ID" : "'+listBillingSummaryToUpdate[i].name__c+'","IPID" : "'+listBillingSummaryToUpdate[i].alletec_ipid__c+'"}';
                                            listApiErrorLog.add(apiError); 
                                             
                                            
                                        }
                                        else {
                                            ids += srList1[i].getId() + ',';
                                            idlist.add(srList1[i].getId());
                                            
                                        }
                                    }
                                     
                                    
                                }
                                
                                if(String.isNotBlank(Ids))
                                    Ids = Ids.removeEnd(',');
                                 system.debug('idList Data ===>' +idlist);
                                if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                                {
                                    insert listApiErrorLog;
                                }
                                 for(API_Error_Log__c apiError : listApiErrorLog)
                                 {
                                      erroridlist.add(apiError.id);
                                 }
                             List<API_Error_Log__c> ErrorLogDataList = [select id,Error_Bill_Number__c,Error_MAXID__c  from API_Error_Log__c where Error_MAXID__c IN: MaxIdNotPresentList and ID In : erroridlist];
                                System.debug('Billing Summary List data line 397 ===> ' + ErrorLogDataList);
                                 List<Billing_Summary__c> bsslist = [select id,invoicenumber__c,Name__c ,alletec_ipid__c from Billing_Summary__c where id IN: idlist];
                            			System.debug('Billing Summary List data line 400 ===> ' + bsslist);
                            
                                String jsonresponse = '[';
                                
                                for(Billing_Summary__c bssc : bsslist){
        
                                   jsonresponse+=' {';
                                        
                                       jsonresponse+=' "BillNo": "'+bssc.invoicenumber__c+'",';
                                            
                                          jsonresponse+='  "Status": "success",';
                                                
                                             jsonresponse+='   "ResponseID":"'+bssc.Id+'"';
                                                    
                                                 jsonresponse+='},';
                                                        
                                                        }
                                       for(API_Error_Log__c bssc : ErrorLogDataList){
                                           
                                           jsonresponse+=' {';
                                           
                                           jsonresponse+=' "BillNo": "'+bssc.Error_Bill_Number__c+'",';
                                           
                                           jsonresponse+='  "Status": "Failure",';
                                           
                                           jsonresponse+='},';
                                                        
                                                        }
                               
                                system.debug('Json response data line 392===>' +jsonresponse);
                                
                                jsonresponse=jsonresponse.removeEnd(',');
                                
                                jsonresponse+=']';
                                
                                
                                
                                String jsonStr = '{"success" : true,"message" : "Billing Summaries Created Successfully!","BillNo" : "'+Ids+'"}';
                                RestContext.response.addHeader('Content-Type', 'application/json');
                                RestContext.response.responseBody = Blob.valueOf(jsonresponse);
                                
                                
                                return;
                           
                            }
                        }    
                        
         else if(entityName == Label.PatientInfo) {   //  
                            List<Account> listAccount = new List<Account>();
                            Map<String,Account> mapMaxIdToPatient = new Map<String,Account>(); 
                            String devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
                            for(Integer i=0 ; i < listObject.size() ; i++) {
                                Map<String,Object> accountMap = (Map<String,Object>)listObject[i];
                                if(accountMap != NULL && accountMap.keySet().size() > 0) {
                                    Account acc = new Account();
                                    if(accountMap.containsKey('Firstname') || accountMap.containsKey('Lastname')) {
                                        String firstName = (String)accountMap.get('Firstname');
                                        if(String.isNotBlank(firstName)) {
                                            acc.firstName = firstName;
                                            acc.LastName = firstName;
                                        }
                                        String lastName = (String)accountMap.get('Lastname');
                                        if(String.isNotBlank(lastName))
                                            acc.lastName = lastName;
                                    }
                                    
                                    if(String.isNotBlank(devRecordTypeId))
                                        acc.RecordTypeId = devRecordTypeId;
                                    if(accountMap.containsKey('Address1') && accountMap.get('Address1') != NULL)
                                        acc.BillingStreet = (String)accountMap.get('Address1');
                                    if(accountMap.containsKey('BloodGroup') && accountMap.get('BloodGroup') != NULL) 
                                        acc.alletec_bloodgroup__c = (String)accountMap.get('BloodGroup');    
                                    
                                    if(accountMap.containsKey('City') && accountMap.get('City') != NULL)
                                        acc.City__c  = (String)accountMap.get('City');
                                    if(accountMap.containsKey('Country') && accountMap.get('Country') != NULL)
                                        acc.Country__c   = (String)accountMap.get('Country');
                                    if(accountMap.containsKey('DateOfBirth') && accountMap.get('DateOfBirth') != NULL) {
                                        String dateStr = (String)accountMap.get('DateOfBirth');
                                        if(String.isNotBlank(dateStr))
                                            acc.DOB__c = Date.valueOf(dateStr);
                                    }
                                    if(accountMap.containsKey('Email') && accountMap.get('Email') != NULL)
                                        acc.Alternate_Email__c  = (String)accountMap.get('Email');
                                    if(accountMap.containsKey('Email2') && accountMap.get('Email2') != NULL)
                                        acc.Email_Address_2__c   = (String)accountMap.get('Email2');
                                    if(accountMap.containsKey('FathersName') && accountMap.get('FathersName') != NULL)
                                        acc.alletec_fathersname__c   = (String)accountMap.get('FathersName');
                                    
                                    if(accountMap.containsKey('Gender') && accountMap.get('Gender') != NULL) 
                                        acc.Gender_HIS__c = (String)accountMap.get('Gender');    
                                    
                                    if(accountMap.containsKey('HospitalLocation') && accountMap.get('HospitalLocation') != NULL) 
                                        acc.Hospital_Location_HIS__c =  (String)accountMap.get('HospitalLocation');   
                                    
                                    
                                    if(accountMap.containsKey('IsVIP') && accountMap.get('IsVIP') != NULL) {
                                        String isVip = (String)accountMap.get('IsVIP');
                                        if(String.isNotBlank(isVip))
                                            acc.Is_VIP__c = true;
                                    }
                                    
                                    if(accountMap.containsKey('MaritalStatus') && accountMap.get('MaritalStatus') != NULL) 
                                        acc.Marital_Status_HIS__c = (String)accountMap.get('MaritalStatus');
                                    
                                    
                                    if(accountMap.containsKey('MiddleName') && accountMap.get('MiddleName') != NULL)
                                        acc.MiddleName = (String)accountMap.get('MiddleName');
                                    if(accountMap.containsKey('MothersMaidenName') && accountMap.get('MothersMaidenName') != NULL)
                                        acc.alletec_mothersmaidenname__c = (String)accountMap.get('MothersMaidenName');
                                    if(accountMap.containsKey('Nationality') && accountMap.get('Nationality') != NULL)
                                        acc.address2_country__c = (String)accountMap.get('Nationality');
                                    if(accountMap.containsKey('Occupation') && accountMap.get('Occupation') != NULL)
                                        acc.jobtitle__c = (String)accountMap.get('Occupation');
                                    if(accountMap.containsKey('PassportNo') && accountMap.get('PassportNo') != NULL)
                                        acc.Passport__c = (String)accountMap.get('PassportNo');
                                    if(accountMap.containsKey('PhoneNumber') && accountMap.get('PhoneNumber') != NULL)
                                        acc.PersonMobilePhone = (String)accountMap.get('PhoneNumber');
                                    if(accountMap.containsKey('PhoneNumber1') && accountMap.get('PhoneNumber1') != NULL)
                                        acc.mobilephone__c = (String)accountMap.get('PhoneNumber1');
                                    if(accountMap.containsKey('regdatetime') && accountMap.get('regdatetime') != NULL)
                                        acc.alletec_patientregisterationdate__c = DateTime.valueOf((String)accountMap.get('regdatetime'));
                                    if(accountMap.containsKey('RegistrationNo') && accountMap.get('RegistrationNo') != NULL)
                                        acc.alletec_registrationnumber__c = (String)accountMap.get('RegistrationNo');
                                    if(accountMap.containsKey('SSNNO') && accountMap.get('SSNNO') != NULL)
                                        acc.alletec_ssnno__c = (String)accountMap.get('SSNNO');
                                    if(accountMap.containsKey('Title') && accountMap.get('Title') != NULL)
                                        acc.Salutation = (String)accountMap.get('Title');
                                    
                                    if(accountMap.containsKey('MAXID') && accountMap.get('MAXID') != NULL) {
                                        acc.Max_ID__c = (String)accountMap.get('MAXID');
                                        if(String.isNotBlank(acc.Max_ID__c))
                                            mapMaxIdToPatient.put(acc.Max_ID__c , acc);
                                    }
                                    
                                    
                                    //listAccount.add(acc);
                                    
                                    
                                }
                            }
                            
                            if(mapMaxIdToPatient!= NULL && mapMaxIdToPatient.size() > 0) {
                                //upsert listAccount Max_ID__c;
                                
                                //Database.UpsertResult[] results = Database.upsert(listAccount,Account.Max_ID__c,false);
                                
                                Map<String,Id> mapMaxIdToRecordId = new Map<String,Id>();
                                List<Account> listAccountInsert = new List<Account>();
                                List<Account> listAccountUpdate = new List<Account>();
                                
                                for(Account acc : [SELECT Id,Max_Id__c FROM Account WHERE RecordType.Name = 'Patient' AND Max_Id__c IN : mapMaxIdToPatient.keySet() LIMIT 50000])
                                    mapMaxIdToRecordId.put(acc.Max_ID__c,acc.Id);  
                                
                                for(String maxId : mapMaxIdToPatient.keySet()) {
                                    Account acc = mapMaxIdToPatient.get(maxId);
                                    if(mapMaxIdToRecordId.containsKey(maxId)) {
                                        acc.Id = mapMaxIdToRecordId.get(maxId);
                                        listAccountUpdate.add(acc);
                                    }
                                    else {
                                        listAccountInsert.add(acc);    
                                    }
                                }
                                
                                
                                
                                List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                                
                                String ids='';
                                
                                if(listAccountInsert != NULL && listAccountInsert.size() > 0) {
                                    Database.SaveResult[] srList = Database.insert(listAccountInsert, false);
                                    
                                    for(Integer i=0;i<srList.size();i++){
                                        if(!srList[i].isSuccess()){
                                            API_Error_Log__c apiError = new API_Error_Log__c();
                                            apiError.API_Name__c = 'Patient Info';
                                            apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                                            apiError.Trigger_Point__c = 'patient-info';
                                            apiError.Record_Identifier__c = '{"MAX ID" : "'+listAccountInsert[i].Max_ID__c+'"}';
                                            listApiErrorLog.add(apiError); 
                                        }
                                        else 
                                            ids += srList[i].getId() + ',';
                                    }
                                    
                                }
                                
                                if(listAccountUpdate != NULL && listAccountUpdate.size() > 0) {
                                    Database.SaveResult[] srList = Database.update(listAccountUpdate, false);
                                    
                                    for(Integer i=0;i<srList.size();i++){
                                        if(!srList[i].isSuccess()){
                                            API_Error_Log__c apiError = new API_Error_Log__c();
                                            apiError.API_Name__c = 'Patient Info';
                                            apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                                            apiError.Trigger_Point__c = 'patient-info';
                                            apiError.Record_Identifier__c = '{"MAX ID" : "'+listAccountUpdate[i].Max_ID__c+'"}';
                                            listApiErrorLog.add(apiError); 
                                        }
                                        else 
                                            ids += srList[i].getId() + ',';
                                    }
                                }
                                
                                
                                if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                                    insert listApiErrorLog;
                                
                                ids = ids.removeEnd(',');
                                String jsonStr = '{"success" : true,"message" : "Patient Info Created Successfully","ids" :"'+ids+'"}';
                                RestContext.response.addHeader('Content-Type', 'application/json');
                                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                                return;
                            }
                        }
                        
                        
                        else if(entityName == Label.Doctor) {
                            List<Account> listDoctor = new List<Account>();
                            String devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
                             Map<String,Id> mapHisIdToSpecializationId = new Map<String,Id>();
                            for(Speciality__c spc : [SELECT Id,HIS_ID__c FROM Speciality__c where alletec_deleted__c=false])
                                mapHisIdToSpecializationId.put(spc.HIS_ID__c,spc.Id);   
                            
                            Map<String,Id> mapAlletecIdToDepartmentId = new Map<String,Id>();
                            for(Department__c dep : [SELECT Id,alletec_id__c FROM Department__c where Deleted__c=false])
                                mapAlletecIdToDepartmentId.put(String.valueOf(dep.alletec_id__c),dep.Id);
                            
                            
                            
                            
                            for(Integer i=0 ; i < listObject.size() ; i++) {
                                Map<String,Object> doctorMap = (Map<String,Object>)listObject[i]; 
                                if(doctorMap != NULL && doctorMap.keySet().size() > 0) {
                                    Account doctor = new Account();
                                    if(String.isNotBlank(devRecordTypeId))
                                        doctor.RecordTypeId = devRecordTypeId; 
                                    if(doctorMap.containsKey('name') && doctorMap.get('name') != NULL)
                                        doctor.LastName = (String)doctorMap.get('name');
                                    if(doctorMap.containsKey('doctorid') && doctorMap.get('doctorid') != NULL)
                                        doctor.alletec_doctorid__c = String.valueOf((Integer)doctorMap.get('doctorid'));
                                    if(doctorMap.containsKey('gender') && doctorMap.get('gender') != NULL)
                                        doctor.Gender__c = (String)doctorMap.get('gender');
                                    if(doctorMap.containsKey('mobilenumber') && doctorMap.get('mobilenumber') != NULL)
                                        doctor.mobilephone__c = (String)doctorMap.get('mobilenumber');
                                    if(doctorMap.containsKey('specialityid') && doctorMap.get('specialityid') != NULL){
                                        String depId = String.valueOf((Integer)doctorMap.get('specialityid'));
                                        if(mapAlletecIdToDepartmentId.containskey(depId))
                                            doctor.Department__c = mapAlletecIdToDepartmentId.get(depId);
                                    }
                                    if(doctorMap.containsKey('subspecialityid') && doctorMap.get('subspecialityid') != NULL){
                                        String specId = String.valueOf((Integer)doctorMap.get('subspecialityid'));
                                        if(mapHisIdToSpecializationId.containskey(specId))
                                            doctor.SF_Speciality__c=mapHisIdToSpecializationId.get(specId);
                                    }
                                    if(doctorMap.containsKey('vistaid') && doctorMap.get('vistaid') != NULL)
                                        doctor.Vista_ID__c = (String)doctorMap.get('vistaid');
                                    if(doctorMap.containsKey('deleted') && doctorMap.get('deleted')!=NULL){ 
                                        String isdeleted = (String)doctorMap.get('deleted');
                                        if(isdeleted =='true')
                                            doctor.Deleted__c= true;
                                    }
                                    listDoctor.add(doctor);
                                }
                            }
                            
                            if(listDoctor != NULL && listDoctor.size() > 0) {
                                Schema.SObjectField field = Account.Fields.alletec_doctorid__c;
                                
                                Database.UpsertResult[] srList = Database.upsert(listDoctor,field,false);
                                String ids='';
                                
                                for(Integer i=0;i<srList.size();i++){
                                    if(!srList[i].isSuccess()){
                                        API_Error_Log__c apiError = new API_Error_Log__c();
                                        apiError.API_Name__c = 'International Patient Outstanding';
                                        apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                                        apiError.Trigger_Point__c = 'Department Error';
                                        //apiError.Record_Identifier__c = '{"MAX ID" : "'+listToUpdate[i].alletec_maxid__c+'"}';
                                        //listApiErrorLog.add(apiError); 
                                    }
                                    else 
                                        ids += srList[i].getId() + ',';
                                }
                                
                                ids = ids.removeEnd(',');
                                
                                String jsonStr = '{"success" : true,"message" : "Doctor Created Successfully!","ids":"'+ids+'"}';
                                RestContext.response.addHeader('Content-Type', 'application/json');
                                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                                return;
                            }
                        }
                        else if(entityName == Label.InternationalPatientOutstanding) {
                            Set<String> setMaxId = new Set<String>();
                            Set<Integer> setIPID = new Set<Integer>();
                            Set<String> setHospitalLocation = new Set<String>();
                            List<Internationalpatient_Outstanding__c> listInternationalPatientOutstanding = new List<Internationalpatient_Outstanding__c>();
                            for(Integer i=0 ; i < listObject.size() ; i++) {
                                Map<String,Object> interPatMap = (Map<String,Object>)listObject[i]; 
                                if(interPatMap != NULL && interPatMap.keySet().size() > 0) {
                                    Internationalpatient_Outstanding__c intrPat = new Internationalpatient_Outstanding__c();
                                    if(interPatMap.containsKey('AdmissionDate') && interPatMap.get('AdmissionDate') != NULL) {
                                        String admDate = (String)interPatMap.get('AdmissionDate');
                                        if(String.isNotBlank(admDate))
                                            intrPat.alletec_admissiondate__c = DateTime.valueOf(admDate);    
                                    }
                                    
                                    if(interPatMap.containsKey('AdvanceAmount') && interPatMap.get('AdvanceAmount') != NULL)
                                        intrPat.alletec_advanceamount__c = Decimal.valueOf((String)interPatMap.get('AdvanceAmount'));
                                    if(interPatMap.containsKey('BillAmount') && interPatMap.get('BillAmount') != NULL)
                                        intrPat.alletec_billamount__c = Decimal.valueOf((String)interPatMap.get('BillAmount'));
                                    if(interPatMap.containsKey('BillingDate') && interPatMap.get('BillingDate') != NULL) {
                                        String billDate = (String)interPatMap.get('BillingDate');
                                        if(String.isNotBlank(billDate))
                                            intrPat.alletec_billingdate__c = DateTime.valueOf(billDate);    
                                    }
                                    
                                    if(interPatMap.containsKey('BillNo') && interPatMap.get('BillNo') != NULL)
                                        intrPat.alletec_name__c = (String)interPatMap.get('BillNo');
                                    if(interPatMap.containsKey('EmergencyNo') && interPatMap.get('EmergencyNo') != NULL) {
                                        String emerNo = (String)interPatMap.get('EmergencyNo');
                                        if(String.isNotBlank(emerNo))
                                            intrPat.alletec_emergencyno__c = Integer.valueOf(emerNo);    
                                    }
                                    if(interPatMap.containsKey('IPID') && interPatMap.get('IPID') != NULL) {
                                        intrPat.alletec_ipid__c = Integer.valueOf((String)interPatMap.get('IPID'));
                                        setIPID.add(Integer.valueOf((String)interPatMap.get('IPID')));
                                    }
                                    
                                    if(interPatMap.containsKey('locationname') && String.isNotBlank((String)interPatMap.get('locationname'))) {
                                        String locId = RecordCheckUtilityClass.checkRecord((String)interPatMap.get('locationname'),'',Label.Business_Unit);
                                        system.debug('intrPat.alletec_location__c+++++========'+locId);
                                        if(String.isNotBlank(locId)) {
                                            intrPat.alletec_location__c = locId; 
                                            SetHospitalLocation.add(locId);
                                        }
                                        
                                    }
                                    system.debug('intrPat.alletec_location__c========'+intrPat.alletec_location__c);
                                    
                                    if(interPatMap.containsKey('MAXID') && interPatMap.get('MAXID') != NULL) {
                                        intrPat.alletec_maxid__c = (String)interPatMap.get('MAXID');
                                        if(String.isNotBlank((String)interPatMap.get('MAXID')))
                                            setMaxId.add((String)interPatMap.get('MAXID'));
                                    }
                                    
                                    if(interPatMap.containsKey('OP') && interPatMap.get('OP') != NULL)
                                        intrPat.alletec_optype__c = (String)interPatMap.get('OP');
                                    if(interPatMap.containsKey('OutStandingAmount') && interPatMap.get('OutStandingAmount') != NULL)
                                        intrPat.alletec_outstandingamount__c = Decimal.valueOf((String)interPatMap.get('OutStandingAmount'));
                                    if(interPatMap.containsKey('PreAdmitNo') && String.isNotBlank((String)interPatMap.get('PreAdmitNo')))
                                        intrPat.alletec_preadmitno__c = Integer.valueOf((String)interPatMap.get('PreAdmitNo'));
                                    if(interPatMap.containsKey('SSNNO') && interPatMap.get('SSNNO') != NULL)
                                        intrPat.SSN_No__c = (String)interPatMap.get('SSNNO');
                                    if(interPatMap.containsKey('DoctorName') && interPatMap.get('DoctorName') != NULL)
                                        intrPat.Doctor_Name__c = (String)interPatMap.get('DoctorName');
                                    if(interPatMap.containsKey('DoctorId') && interPatMap.get('DoctorId') != NULL)
                                        intrPat.Doctor_Id__c = (String)interPatMap.get('DoctorId');
                                    if(interPatMap.containsKey('WardName') && interPatMap.get('WardName') != NULL)
                                        intrPat.Ward_Name__c = (String)interPatMap.get('WardName');
                                    if(interPatMap.containsKey('WardId') && interPatMap.get('WardId') != NULL)
                                        intrPat.Ward_Id__c = (String)interPatMap.get('WardId');
                                    if(interPatMap.containsKey('BedName') && interPatMap.get('BedName') != NULL)
                                        intrPat.Bed_Name__c = (String)interPatMap.get('BedName');
                                    if(interPatMap.containsKey('BedId') && interPatMap.get('BedId') != NULL)
                                        intrPat.Bed_Id__c = (String)interPatMap.get('BedId');
                                    listInternationalPatientOutstanding.add(intrPat);
                                }
                            }
                            
                            if(listInternationalPatientOutstanding != NULL && listInternationalPatientOutstanding.size() > 0) {
                                
                                Map<String,String> mapMaxIdToId = new Map<String,String>();
                                Map<String,String> mapIPIDHosLocToId = new Map<String,String>();
                                List<Internationalpatient_Outstanding__c> listToInsert = new List<Internationalpatient_Outstanding__c>();
                                List<Internationalpatient_Outstanding__c> listToUpdate = new List<Internationalpatient_Outstanding__c>();
                                
                                if(setMaxId != NULL && setMaxId.size() > 0)
                                    for(Account pat : [SELECT Id,Max_id__c FROM Account WHERE RecordType.Name = 'Patient' AND Max_Id__c IN :setMaxId])
                                    mapMaxIdToId.put(pat.Max_id__c,pat.Id); 
                                
                                
                                if(setIPId != NULL && setIPID.size() > 0 && setHospitalLocation != NULL && setHospitalLocation.size() > 0) {
                                    for(Internationalpatient_Outstanding__c ipo : [SELECT Id,alletec_location__c,alletec_ipid__c
                                                                                   FROM Internationalpatient_Outstanding__c
                                                                                   WHERE alletec_ipid__c IN :setIPID
                                                                                   AND alletec_location__c IN :setHospitalLocation])
                                        mapIPIDHosLocToId.put(String.valueOf(ipo.alletec_ipid__c)+'*'+ipo.alletec_location__c,ipo.Id);
                                }
                                
                                System.debug('====listInternationalPatientOutstanding==='+listInternationalPatientOutstanding);
                                //if(mapMaxIdToId != NULL && mapMaxIdToId.keyset().size() > 0) {
                                for(Internationalpatient_Outstanding__c intPat : listInternationalPatientOutstanding) {
                                    if(String.isNotBlank(intPat.alletec_maxid__c)) {
                                        if(mapMaxIdToId !=  NULL && mapMaxIdToId.keySet().size() > 0 && mapMaxIdToId.containsKey(intPat.alletec_maxid__c))
                                            intPat.Patient__c = mapMaxIdToId.get(intPat.alletec_maxid__c);          
                                    }
                                    
                                   if(intPat.alletec_ipid__c != NULL && String.isNotBlank(intPat.alletec_location__c)) {
                                        system.debug('Inside IF===');
                                        String key = String.valueOf(intPat.alletec_ipid__c) + '*' + intPat.alletec_location__c;
                                        if(mapIPIDHosLocToId != NULL && mapIPIDHosLocToId.keySet().size() > 0 && mapIPIDHosLocToId.containsKey(key)) 
                                        {
                                            System.debug('Inside IF');
                                            intPat.Id = mapIPIDHosLocToId.get(key);
                                            listToUpdate.add(intPat);
                                        }
                                        else {
                                            listToInsert.add(intPat);    
                                        }
                                    }
                                }    
                                //}
                                
                                
                                List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                                String ids='';
                                system.debug('====List Insert =========' + listToInsert);
                                if(listToInsert != NULL && listToInsert.size() > 0) {
                                    Database.SaveResult[] srList = Database.insert(listToInsert,false);
                                    for(Integer i=0;i<srList.size();i++){
                                        if(!srList[i].isSuccess()){
                                            API_Error_Log__c apiError = new API_Error_Log__c();
                                            apiError.API_Name__c = 'International Patient Outstanding';
                                            apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                                            apiError.Trigger_Point__c = 'intlr-pat-info';
                                            apiError.Record_Identifier__c = '{"MAX ID" : "'+listToInsert[i].alletec_maxid__c+'"}';
                                            listApiErrorLog.add(apiError); 
                                        }
                                        else 
                                            ids += srList[i].getId() + ',';
                                    }       
                                }
                                
                                
                                if(listToUpdate != NULL && listToUpdate.size() > 0) {
                                    Database.SaveResult[] srList = Database.update(listToUpdate, false);
                                    
                                    for(Integer i=0;i<srList.size();i++){
                                        if(!srList[i].isSuccess()){
                                            API_Error_Log__c apiError = new API_Error_Log__c();
                                            apiError.API_Name__c = 'International Patient Outstanding';
                                            apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                                            apiError.Trigger_Point__c = 'intlr-pat-info';
                                            apiError.Record_Identifier__c = '{"MAX ID" : "'+listToUpdate[i].alletec_maxid__c+'"}';
                                            listApiErrorLog.add(apiError); 
                                        }
                                        else 
                                            ids += srList[i].getId() + ',';
                                    }
                                }
                                
                                if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                                    insert listApiErrorLog;
                                
                                ids = ids.removeEnd(',');
                                String jsonStr = '{"success" : true,"message" : "International Patient Outstanding Created Successfully","ids" :"'+ids+'"}';
                                RestContext.response.addHeader('Content-Type', 'application/json');
                                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                                return;
                            }
                        }
                        else if(entityName == Label.Specialization) {
                            List<Speciality__c> listSpecialization = new List<Speciality__c>();
                            for(Integer i=0 ; i < listObject.size() ; i++) {
                                Map<String,Object> specialityMap = (Map<String,Object>)listObject[i]; 
                                if(specialityMap != NULL && specialityMap.keySet().size() > 0) {
                                    Speciality__c speciality = new Speciality__c();
                                    
                                    if(specialityMap.containsKey('Name') && specialityMap.get('Name') != NULL) {
                                        speciality.Name = (String)specialityMap.get('Name');
                                        if(specialityMap.containsKey('DepartmentId') && specialityMap.get('DepartmentId') != NULL){ 
                                            String str = String.valueOf((Integer)specialityMap.get('DepartmentId'));
                                            if(String.isNotBlank(str))
                                                speciality.alletec_department__c = RecordCheckUtilityClass.checkRecord(str,speciality.Name,Label.Department);
                                        }
                                    }
                                    if(specialityMap.containsKey('ENDDATETIME') && specialityMap.get('ENDDATETIME') != NULL){ 
                                        String endTime = (String)specialityMap.get('ENDDATETIME');
                                        if(String.isNotBlank(endTime))
                                            speciality.alletec_enddatetime__c = DateTime.valueOf(endTime);
                                    }    
                                    if(specialityMap.containsKey('STARTDATETIME') && specialityMap.get('STARTDATETIME') != NULL){ 
                                        String stTime = (String)specialityMap.get('STARTDATETIME');
                                        speciality.alletec_startdatetime__c = DateTime.valueOf(stTime);
                                    }
                                    if(specialityMap.containsKey('ID') && specialityMap.get('ID') != NULL) 
                                        speciality.HIS_ID__c = String.valueOf((Integer)specialityMap.get('ID'));    
                                    if(specialityMap.containsKey('Deleted') && specialityMap.get('Deleted')!=NULL){ 
                                        String isdeleted = (String)specialityMap.get('Deleted');
                                        if(isdeleted =='true')
                                            speciality.alletec_deleted__c= true;
                                    }
                                    
                                    listSpecialization.add(speciality);
                                }
                            }
                            
                            if(listSpecialization != NULL && listSpecialization.size() > 0) {
                                // upsert listSpecialization HIS_ID__c;
                                Schema.SObjectField field = Speciality__c.Fields.HIS_ID__c;
                                
                                Database.UpsertResult[] srList = Database.upsert(listSpecialization,field,false);
                                String ids='';
                                
                                for(Integer i=0;i<srList.size();i++){
                                    if(!srList[i].isSuccess()){
                                        API_Error_Log__c apiError = new API_Error_Log__c();
                                        apiError.API_Name__c = 'International Patient Outstanding';
                                        apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                                        apiError.Trigger_Point__c = 'Department Error';
                                        //apiError.Record_Identifier__c = '{"MAX ID" : "'+listToUpdate[i].alletec_maxid__c+'"}';
                                        //listApiErrorLog.add(apiError); 
                                    }
                                    else 
                                        ids += srList[i].getId() + ',';
                                }
                                
                                /* String ids='';
for(Speciality__c spec : listSpecialization){
ids+=spec.Id+',';
}*/
                                
                                ids = ids.removeEnd(',');
                                
                                String jsonStr = '{"success" : true,"message" : "Speciality Inserted Successfully","ids":"'+ids+'"}';
                                RestContext.response.addHeader('Content-Type', 'application/json');
                                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                                return;         
                            }
                        }
                        else if(entityName == Label.department) {
                            
                            List<Department__c> listDepartment = new List<Department__c>();
                            for(Integer i=0 ; i < listObject.size() ; i++) {
                                Map<String,Object> DepartmentMap = (Map<String,Object>)listObject[i]; 
                                Department__c dpt=new Department__c();
                                if(DepartmentMap.containsKey('Name') && DepartmentMap.get('Name') != NULL) 
                                    dpt.Name = (String)DepartmentMap.get('Name');
                                if(DepartmentMap.containsKey('DepartmentId') && DepartmentMap.get('DepartmentId') != NULL) 
                                    dpt.alletec_id__c = Decimal.valueOf((Integer)DepartmentMap.get('DepartmentId'));
                                if(DepartmentMap.containsKey('deleted') && DepartmentMap.get('deleted') != NULL) {
                                    String isdeleted = (String)DepartmentMap.get('deleted');
                                    if(isdeleted =='true')
                                        dpt.Deleted__c= true;
                                }
                                listDepartment.add(dpt);
                            }
                            if(listDepartment != NULL && listDepartment.size() > 0) {
                                // Upsert listDepartment alletec_id__c;
                                Schema.SObjectField field = Department__c.Fields.alletec_id__c;
                                Database.UpsertResult[] srList = Database.upsert(listDepartment,field,false);
                                String ids='';
                                
                                for(Integer i=0;i<srList.size();i++){
                                    if(!srList[i].isSuccess()){
                                        API_Error_Log__c apiError = new API_Error_Log__c();
                                        apiError.API_Name__c = 'International Patient Outstanding';
                                        apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                                        apiError.Trigger_Point__c = 'Department Error';
                                        //apiError.Record_Identifier__c = '{"MAX ID" : "'+listToUpdate[i].alletec_maxid__c+'"}';
                                        //listApiErrorLog.add(apiError); 
                                    }
                                    else 
                                        ids += srList[i].getId() + ',';
                                }
                                
                                
                                
                                
                                /*  for(Department__c dep : listDepartment){
ids+=dep.Id+',';
}*/
                                
                                ids = ids.removeEnd(',');
                                
                                //Send success response
                                String jsonStr = '{"success" : true,"message" : "Departments added Successfully","ids":"'+ids+'"}';
                                RestContext.response.addHeader('Content-Type', 'application/json');
                                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                                return;         
                            }
                        }
                        else {
                            String jsonStr = '{"success" : false,"message" : "Provide Correct Entity Name"}';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(jsonStr);
                            return;     
                        }
                    }
                }
                else {
                    String jsonStr = '{"success" : false,"message" : "Provide atleast one record"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;     
                }
            }
            else {
                String jsonStr = '{"success" : false,"message" : "Provide Body"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;
            }
        }   
        catch(Exception e) {
            Database.rollback(sp);
            String jsonStr = '{"success" : false,"message" : "'+e.getMessage()+'"}';            
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return;      
        }
    }
}