import 'dart:convert';

import 'package:api_intrigation/utils/url.dart';

import 'models/productModel.dart';
import 'package:http/http.dart'as http;
class ProductController{
  List<Data>products=[];

  Future<void> fetchProducts() async{
    final response= await http.get(Uri.parse(Urls.readProduct));
    
    print(response.statusCode);

    if(response.statusCode==200){
      final data= jsonDecode(response.body);
      ProductModel model=ProductModel.fromJson(data);
      products=model.data?? [] ;
    }
  }
}