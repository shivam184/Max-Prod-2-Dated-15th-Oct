//Description: Scheduler class to fetch Appointment details from Practo 
//Created by : Techmatrix Consulting

global class ScheduleFetchAppointmentFromPracto implements Schedulable,Database.AllowsCallouts {
   
   global void execute(SchedulableContext SC) {
      FetchAppointmentsFromPracto.processAppointmentsFromPracto();
   }
}