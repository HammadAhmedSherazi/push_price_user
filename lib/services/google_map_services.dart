
import 'package:push_price_user/export_all.dart';

import '../models/place_detail_model.dart';
import '../models/place_listing_model.dart';

class GoogleMapServices {
  GoogleMapServices._();

  static final GoogleMapServices _singleton = GoogleMapServices._();

  static GoogleMapServices get googleMapServiceInstance => _singleton;
  Future<PlaceListingModel?> getPlaceListing(String input) async {
    try {
      var jsonData = await MyHttpClient.instance.get(
        "${ApiEndpoints.googleMapApi}place/autocomplete/json",
        params: {
          "input":input,
          "key": "AIzaSyBTalnRBkhFW6a81Wn17xDZZI8dDjcDJzA",

        },
        isCustomUrl: true,
        isToken: false,

    );

    PlaceListingModel result = PlaceListingModel.fromJson(jsonData);

    return result;
    } catch (e) {
     return null;
    }
  }

  Future<PlaceDetailModel?> getPlaceDetails(String placeId) async {
    try {
        var jsonData = await MyHttpClient.instance.get(
        "${ApiEndpoints.googleMapApi}place/details/json",
        params: {
          "place_id" :placeId,
           "key": "AIzaSyBTalnRBkhFW6a81Wn17xDZZI8dDjcDJzA",

        },
        isCustomUrl: true,
        isToken: false,

      );

      PlaceDetailModel result = PlaceDetailModel.fromJson(jsonData);

      return result;
    } catch (e) {
      return null;
    }

  }

  

}
