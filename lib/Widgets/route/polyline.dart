import 'dart:convert';
import 'package:http/http.dart' as http;

class PolylinePoints {
  NetworkUtil util = NetworkUtil();

  /// Get the list of coordinates between two geographical positions
  /// which can be used to draw polyline between this two positions
  ///
  Future<List<PointLatLng>> getRouteBetweenCoordinates(
      String googleApiKey,
      double originLat,
      double originLong,
      double destLat,
      double destLong,
      String mode) async {
    return await util.getRouteBetweenCoordinates(
        googleApiKey, originLat, originLong, destLat, destLong, mode);
  }

  /// Decode and encoded google polyline
  /// e.g "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
  ///
  List<PointLatLng> decodePolyline(String encodedString) {
    return util.decodeEncodedPolyline(encodedString);
  }
}

class NetworkUtil
{

  ///Get the encoded string from google directions api
  ///
  Future<List<PointLatLng>> getRouteBetweenCoordinates(String googleApiKey, double originLat, double originLong,
      double destLat, double destLong, String mode)async
  {
    List<PointLatLng> polylinePoints = [];
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=" +
        originLat.toString() +
        "," +
        originLong.toString() +
        "&destination=" +
        destLat.toString() +
        "," +
        destLong.toString() +
        //auto = driving, fahrrad =bicycling, laufen= walking, öffentl. Verkehrsmittel = transit
        "&mode=$mode" +
        "&key=$googleApiKey";
    var response = await http.get(url);
    try {
      if (response?.statusCode == 200) {
        polylinePoints = decodeEncodedPolyline(json.decode(
            response.body)["routes"][0]["overview_polyline"]["points"]);
      }
    } catch (error) {
      throw Exception(error.toString());
    }
    return polylinePoints;
  }


  ///decode the google encoded string using Encoded Polyline Algorithm Format
  /// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  ///
  ///return [List]
  List<PointLatLng> decodeEncodedPolyline(String encoded)
  {
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      PointLatLng p = new PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}

class PointLatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  const PointLatLng(double latitude, double longitude)
      : assert(latitude != null),
        assert(longitude != null),
        this.latitude = latitude,
        this.longitude = longitude;

  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees
  final double longitude;

  @override
  String toString() {
    return "lat: $latitude / longitude: $longitude";
  }
}
