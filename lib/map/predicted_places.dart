

class PredictedPlaces{
  String? place_id;
  String? main_text;
  String? secondary_text;


  PredictedPlaces({this.place_id,this.main_text,this.secondary_text});

  PredictedPlaces.fromJson(Map<String, dynamic> jsonData) {

      place_id= jsonData["place_id"];
      main_text= jsonData["structured_formatting"]["main_text"];
      secondary_text= jsonData["structured_formatting"]["secondary_text"] ;

  }

  Map<String, dynamic> toJson() => {
    "place_id": place_id == null ? null : place_id,
    "main_text": main_text == null ? null : main_text,
    "secondary_text": secondary_text == null ? null : secondary_text,
  };
}