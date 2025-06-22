import 'dart:ffi';

import 'package:api_intrigation/productController.dart';
import 'package:api_intrigation/widget/productCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Module13 extends StatefulWidget {
  const Module13({super.key});

  @override
  State<Module13> createState() => _Module13State();
}

class _Module13State extends State<Module13> {
  final ProductController productController = ProductController();

  Future<void> fetchData()async{
    await productController.fetchProducts();
    print(productController.products.length);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchAndSetProducts() async {
    await productController.fetchProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void productDialog({String?id,String? name, String? img,int?qty, int? unitPrice, int? totalPrice ,required bool isUpdate}) {
      TextEditingController productNameController = TextEditingController();
      TextEditingController productQTYController = TextEditingController();
      TextEditingController productImageController = TextEditingController();
      TextEditingController productUnitPriceController =
          TextEditingController();
      TextEditingController productTotalPriceController =
          TextEditingController();

      productNameController.text= name??"";
      productImageController.text= img??"";
      productQTYController.text= qty !=null ? qty.toString():"0";
      productUnitPriceController.text= unitPrice !=null ? unitPrice.toString():"0";
      productTotalPriceController.text= totalPrice !=null ? totalPrice.toString():"0";


      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(isUpdate? "Edit Product":"Add Product"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: productNameController,
                    decoration: InputDecoration(labelText: "product name"),
                  ),
                  TextField(
                    controller: productImageController,
                    decoration: InputDecoration(labelText: "product image"),
                  ),
                  TextField(
                    controller: productQTYController,
                    decoration: InputDecoration(labelText: "product quantity"),
                  ),
                  TextField(
                    controller: productUnitPriceController,
                    decoration: InputDecoration(
                      labelText: "product unit price",
                    ),
                  ),
                  TextField(
                    controller: productTotalPriceController,
                    decoration: InputDecoration(
                      labelText: "product total price",
                    ),
                  ),

                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade400,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () async {
                            productController.CreateUpdateProducts(
                              productNameController.text,
                              productImageController.text,
                              int.parse(productQTYController.text.trim()),
                              int.parse(productUnitPriceController.text.trim()),
                              int.parse(productTotalPriceController.text.trim()),
                                id!,
                              isUpdate,
                            );
                            Navigator.pop(context);
                            fetchData();
                            setState(() {

                            });
                          },
                        child: Text(isUpdate ? "Update Product":"Add Product"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade200,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Products CRUD"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.6,
        ),
        itemCount: productController.products.length,
        itemBuilder: (context, index) {
          var product = productController.products[index];
          return ProductCard(
            onEdit: () {
              productDialog(name:product.productName, img:product.img, id:product.sId ,unitPrice: product.unitPrice,totalPrice:product.totalPrice, qty:product.qty,isUpdate: true);
            },
            onDelete: () {
              productController.DeleteProducts(product.sId.toString()).then((
                value,
              ) async {
                if (value) {
                  await productController.fetchProducts();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Product deleted."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Something went wrong.",
                        style: TextStyle(color: Colors.red),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              });
            },
            product: product,
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => productDialog(isUpdate: false),
        child: Icon(Icons.add),
      ),
    );
  }
}
