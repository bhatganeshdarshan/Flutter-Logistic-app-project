import 'active_nearby_driver.dart';

class GeoFireAssistant{
  static List<ActiveNearByAvailableDrivers> activeNearByAvailableDriversList=[];
  static void deleteOffLineDriverFromList(String driverId){
    int indexNumber =activeNearByAvailableDriversList.indexWhere((element) => element.driverId==driverId);
    activeNearByAvailableDriversList.removeAt(indexNumber);
  }

  static void updateActiveNearByAvailableDriverLocation(ActiveNearByAvailableDrivers driverWhoMove){
    int indexNumber =activeNearByAvailableDriversList.indexWhere((element) => element.driverId==driverWhoMove.driverId);

    activeNearByAvailableDriversList[indexNumber].locationLatitude=driverWhoMove.locationLatitude;
    activeNearByAvailableDriversList[indexNumber].locationLongitude=driverWhoMove.locationLongitude;
  }
}

