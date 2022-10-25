public class PractoAppoinmentJSONParser {

    public class Meta {
        public Integer status;
        public String message;
    }

    
    public Meta meta;
	public Data data;
    
    public class Appointments {
        
        
        public String appointment_id;
		public String appointment_time;
		public String appointment_created_time;
		public Decimal duration;
		public String age;
		public String gender;
		public String occupation;
		public String dob;
		public String patient_phone;
		public String appointment_patient_name;
		public String patient_email;
		public String notes;
		public String book_source;
		public String patient_id;
		public String slot_id;
		public String procedure_id;
		public String doctor_id;
		public String doctor_name;
		public String clinic_name;
		public String clinic_id;
		public String uhid;
		public String department_name;
		public String location_code;
		public String doctor_code;
		public String speciality_code;
		public Boolean e_prescription_enabled;
		public String procedure_name;
		public Decimal amount;
		public Decimal amount_after_discount;
		//public String refund_amount;
		//public Boolean prepaid;
		//public String currency;
		public Decimal discount;
		//public String payment_status;
		public String booking_status;
		//public String transaction_code;
		public String status;
		public Boolean checked_in;
		public Boolean checked_out;
		public String appt_original_time;
        
      
    }

    public class Data {
        
        public List<Appointments> appointments;
		public String start_datetime;
		public String end_datetime;
		public Integer total_pages;
		public Integer current_page;
		public Integer results_per_page;
        
        
    }

   
    
    public static PractoAppoinmentJSONParser parse(String json) {
		return (PractoAppoinmentJSONParser) System.JSON.deserialize(json, PractoAppoinmentJSONParser.class);
	}
}