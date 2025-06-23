import 'dart:convert';

import 'package:api_intrigation/utils/url.dart';

import 'models/productModel.dart';
import 'package:http/http.dart' as http;

class ProductController {
  List<Data> products = [];

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(Urls.readProduct));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      productModel model = productModel.fromJson(data);
      products = model.data ?? [];
    }
  }

  Future<bool> createUpdateProducts(
    String productName,
    String img,
    int qty,
    int unitPrice,
    int totalPrice,
    String? productId,
    bool isUpdate,
  ) async {
    final response = await http.post(
      Uri.parse(isUpdate ? Urls.updateProduct(productId!) : Urls.createProduct),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "ProductName": productName,
        "ProductCode": DateTime.now().microsecondsSinceEpoch,
        "Img": img,
        "Qty": qty,
        "UnitPrice": unitPrice,
        "TotalPrice": totalPrice,
      }),
    );
    // print(response.statusCode);
    if (response.statusCode == 201 ) {
      fetchProducts();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProducts(String productId) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(productId)));
    print(response.statusCode);
    if (response.statusCode == 200) {
      fetchProducts();
      return true;
    } else {
      return false;
    }
  }
}
