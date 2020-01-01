
import 'package:sightseeing/Widgets/route/points.dart';
 
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;
import 'package:sightseeing/Helper/settingMarkers.dart' as getData;
import 'dart:math';  
  
  calculateRoute(int newTour, List list ) async {
    print(list);
    List<dynamic> objects = [];
    for (int i = 0; i < list.length; i++) {
      objects.add(getData.data[int.parse(list[i])]);
    }

    List myLocationCoor =   [
      global.currenlocation['latitude'],
      global.currenlocation['longitude']
    ];

    do {
      int goTo = calculateDistance(objects, myLocationCoor);

      if (newTour == 0) {
           await getPoints(0, myLocationCoor[0], myLocationCoor[1],
             objects[goTo]['coordinates'][0], objects[goTo]['coordinates'][1],global.mode);
      } else {
 
           await getPoints(1, myLocationCoor[0], myLocationCoor[1],
               objects[goTo]['coordinates'][0], objects[goTo]['coordinates'][1],global.mode);
        newTour = 0;
      }

      myLocationCoor = [
        objects[goTo]['coordinates'][0],
        objects[goTo]['coordinates'][1]
      ];

      var remove = objects[goTo];
      objects.remove(remove);
    } while (objects.length != 0);
  }

  calculateDistance(List objects, List myLocationCoor) {
    List<double> distanceList = [];

    objects.forEach((obj) {
      double x = 71.5 * (obj['coordinates'][1] - myLocationCoor[1]).abs();
      double y = 111.3 *(obj['coordinates'][0] - myLocationCoor[0]).abs();
      double distance = sqrt(x*x + y*y) ;
      distanceList.add(distance);
    });

    double minimum = distanceList.reduce(min);
    return distanceList.indexOf(minimum);
  }