public class DistanceDestinationResponceParser {
	public cls_rows[] rows;
	public String status;	
    
	public class cls_rows {
		public cls_elements[] elements;
	}
	public class cls_elements {
		public cls_distance distance;
		public cls_duration duration;
		public String status;	
	}
	public class cls_distance {
		public String text;	
		public Integer value;	
	}
	public class cls_duration {
		public String text;	
		public Integer value;	
	}
	public static DistanceDestinationResponceParser parse(String json){
		return (DistanceDestinationResponceParser) System.JSON.deserialize(json, DistanceDestinationResponceParser.class);
	}

}