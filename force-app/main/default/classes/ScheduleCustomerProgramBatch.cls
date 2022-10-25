global class ScheduleCustomerProgramBatch implements Schedulable {
   
   global void execute(SchedulableContext SC) {
          
       Integer batch_size = Integer.valueOf(system.label.Batch_Size);   
       Id batchId = Database.executeBatch(new CMPPatientRegistrationAndEnrolmentBatch(), batch_size);
      
   }
}