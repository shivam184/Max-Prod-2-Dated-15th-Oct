@istest
public class AcquireDistanceFromLocationTest {
    @isTest
    public static void runtest(){
        
        LocationCoordinate lc1=new LocationCoordinate(13.666666,25.666);
        
        LocationCoordinate lc2=new LocationCoordinate(20.666666,30.6666666);
        
        AcquireDistanceFromLocation.getDistance(lc1,lc2);
    }
}