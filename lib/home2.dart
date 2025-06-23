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

  Future<void> fetchData() async {
    await productController.fetchProducts();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void productDialog({
    String? id,
    String? name,
    String? img,
    int? qty,
    int? unitPrice,
    int? totalPrice,
    required bool isUpdate,
  }) {
    TextEditingController productNameController = TextEditingController();
    TextEditingController productQTYController = TextEditingController();
    TextEditingController productImageController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();

    productNameController.text = name ?? '';
    productImageController.text = img ?? '';
    productQTYController.text = qty != null ? qty.toString() : '0';
    productUnitPriceController.text =
        unitPrice != null ? unitPrice.toString() : '0';
    productTotalPriceController.text =
        totalPrice != null ? totalPrice.toString() : '0';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isUpdate ? 'Edit product' : 'Add product'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: productNameController,
                  decoration: InputDecoration(labelText: 'Product name'),
                ),
                TextField(
                  controller: productImageController,
                  decoration: InputDecoration(labelText: 'Product image'),
                ),
                TextField(
                  controller: productQTYController,
                  decoration: InputDecoration(labelText: 'Product qty'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: productUnitPriceController,
                  decoration: InputDecoration(labelText: 'Product unit price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: productTotalPriceController,
                  decoration: InputDecoration(labelText: 'Total price'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () async {
                        bool result = await productController
                            .createUpdateProducts(
                              productNameController.text,
                              productImageController.text,
                              int.tryParse(productQTYController.text.trim()) ??
                                  0,
                              int.tryParse(
                                    productUnitPriceController.text.trim(),
                                  ) ??
                                  0,
                              int.tryParse(
                                    productTotalPriceController.text.trim(),
                                  ) ??
                                  0,
                              id,
                              isUpdate,
                            );
                        if (result) {
                          await fetchData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isUpdate
                                    ? 'Product updated'
                                    : 'Product created',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Something went wrong...!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Text(isUpdate ? 'Update Product' : 'Add product'),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product CRUD'),
        backgroundColor: Colors.blueAccent,
        centerTitle: false,
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
              productDialog(
                name: product.productName,
                img: product.img,
                id: product.sId,
                unitPrice: product.unitPrice,
                totalPrice: product.totalPrice,
                qty: product.qty,
                isUpdate: true,
              );
            },
            onDelete: () async {
              bool result = await productController.deleteProducts(
                product.sId.toString(),
              );
              if (result) {
                await fetchData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Something went wrong...!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
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
