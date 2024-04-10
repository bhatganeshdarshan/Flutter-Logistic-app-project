import 'dart:convert';

import 'dart:convert';
import 'package:http/http.dart ' as http;


class RequestMethod{
  static Future<dynamic> receiveRequest(String url) async{
    http.Response httpRespose =await http.get(Uri.parse(url));

    try {
       if(httpRespose.statusCode ==200) //succesfull
         {
           String reponseData =httpRespose.body;
           var decodeResponseData =jsonDecode(reponseData);
           return decodeResponseData;
       }else{
         return "Error Occurred.Failed.No Response.";
       }
    }catch(exp){
      return "Error Occurred.Failed.No Response.";
    }


  }
}