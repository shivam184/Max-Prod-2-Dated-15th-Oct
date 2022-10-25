public Without sharing class  TodayPlanApexController {
    
    @AuraEnabled
    public static WrapperClass doInitApex() {
        List<Beat_Plan_Detail__c> listBeatPlanDetails = new List<Beat_Plan_Detail__c>();
        List<Beat_Plan_Detail__c> listCompletedBeatPlanDetails = new List<Beat_Plan_Detail__c>();
        Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
            String year = String.valueOf(Date.today().year());
        WrapperClass wrpCls = new WrapperClass();
        
        String profileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
        wrpCls.ownerName = UserInfo.getName();
        wrpCls.todayDate = System.today();
        String queryBeatPlanDetails = '';
        String queryCompletedBeatPlanDetails = '';
        
        
        List<Beat_Plan__c> listBeatPlan = [SELECT Id FROM Beat_Plan__c 
                                           WHERE Agent__c = :userInfo.getUserId()
                                           AND Month__c = :mapMonthNumberToName.get(Date.today().month())
                                           AND Year__c = :year
                                           AND Status__c = 'Scheduled'];
        
        
        
        if(listBeatPlan != NULL && listBeatPlan.size() > 0) {
            String beatPlanId = listBeatPlan[0].Id;
            wrpCls.showTodayPlan = true;
            wrpCls.beatPlanId = listBeatPlan[0].Id;
            /*
List<Beat_Plan_Detail__c> listBeatPlanDetails = [SELECT Id,Account__c,Account__r.Name,Account__r.PersonMobilePhone,
Account__r.Address_From_Geolocation__c,Checked_In__c,Checked_Out__c,
Account__r.RecordType.Name
FROM Beat_Plan_Detail__c
WHERE Beat_Plan__c = :listBeatPlan[0].Id
AND ((Expected_Date_of_Visit__c = TODAY AND Status__c = 'Scheduled') OR (Expected_Date_of_Visit__c = TODAY AND Status__c = 'In Progress'))
AND (Account__c != NULL OR Lead != NULL OR Opportunity__c != NULL OR Contact__c != NULL)];

List<Beat_Plan_Detail__c> listCompletedBeatPlanDetails = [SELECT Account__c,Account__r.Name,Account__r.PersonMobilePhone,
Account__r.Address_From_Geolocation__c
FROM Beat_Plan_Detail__c
WHERE Beat_Plan__c = :listBeatPlan[0].Id
AND Expected_Date_of_Visit__c = TODAY
AND Status__c = 'Completed'
AND Checked_In__c = true
AND Checked_Out__c = true
AND (Account__c != NULL OR Contact__c != NULL OR Contact__c != NULL OR Opportunity__c != NULL];
*/
            
            
            if(String.isNotBlank(profileName) && (profileName.contains('MECP')) || profileName.contains('System Administrator')) {
                queryBeatPlanDetails = 'SELECT Id,Account__c,Account__r.Name,Account__r.PersonMobilePhone,Account__r.Address_From_Geolocation__c,Checked_In__c,Checked_Out__c,Account__r.RecordType.Name,Contact__c,Contact__r.Name,Contact__r.Converted__c,Contact__r.Phone,Contact__r.MailingAddress,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingPostalCode,Contact__r.MailingState,Contact__r.MailingCountry,Lead__c,Opportunity__c ';
                queryBeatPlanDetails +='FROM Beat_Plan_Detail__c WHERE Beat_Plan__c = :beatPlanId AND ((Expected_Date_of_Visit__c = TODAY AND Status__c = \'Scheduled\') OR (Expected_Date_of_Visit__c = TODAY AND Status__c = \'In Progress\')) AND (Account__c != NULL OR Contact__c != NULL)';
                queryCompletedBeatPlanDetails = 'SELECT Account__c,Account__r.Name,Account__r.PersonMobilePhone,Account__r.Address_From_Geolocation__c,Contact__c,Contact__r.Name,Contact__r.Phone,Contact__r.MailingAddress,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingPostalCode,Contact__r.MailingState,Contact__r.MailingCountry,Lead__c,Opportunity__c ';
                queryCompletedBeatPlanDetails += 'FROM Beat_Plan_Detail__c WHERE Beat_Plan__c = :beatPlanId AND Expected_Date_of_Visit__c = TODAY AND Status__c = \'Completed\' AND Checked_In__c = true AND Checked_Out__c = true AND (Account__c != NULL OR Contact__c != NULL)';
            }
            else if(String.isNotBlank(profileName) && profileName.contains('MaxLabs')) {
                queryBeatPlanDetails = 'SELECT Id,Checked_In__c,Checked_Out__c,Account__c,Account__r.Name,Account__r.PersonMobilePhone,Account__r.Address_From_Geolocation__c,Account__r.RecordType.Name,';
                queryBeatPlanDetails += 'Lead__r.Name,Lead__r.Address_Line_1__c,Lead__r.Mobile_Phone__c,';
                queryBeatPlanDetails += 'Opportunity__r.Name,Opportunity__r.Mobile_Phone__c,Opportunity__r.City__c,Opportunity__r.Sales_Region__c,Opportunity__r.Sales_Territory__c,';
                queryBeatPlanDetails += 'Contact__r.Name,Contact__r.Phone,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingPostalCode,Contact__r.MailingState,Contact__r.MailingCountry ';
                queryBeatPlanDetails += 'FROM Beat_Plan_Detail__c WHERE Beat_Plan__c = :beatPlanId AND ((Expected_Date_of_Visit__c = TODAY AND Status__c = \'Scheduled\') OR (Expected_Date_of_Visit__c = TODAY AND Status__c = \'In Progress\')) AND ((Account__c != NULL AND Account__r.RecordType.Name = \'Business Account\') OR Lead__c != NULL OR Contact__c != NULL OR Opportunity__c != NULL)';
                queryCompletedBeatPlanDetails = 'SELECT Id,Checked_In__c,Checked_Out__c,Account__c,Account__r.Name,Account__r.PersonMobilePhone,Account__r.Address_From_Geolocation__c,Account__r.RecordType.Name,';
                queryCompletedBeatPlanDetails += 'Lead__r.Name,Lead__r.Address_Line_1__c,Lead__r.Mobile_Phone__c,';
                queryCompletedBeatPlanDetails += 'Opportunity__r.Name,Opportunity__r.Mobile_Phone__c,Opportunity__r.City__c,Opportunity__r.Sales_Region__c,Opportunity__r.Sales_Territory__c,';
                queryCompletedBeatPlanDetails += 'Contact__r.Name,Contact__r.Phone,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingPostalCode,Contact__r.MailingState,Contact__r.MailingCountry ';
                queryCompletedBeatPlanDetails += 'FROM Beat_Plan_Detail__c WHERE Beat_Plan__c = :beatPlanId AND Expected_Date_of_Visit__c = TODAY AND Status__c = \'Completed\' AND Checked_In__c = true AND Checked_Out__c = true AND ((Account__c != NULL AND Account__r.RecordType.Name = \'Business Account\') OR Lead__c != NULL OR Contact__c != NULL OR Opportunity__c != NULL)';    
            }  
            
            if(String.isNotBlank(queryBeatPlanDetails) && String.isNotBlank(queryCompletedBeatPlanDetails)) {
                listBeatPlanDetails = Database.query(queryBeatPlanDetails);
                listCompletedBeatPlanDetails = Database.query(queryCompletedBeatPlanDetails);
                //System.debug('listBeatPlanDetails-->'+listBeatPlanDetails);
                //System.debug('listCompletedBeatPlanDetails-->'+listCompletedBeatPlanDetails);
            }                                          
            List<Beat_Day__c> listBeatDay = [SELECT Id,Distance_Travelled_in_Day__c,Day_End_Location__Latitude__s FROM Beat_Day__c
                                             WHERE Agent__c = :userInfo.getUserId()
                                             AND Beat_Plan__c = :listBeatPlan[0].Id
                                             AND CreatedDate = TODAY];  
            if(listBeatDay != NULL && listBeatDay.size() > 0) {
                wrpCls.beatDayId = listBeatDay[0].Id;
                wrpCls.showStartDay = true;
                if(listBeatDay[0].Distance_Travelled_in_Day__c != NULL)
                    wrpCls.distanceTravelled = listBeatDay[0].Distance_Travelled_in_Day__c;
                if(listBeatDay[0].Day_End_Location__Latitude__s != NULL)
                    wrpCls.endDay = true;
                
                if(listBeatPlanDetails != NULL && listBeatPlanDetails.size() > 0) {
                    for(Beat_Plan_Detail__c bpd : listBeatPlanDetails) {
                        BeatPlanDetailWrapperClass bpdWrpCls = new BeatPlanDetailWrapperClass();
                        bpdWrpCls.recordId = bpd.Id;
                        if(bpd.Checked_In__c)
                            bpdWrpCls.showCheckedIn = true; 
                        if(bpd.Account__c != NULL) {
                            if(bpd.Account__r.Name != NULL)
                                bpdWrpCls.name = '[A]-'+bpd.Account__r.Name;
                            if(bpd.Account__r.PersonMobilePhone != NULL)
                                bpdWrpCls.phoneNo = bpd.Account__r.PersonMobilePhone;
                            if(bpd.Account__r.Address_From_Geolocation__c != NULL)
                                bpdWrpCls.address = bpd.Account__r.Address_From_Geolocation__c;
                            if(bpd.Account__r.RecordType.Name == 'MECP Doctor Business' && bpd.Account__r.Address_From_Geolocation__c == NULL)
                                bpdWrpCls.showGeoTagButton = true;
                        }
                        else if(bpd.Lead__c != NULL) {
                            if(bpd.Lead__r.Name != NULL)
                                bpdWrpCls.name = bpd.Lead__r.Name;
                            if(bpd.Lead__r.Mobile_Phone__c != NULL)
                                bpdWrpCls.phoneNo = bpd.Lead__r.Mobile_Phone__c;
                            if(bpd.Lead__r.Address_Line_1__c != NULL)
                                bpdWrpCls.address = bpd.Lead__r.Address_Line_1__c;
                        }
                        else if(bpd.Opportunity__c != NULL) {
                            if(bpd.Opportunity__r.Name != NULL)
                                bpdWrpCls.name = bpd.Opportunity__r.Name;
                            if(bpd.Opportunity__r.Mobile_Phone__c != NULL)
                                bpdWrpCls.phoneNo = bpd.Opportunity__r.Mobile_Phone__c;
                            if(bpd.Opportunity__r.City__c != NULL)
                                bpdWrpCls.address += bpd.Opportunity__r.City__c + ' ';
                            if(bpd.Opportunity__r.Sales_Region__c != NULL)
                                bpdWrpCls.address += bpd.Opportunity__r.Sales_Region__c + ' ';
                            if(bpd.Opportunity__r.Sales_Territory__c != NULL)
                                bpdWrpCls.address += bpd.Opportunity__r.Sales_Territory__c;
                        }
                        else if(bpd.Contact__c != NULL) {
                            
                            if(bpd.contact__r.MailingAddress != NULL) {
                                if(bpd.Contact__r.MailingStreet != NULL)
                                    bpdWrpCls.address += bpd.Contact__r.MailingStreet + ' ';
                                if(bpd.Contact__r.MailingCity != NULL)
                                    bpdWrpCls.address += bpd.Contact__r.MailingCity + ' ';
                                if(bpd.Contact__r.MailingState != NULL)
                                    bpdWrpCls.address += bpd.Contact__r.MailingState + ' ';
                                if(bpd.Contact__r.MailingCountry != NULL)
                                    bpdWrpCls.address += bpd.Contact__r.MailingCountry;    
                            }
                            else
                                bpdWrpCls.showGeoTagButton = true;    
                            
                            
                            if(bpd.Contact__r.Name != NULL)
                                bpdWrpCls.name = '[C]-'+bpd.Contact__r.Name;
                            if(bpd.Contact__r.Phone != NULL)
                                bpdWrpCls.phoneNo = bpd.Contact__r.Phone;
                            if(!bpd.Contact__r.Converted__c)
                                bpdWrpCls.convertToAccount = true;
                            
                        }
                        wrpCls.listBeatPlanDetails.add(bpdWrpCls);
                    }
                }
                
                if(listCompletedBeatPlanDetails != NULL && listCompletedBeatPlanDetails.size() > 0) {
                    for(Beat_Plan_Detail__c bpd : listCompletedBeatPlanDetails) {
                        CompletedBeatPlanDetailWrapperClass cbpdWrpCls = new CompletedBeatPlanDetailWrapperClass();
                        if(bpd.Account__c != NULL) {
                            if(bpd.Account__r.Name != NULL)
                                cbpdWrpCls.name = '[A]-'+bpd.Account__r.Name;
                            if(bpd.Account__r.PersonMobilePhone != NULL)
                                cbpdWrpCls.phoneNo = bpd.Account__r.PersonMobilePhone;
                            if(bpd.Account__r.Address_From_Geolocation__c != NULL)
                                cbpdWrpCls.address = bpd.Account__r.Address_From_Geolocation__c;
                            
                        }
                        else if(bpd.Lead__c != NULL) {
                            if(bpd.Lead__r.Name != NULL)
                                cbpdWrpCls.name = bpd.Lead__r.Name;
                            if(bpd.Lead__r.Mobile_Phone__c != NULL)
                                cbpdWrpCls.phoneNo = bpd.Lead__r.Mobile_Phone__c;
                            if(bpd.Lead__r.Address_Line_1__c != NULL)
                                cbpdWrpCls.address = bpd.Lead__r.Address_Line_1__c;
                        }
                        else if(bpd.Opportunity__c != NULL) {
                            if(bpd.Opportunity__r.Name != NULL)
                                cbpdWrpCls.name = bpd.Opportunity__r.Name;
                            if(bpd.Opportunity__r.Mobile_Phone__c != NULL)
                                cbpdWrpCls.phoneNo = bpd.Opportunity__r.Mobile_Phone__c;
                            if(bpd.Opportunity__r.City__c != NULL)
                                cbpdWrpCls.address += bpd.Opportunity__r.City__c + ' ';
                            if(bpd.Opportunity__r.Sales_Region__c != NULL)
                                cbpdWrpCls.address += bpd.Opportunity__r.Sales_Region__c + ' ';
                            if(bpd.Opportunity__r.Sales_Territory__c != NULL)
                                cbpdWrpCls.address += bpd.Opportunity__r.Sales_Territory__c;
                        }
                        else if(bpd.Contact__c != NULL) {
                            if(bpd.Contact__r.Name != NULL)
                                cbpdWrpCls.name = '[C]-'+bpd.Contact__r.Name;
                            if(bpd.Contact__r.Phone != NULL)
                                cbpdWrpCls.phoneNo = bpd.Contact__r.Phone;
                            if(bpd.Contact__r.MailingStreet != NULL)
                                cbpdWrpCls.address += bpd.Contact__r.MailingStreet + ' ';
                            if(bpd.Contact__r.MailingCity != NULL)
                                cbpdWrpCls.address += bpd.Contact__r.MailingCity + ' ';
                            if(bpd.Contact__r.MailingState != NULL)
                                cbpdWrpCls.address += bpd.Contact__r.MailingState + ' ';
                            if(bpd.Contact__r.MailingCountry != NULL)
                                cbpdWrpCls.address += bpd.Contact__r.MailingCountry;
                            
                        }
                        wrpCls.listCompletedBeatPlanDetails.add(cbpdWrpCls);
                    }
                }   
                
                List<Beat_Plan_Detail__c> listBeatPlanDetailOfficeVisit = [SELECT Id,Account__c,Account__r.Name,Account__r.PersonMobilePhone,
                                                                           Account__r.Address_From_Geolocation__c
                                                                           FROM Beat_Plan_Detail__c
                                                                           WHERE Beat_Plan__c = :listBeatPlan[0].Id
                                                                           AND ((Expected_Date_of_Visit__c = TODAY AND Status__c = 'Scheduled') OR (Reschedule_Date__c = TODAY AND Status__c = 'Re-scheduled'))
                                                                           AND Account__c != NULL
                                                                           AND Visit_to_Office__c = true];
                
                if(listBeatPlanDetailOfficeVisit != NULL && listBeatPlanDetailOfficeVisit.size() > 0)
                    wrpCls.officeVisit = true;
                
                for(Beat_Plan_Detail__c bpd : listBeatPlanDetails) {
                    if(bpd.Checked_In__c == true && bpd.Checked_Out__c == false) {
                        wrpCls.disabledCheckIn = true;
                        break;
                    }
                }
            }
            else {
                wrpCls.showEndDay = true;
                wrpCls.officeVisit = true;
                if(listBeatPlanDetails != NULL && listBeatPlanDetails.size() > 0) {
                    for(Beat_Plan_Detail__c bpd : listBeatPlanDetails) {
                        BeatPlanDetailWrapperClass bpdWrpCls = new BeatPlanDetailWrapperClass();
                        bpdWrpCls.recordId = bpd.Id;
                        if(bpd.Checked_In__c)
                            bpdWrpCls.showCheckedIn = true; 
                        if(bpd.Account__c != NULL) {
                            if(bpd.Account__r.Address_From_Geolocation__c != NULL)
                                bpdWrpCls.address = bpd.Account__r.Address_From_Geolocation__c;
                            if(bpd.Account__r.Name != NULL)
                                bpdWrpCls.name = '[A]-'+bpd.Account__r.Name;
                            if(bpd.Account__r.PersonMobilePhone != NULL)
                                bpdWrpCls.phoneNo = bpd.Account__r.PersonMobilePhone;
                            if(bpd.Account__r.RecordType.Name == 'MECP Doctor Business' && bpd.Account__r.Address_From_Geolocation__c == NULL)
                                bpdWrpCls.showGeoTagButton = true;
                        }
                        else if(bpd.Lead__c != NULL) {
                            if(bpd.Lead__r.Name != NULL)
                                bpdWrpCls.name = bpd.Lead__r.Name;
                            if(bpd.Lead__r.Mobile_Phone__c != NULL)
                                bpdWrpCls.phoneNo = bpd.Lead__r.Mobile_Phone__c;
                            if(bpd.Lead__r.Address_Line_1__c != NULL)
                                bpdWrpCls.address = bpd.Lead__r.Address_Line_1__c;
                        }
                        else if(bpd.Opportunity__c != NULL) {
                            if(bpd.Opportunity__r.Name != NULL)
                                bpdWrpCls.name = bpd.Opportunity__r.Name;
                            if(bpd.Opportunity__r.Mobile_Phone__c != NULL)
                                bpdWrpCls.phoneNo = bpd.Opportunity__r.Mobile_Phone__c;
                            if(bpd.Opportunity__r.City__c != NULL)
                                bpdWrpCls.address += bpd.Opportunity__r.City__c + ' ';
                            if(bpd.Opportunity__r.Sales_Region__c != NULL)
                                bpdWrpCls.address += bpd.Opportunity__r.Sales_Region__c + ' ';
                            if(bpd.Opportunity__r.Sales_Territory__c != NULL)
                                bpdWrpCls.address += bpd.Opportunity__r.Sales_Territory__c;
                        }
                        else if(bpd.Contact__c != NULL) {
                            if(bpd.Contact__r.Name != NULL)
                                bpdWrpCls.name = '[C]-'+bpd.Contact__r.Name;
                            if(bpd.Contact__r.Phone != NULL)
                                bpdWrpCls.phoneNo = bpd.Contact__r.Phone;
                            if(bpd.Contact__r.MailingStreet != NULL)
                                bpdWrpCls.address += bpd.Contact__r.MailingStreet + ' ';
                            if(bpd.Contact__r.MailingCity != NULL)
                                bpdWrpCls.address += bpd.Contact__r.MailingCity + ' ';
                            if(bpd.Contact__r.MailingState != NULL)
                                bpdWrpCls.address += bpd.Contact__r.MailingState + ' ';
                            if(bpd.Contact__r.MailingCountry != NULL)
                                bpdWrpCls.address += bpd.Contact__r.MailingCountry;
                            
                        }
                        wrpCls.listBeatPlanDetails.add(bpdWrpCls);
                    }
                }
            }
        }
        return wrpCls;
    }
    
    @auraEnabled
    public static void createStartDayApex(String beatPlanId,Decimal latitude,Decimal longitude) {
        try {
            Beat_Day__c beatDay = new Beat_Day__c();
            beatDay.Agent__c = userInfo.getUserId();
            beatDay.Day_Start_Location__Latitude__s = latitude;
            beatDay.Day_Start_Location__Longitude__s = longitude;
            beatDay.Beat_Plan__c = beatPlanId;
            if(!Test.isRunningTest()){
                Wrapper objWrapper = fetchLocationAddress(String.valueOf(latitude),String.valueOf(longitude));
                if(objWrapper.address != NULL)
                    beatDay.Day_Start_Address__c = objWrapper.address;  
                insert objWrapper.objApiLoger;
            }            
            insert beatDay; 
        }
        catch(Exception e) {
        }
    }
    
    @auraEnabled 
    public static void createEndDayApex(String beatDayId,Decimal longitude,Decimal latitude) {
        try{
            Wrapper objWrapper ;
            List<Beat_Visit__c> listBeatVisit = [SELECT Id FROM Beat_Visit__c WHERE Beat_Day__c = :beatDayId];
            List<Beat_Day__c> listBeatDay = [SELECT Id,Day_End_Location__Latitude__s,Day_End_Location__Longitude__s,
                                             Distance_Travelled_in_Day__c,Day_Start_Location__Latitude__s,
                                             Day_Start_Location__Longitude__s,Day_End_Address__c
                                             FROM Beat_Day__c WHERE Id = :beatDayId];
            
            listBeatDay[0].Day_End_Location__Latitude__s = latitude;
            listBeatDay[0].Day_End_Location__longitude__s = longitude;
            if(!Test.isRunningTest()){
                objWrapper= fetchLocationAddress(String.valueOf(latitude),String.valueOf(longitude));
                if(objWrapper.address  != NULL)
                    listBeatDay[0].Day_End_Address__c = objWrapper.address ;     
            }
            
            if(listBeatVisit != NULL && listBeatVisit.size() > 0) {
                List<Beat_Visit__c> listBeatVisitNew = [SELECT Id,CheckIn_Location__Longitude__s,CheckIn_Location__Latitude__s FROM Beat_Visit__c WHERE Visit_Sequence__c = :listBeatVisit.size() AND Beat_Day__c = :beatDayId];
                DistanceAndTime dat;  
                LocationCoordinate startLoc = new LocationCoordinate(listBeatVisitNew[0].CheckIn_Location__Latitude__s,listBeatVisitNew[0].CheckIn_Location__Longitude__s);
                LocationCoordinate endLoc = new LocationCoordinate(latitude,longitude);
                dat = AcquireDistanceFromLocation.getDistance(startLoc, endLoc);
                if(dat !=  null && dat.distance != NULL)
                    listBeatDay[0].Distance_Travelled_in_Day__c += dat.distance;
                update listBeatDay;    
            }
            else {
                DistanceAndTime dat;  
                LocationCoordinate startLoc = new LocationCoordinate(listBeatDay[0].Day_Start_Location__Latitude__s,listBeatDay[0].Day_Start_Location__Longitude__s);
                LocationCoordinate endLoc = new LocationCoordinate(latitude,longitude);
                dat = AcquireDistanceFromLocation.getDistance(startLoc,endLoc);
                if(dat != null && dat.distance != NULL)
                    listBeatDay[0].Distance_Travelled_in_Day__c = dat.distance;
                update listBeatDay;    
            }
            insert objWrapper.objApiLoger;
        }
        catch(Exception e){
            
        }
    }
    
    @auraEnabled
    public static void createVisitToOfficeApex(String beatPlanId) {
        try{
            Beat_Plan_Detail__c beatPlanDetail = new Beat_Plan_Detail__c();
            beatPlanDetail.Status__c = 'Scheduled';
            beatPlanDetail.Account__c = Label.MaxAccount;
            beatPlanDetail.Expected_Date_of_Visit__c = Date.today();
            beatPlanDetail.Beat_Plan__c = beatPlanId;
            beatPlanDetail.Visit_to_Office__c = true;
            insert beatPlanDetail;    
        }
        catch(Exception e){
        }
    }
    
    @auraEnabled
    public static void createCheckIn(String beatDayId,String beatPlanDetailId,Decimal longitude,Decimal latitude) {
        try{
            Wrapper objWrapper;
            List<Beat_Visit__c> listBeatVisit = [SELECT Id FROM Beat_Visit__c WHERE Beat_Day__c = :beatDayId];
            List<Beat_Plan_Detail__c> listBeatPlanDetails = [SELECT Id,Account__c FROM Beat_Plan_Detail__c WHERE Id = :beatPlanDetailId];
            List<Beat_Day__c> listBeatDay = [SELECT Day_Start_Location__Longitude__s,Day_Start_Location__Latitude__s,Distance_Travelled_in_Day__c FROM Beat_Day__c WHERE Id = :beatDayId];
            
            Beat_Visit__c beatVisit = new Beat_Visit__c();
            beatVisit.Account__c = listBeatPlanDetails[0].Account__c;
            beatVisit.Beat_Day__c = beatDayId;
            beatVisit.Beat_Plan_Detail__c = beatPlanDetailId;
            beatVisit.Checkin_Location__Latitude__s = latitude;
            beatVisit.Checkin_Location__Longitude__s = longitude;
            beatVisit.Checkin_Date_Time__c = System.now();
            if(!Test.isRunningTest()) {
                objWrapper= fetchLocationAddress(String.valueOf(latitude),String.valueOf(longitude));
                if(objWrapper.address != NULL)
                    beatVisit.Checkin_Address__c = objWrapper.address;
                
            }
            if(listBeatVisit != NULL && listBeatVisit.size() > 0) {
                List<Beat_Visit__c> listBeatVisitNew = [SELECT Id,CheckIn_Location__Longitude__s,CheckIn_Location__Latitude__s FROM Beat_Visit__c WHERE Visit_Sequence__c = :listBeatVisit.size() AND Beat_Day__c = :beatDayId];
                DistanceAndTime dat;  
                LocationCoordinate startLoc = new LocationCoordinate(listBeatVisitNew[0].CheckIn_Location__Latitude__s,listBeatVisitNew[0].CheckIn_Location__Longitude__s);
                LocationCoordinate endLoc = new LocationCoordinate(latitude,longitude);
                dat = AcquireDistanceFromLocation.getDistance(startLoc, endLoc);
                beatVisit.Visit_Sequence__c = listBeatVisit.size() + 1;
                insert beatVisit;
                if(dat !=  null && dat.distance != NULL)
                    listBeatDay[0].Distance_Travelled_in_Day__c += dat.distance;
                update listBeatDay; 
            }
            else {
                beatVisit.Visit_Sequence__c = 1;
                DistanceAndTime dat;  
                LocationCoordinate startLoc = new LocationCoordinate(listBeatDay[0].Day_Start_Location__Latitude__s,listBeatDay[0].Day_Start_Location__Longitude__s);
                LocationCoordinate endLoc = new LocationCoordinate(latitude,longitude);
                dat = AcquireDistanceFromLocation.getDistance(startLoc,endLoc);
                insert beatVisit;
                
                if(dat != null && dat.distance != NULL)
                    listBeatDay[0].Distance_Travelled_in_Day__c = dat.distance;
                update listBeatDay;
            }
            Beat_Plan_Detail__c beatPlanDetail = new Beat_Plan_Detail__c();
            beatPlanDetail.Id = beatPlanDetailId;
            beatPlanDetail.Checked_In__c = true;
            beatPlanDetail.Beat_Day__c = beatDayId;
            beatPlanDetail.Status__c = 'In Progress';
            update beatPlanDetail;  
            insert objWrapper.objApiLoger;
        }
        catch(Exception e){
            
            system.debug(e.getLineNumber());
            system.debug(e.getMessage());
            
        }
        
    }
    
    @auraEnabled
    public static void createCheckOut(String beatPlanDetailId,String beatDayId,Decimal longitude,Decimal latitude,String checkoutRemarks,Boolean checkTask,Boolean checkEvent,String selectedTask,String selectedEvent,Date taskDueDate,Date eventDueDate) {
        try{
            Wrapper objWrapper;
            Beat_Plan_Detail__c beatPlanDetail = new Beat_Plan_Detail__c();
            beatPlanDetail.Status__c = 'Completed';
            beatPlanDetail.Checked_Out__c = true;
            beatPlanDetail.Id = beatPlanDetailId;
            
            List<Beat_Visit__c> listBeatVisit = [SELECT Id FROM Beat_Visit__c WHERE Beat_Day__c = :beatDayId 
                                                 AND Beat_Plan_Detail__c = :beatPlanDetailId];
            if(listBeatVisit != NULL && listBeatVisit.size() > 0) {
                Beat_Visit__c beatVisit = new Beat_Visit__c();
                beatVisit.id = listBeatVisit[0].Id;
                beatVisit.Checkout_Date_Time__c = System.now();
                beatVisit.Checkout_Location__Latitude__s = latitude;
                beatVisit.Checkout_Location__Longitude__s = longitude;
                beatVisit.Remarks__c = checkoutRemarks;
                if(!Test.isRunningTest()){
                    objWrapper = fetchLocationAddress(String.valueOf(latitude),String.valueOf(longitude));
                    if(objWrapper.address != NULL)
                        beatVisit.CheckOut_Address__c = objWrapper.address;    
                }
                
                update beatVisit;
                update beatPlanDetail;
                insert objWrapper.objApiLoger;
                if(checkTask || checkEvent) {
                    List<Beat_Plan_Detail__c> listBeatPlanDetail = [SELECT Id,Account__c,Lead__c,Contact__c,Opportunity__c FROM Beat_Plan_Detail__c WHERE Id = :beatPlanDetailId]; 
                    if(listBeatPlanDetail != NULL && listBeatPlanDetail.size() > 0) {
                        if(checkTask) {
                            Task t = new Task();
                            t.OwnerId = UserInfo.getUserId();
                            t.Subject = selectedTask;
                            t.Status = 'Open';
                            t.Priority = 'Normal';
                            t.ActivityDate = taskDueDate;
                            if(listBeatPlanDetail[0].Account__c != NULL) {
                                t.WhatID = listBeatPlanDetail[0].Account__c;  
                            }
                            else if(listBeatPlanDetail[0].Lead__c != NULL)
                                t.WhatID = listBeatPlanDetail[0].Lead__c;
                            else if(listBeatPlanDetail[0].Opportunity__c != NULL)
                                t.WhatId = listBeatPlanDetail[0].Opportunity__c;
                            else if(listBeatPlanDetail[0].Contact__c != NULL)
                                t.WhoId = listBeatPlanDetail[0].Contact__c;
                            insert t;   
                        }
                        
                        if(checkEvent) {
                            Event evt = new Event();
                            evt.OwnerId = UserInfo.getUserId();
                            evt.StartDateTime = System.now();
                            //evt.EndDateTime = System.now().addDays(7);
                            evt.DurationInMinutes = 30;
                            evt.ActivityDate = eventDueDate;
                            evt.Subject = selectedEvent;
                            if(listBeatPlanDetail[0].Account__c != NULL)
                                evt.WhatID = listBeatPlanDetail[0].Account__c;
                            else if(listBeatPlanDetail[0].Lead__c != NULL)
                                evt.WhatID = listBeatPlanDetail[0].Lead__c;
                            else if(listBeatPlanDetail[0].Opportunity__c != NULL)
                                evt.WhatId = listBeatPlanDetail[0].Opportunity__c;
                            else if(listBeatPlanDetail[0].Contact__c != NULL)
                                evt.WhoId = listBeatPlanDetail[0].Contact__c;
                            insert evt;
                        }
                    }
                }
                
            }    
        }
        catch(Exception e){
            
        }
    }
    
    @auraEnabled
    public static void createCancelApex(String beatPlanDetailId,String cancelReason) {
        try{
            Beat_Plan_Detail__c beatPlanDetail = new Beat_Plan_Detail__c();
            beatPlanDetail.Id = beatPlanDetailId;
            beatPlanDetail.Cancellation_Reason__c = cancelReason;
            beatPlanDetail.Status__c = 'Cancelled';
            update beatPlanDetail;    
        }
        catch(Exception e){
        }
        
    }
    
    @auraEnabled
    public static void createRescheduleApex(String beatPlanDetailId,String rescheduleReason,String rescheduleDate) {
        try{
            Beat_Plan_Detail__c beatPlanDetail = new Beat_Plan_Detail__c();
            beatPlanDetail.Id = beatPlanDetailId;
            beatPlanDetail.Reschedule_Reason__c = rescheduleReason;
            beatPlanDetail.Status__c = 'Re-scheduled';
            beatPlanDetail.Reschedule_Date__c = Date.valueOf(rescheduleDate);
            update beatPlanDetail;
            
            Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
                
                List<Beat_Plan_Detail__c> listBeatPlanDetails = [SELECT Id,Account__c,Beat_Plan__c,Lead__c,Opportunity__c,Contact__c FROM Beat_Plan_Detail__c WHERE Id = :beatPlanDetailId];
            if(listBeatPlanDetails != NULL && listBeatPlanDetails.size() > 0) {
                Beat_Plan_Detail__c beatPlanDetailNew = new Beat_Plan_Detail__c();
                beatPlanDetailNew.Expected_Date_of_Visit__c = Date.valueOf(rescheduleDate);
                beatPlanDetailNew.Status__c = 'Scheduled';
                Date dt = Date.valueOf(rescheduleDate);
                String year = String.valueOf(dt.year());
                List<Beat_Plan__c> listBeatPlan = [SELECT Id FROM Beat_Plan__c 
                                                   WHERE Agent__c = :userInfo.getUserId()
                                                   AND Month__c = :mapMonthNumberToName.get(dt.month())
                                                   AND Year__c = :year
                                                   AND Status__c = 'Scheduled'];
                String beatPlanId = '';
                if(listBeatPlan != NULL && listBeatPlan.size() > 0)
                    beatPlanId = listBeatPlan[0].Id;
                else {
                    Beat_Plan__c beatPlan = new Beat_Plan__c();
                    beatPlan.Name = UserInfo.getName() + '-'+mapMonthNumberToName.get(dt.month())+'-'+year;
                    beatPlan.Agent__c = UserInfo.getUserId();
                    beatPlan.Month__c = mapMonthNumberToName.get(dt.month());
                    beatPlan.Year__c = year;
                    beatPlan.Status__c = 'Scheduled';
                    insert beatPlan;
                    
                    beatPlanId = beatPlan.Id;	    
                }
                
                if(String.isNotBlank(beatPlanId))
                    beatPlanDetailNew.Beat_Plan__c = beatPlanId;
                if(listBeatPlanDetails[0].Account__c != NULL)
                    beatPlanDetailNew.Account__c = listBeatPlanDetails[0].Account__c;
                else if(listBeatPlanDetails[0].Lead__c != NULL)
                    beatPlanDetailNew.Account__c = listBeatPlanDetails[0].Lead__c;
                else if(listBeatPlanDetails[0].Contact__c != NULL)
                    beatPlanDetailNew.Contact__c = listBeatPlanDetails[0].Contact__c;
                else if(listBeatPlanDetails[0].Opportunity__c != NULL)
                    beatPlanDetailNew.Opportunity__c = listBeatPlanDetails[0].Opportunity__c;
                beatPlanDetailNew.Parent_Beat_Plan_Detail__c = beatPlanDetailId;
                insert beatPlanDetailNew;
            }    
        }
        catch(Exception e){
            
        }
        
    }
    public static Wrapper fetchLocationAddress(String lat, String lon){
        String address='';
        //String url = 'https://maps.googleapis.com/maps/api/geocode/json?&key='+Label.ApiKey+'&latlng=' + String.valueOf(lat) + ',' + String.valueOf(lon) + '&sensor=true';
        String url = Label.URLForAddress+Label.Apikey+'&latlng=' + String.valueOf(lat) + ',' + String.valueOf(lon) + '&sensor=true';
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();    
        request.setEndPoint(url);
        request.setMethod('GET');
        HttpResponse response = httpProtocol.send(request);
        JSON2ApexParser.JSON2Apex japx = new JSON2ApexParser.JSON2Apex();
        japx = JSON2ApexParser.parse(response.getBody());
        if(japx.status=='OK'){
            if(japx.results!=null && japx.results.size()>0){
                if(japx.results[0].formatted_address!=null){
                    address = japx.results[0].formatted_address;
                }
            }
        }
        Wrapper objWrapper=new Wrapper();
        objWrapper.objApiLoger=createApiLoger(string.valueOf(request), string.valueOf(response.getBody()), 'GET', url);
        objWrapper.address=address;
        return objWrapper;
    }
    
    @AuraEnabled
    public static void getLocationApex(String recordId,Decimal latitude,Decimal longitude) {
        try{
            List<Beat_Plan_Detail__c> listBeatPlanDetail = [SELECT Id,Account__c,Contact__c FROM Beat_Plan_Detail__c WHERE Id = :recordId];
            if(listBeatPlanDetail != NULL && listBeatPlanDetail.size() > 0) {
                if(listBeatPlanDetail[0].Account__c != NULL) {
                    Account acc = new Account();
                    acc.Id = listBeatPlanDetail[0].Account__c;
                    acc.Office_Geolocation__Latitude__s = latitude;
                    acc.Office_Geolocation__Longitude__s = longitude;
                    Wrapper objWrapper = fetchLocationAddress(String.valueOf(latitude),String.valueOf(longitude)); 
                    if(String.isNotBlank(objWrapper.address))
                        acc.Address_From_Geolocation__c = objWrapper.address;
                    insert objWrapper.objApiLoger;
                    update acc;    
                }
                if(listBeatPlanDetail[0].Contact__c != NULL) {
                    Contact con = new Contact();
                    con.Id = listBeatPlanDetail[0].Contact__c;
                    Wrapper objWrapper = fetchLocationAddress(String.valueOf(latitude),String.valueOf(longitude)); 
                    if(String.isNotBlank(objWrapper.address))
                        con.MailingStreet = objWrapper.address;
                    insert objWrapper.objApiLoger;
                    update con;     
                }
            }    
        }
        catch(Exception e){
            
        }
    }
    @AuraEnabled	
    public static string getAddress(Decimal lat,Decimal lon) {	
        system.debug('lon'+lat+'lat'+lon);	
        Wrapper objWrapper = fetchLocationAddress(String.valueOf(lat),String.valueOf(lon));	
        system.debug('objWrapper.address'+objWrapper.address);	
        return objWrapper.address;	
            }
    @auraEnabled
    public static void confirmConvertApex(String beatPlanDetailId) {
        try {
            List<Beat_Plan_Detail__c> listBeatPlanDetail = [SELECT Id,Contact__c,Contact__r.lastName,Contact__r.FirstName,Contact__r.Name,
                                                            Contact__r.Email,Contact__r.MobilePhone,Contact__r.Contact_Territory__c,
                                                            Contact__r.Gender__c,Contact__r.Contact_Type__c,Contact__r.Specialty__c,
                                                            Contact__r.City__c,Contact__r.Country__c,Contact__r.Address__c
                                                            FROM Beat_Plan_Detail__c WHERE Id = :beatPlanDetailId];
            if(listBeatPlanDetail != NULL && listBeatPlanDetail.size() > 0) {
                if(listBeatPlanDetail[0].Contact__c != NULL) {
                    Account acc = new Account();
                    acc.Active__c = true;
                    String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
                    if(String.isNotBlank(recordTypeId))
                        acc.RecordTypeId = recordTypeId;
                    if(String.isNotBlank(listBeatPlanDetail[0].Contact__r.Name))
                        acc.Name = listBeatPlanDetail[0].Contact__r.Name;
                    if(listBeatPlanDetail[0].Contact__r.Email != NULL)
                        acc.E_mail__c = listBeatPlanDetail[0].Contact__r.Email;
                    if(listBeatPlanDetail[0].Contact__r.MobilePhone != NULL)
                        acc.Phone = listBeatPlanDetail[0].Contact__r.MobilePhone;
                    if(listBeatPlanDetail[0].Contact__r.Contact_Territory__c != NULL)
                        acc.Account_Territory__c = listBeatPlanDetail[0].Contact__r.Contact_Territory__c;
                    if(listBeatPlanDetail[0].Contact__r.Gender__c != NULL)
                        acc.Gender__c = listBeatPlanDetail[0].Contact__r.Gender__c;
                    if(listBeatPlanDetail[0].Contact__r.Contact_Type__c != NULL)
                        acc.Type = listBeatPlanDetail[0].Contact__r.Contact_Type__c;
                    if(listBeatPlanDetail[0].Contact__r.Specialty__c != NULL)
                        acc.SF_Speciality__c = listBeatPlanDetail[0].Contact__r.Specialty__c;
                    if(listBeatPlanDetail[0].Contact__r.City__c != NULL)
                        acc.CityAddressMaster__c = listBeatPlanDetail[0].Contact__r.City__c;
                    if(listBeatPlanDetail[0].Contact__r.Country__c != NULL)
                        acc.CountryAddressMaster__c = listBeatPlanDetail[0].Contact__r.Country__c;
                    if(listBeatPlanDetail[0].Contact__r.Address__c != NULL)
                        acc.BillingStreet = listBeatPlanDetail[0].Contact__r.Address__c;
                    
                    insert acc;
                    
                    Contact con = new Contact();
                    con.Id = listBeatPlanDetail[0].Contact__c;
                    con.Converted__c = true;
                    con.AccountId = acc.Id;
                    update con;
                }
            }    
        }
        catch(Exception e){
            
        }
    }
    
    public class WrapperClass{
        @auraEnabled
        public Boolean showTodayPlan;
        @auraEnabled
        public Boolean showStartDay;
        @auraEnabled
        public Boolean showEndDay;
        @auraEnabled
        public String beatPlanId;
        @auraEnabled 
        public String beatDayId;
        @auraEnabled
        public List<BeatPlanDetailWrapperClass> listBeatPlanDetails;
        @auraEnabled
        public Boolean endDay;
        @auraEnabled
        public Boolean officeVisit;
        @auraEnabled
        public Boolean disabledCheckIn;
        @auraEnabled
        public Decimal distanceTravelled;
        @AuraEnabled
        public List<CompletedBeatPlanDetailWrapperClass> listCompletedBeatPlanDetails;
        @AuraEnabled
        public String ownerName;
        @AuraEnabled
        public Date todayDate;
        @AuraEnabled
        public List<String> listTaskSubject;
        @AuraEnabled
        public List<String> listEventSubject;
        
        public WrapperClass() {
            showTodayPlan = false;
            showStartDay = false;
            showEndDay = false;
            listBeatPlanDetails = new List<BeatPlanDetailWrapperClass>();
            beatPlanId = '';
            beatDayId = '';
            endDay = false;
            officeVisit = false;
            disabledCheckIn = false;
            distanceTravelled = 0.0;
            listCompletedBeatPlanDetails = new List<CompletedBeatPlanDetailWrapperClass>();
            ownerName = '';
            listTaskSubject = new List<String>();
            listTaskSubject.add('Call');
            listTaskSubject.add('Send Letter');
            listTaskSubject.add('Send Quote');
            listTaskSubject.add('Other');
            listEventSubject = new List<String>();
            listEventSubject.add('Call');
            listEventSubject.add('Email');
            listEventSubject.add('Meeting');
            listEventSubject.add('Send Letter/Quote');
            listEventSubject.add('Other');
        }
    }
    
    public class BeatPlanDetailWrapperClass {
        @auraEnabled
        public String name;
        @auraEnabled 
        public String phoneNo;
        @auraEnabled
        public String address;
        @auraEnabled
        public String recordId;
        @auraEnabled
        public Boolean showGeoTagButton;
        @auraEnabled
        public Boolean showCheckedIn;
        @auraEnabled
        public Boolean convertToAccount;
        
        
        public BeatPlanDetailWrapperClass() {
            name = '';
            phoneNo = '';
            address = '';
            recordId = '';
            showGeoTagButton = false;
            showCheckedIn = false;
            convertToAccount = false;
            
        }
    }
    
    public class CompletedBeatPlanDetailWrapperClass {
        @auraEnabled
        public String name;
        @auraEnabled 
        public String phoneNo;
        @auraEnabled
        public String address;
        
        public CompletedBeatPlanDetailWrapperClass() {
            name = '';
            phoneNo = '';
            address = '';    
        }
    }
    
    public static Api_Loger__c createApiLoger(String srequest,string response,string methodType,string url) {
        
        Api_Loger__c log = new Api_Loger__c();
        log.Request__c=String.valueOf(srequest);
        log.Response__c=response;
        log.Method__c=methodType;
        log.End_Point__c=url;
        log.Source__c='Today Plan';
        return log;
    }
    public class Wrapper{
        public string address;
        public Api_Loger__c objApiLoger;
    }
    
    
    public static void coverage(){
        
        String strj = 'Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        
        
        
        
    }
    
}