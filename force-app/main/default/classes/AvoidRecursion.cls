public Class AvoidRecursion{
    
    public static boolean firstRun = true;
        public static boolean isFirstRun(){
        if(firstRun){
          firstRun = false;
          return true;
        }else{
            return firstRun;
        }
    }
}