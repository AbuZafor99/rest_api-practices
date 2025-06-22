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

  @override
  void initState() {
    super.initState();
    fetchAndSetProducts();
  }

  void fetchAndSetProducts() async {
    await productController.fetchProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void productDialog() {
      TextEditingController productNameController = TextEditingController();
      TextEditingController productQTYController = TextEditingController();
      TextEditingController productImageController = TextEditingController();
      TextEditingController productUnitPriceController =
          TextEditingController();
      TextEditingController productTotalPriceController =
          TextEditingController();

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Add Product"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "product name"),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "product image"),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "product quantity"),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "product unit price",
                    ),
                  ),
                  TextField(
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
                        onPressed: () {},
                        child: Text("Add Product"),
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
          var product=productController.products[index];
          return ProductCard(
            onEdit: () {
              productDialog();
            },
            onDelete: () {
              productController.DeleteProducts(product.sId.toString()).then((value) async {
                if(value){
                  await productController.fetchProducts();
                  setState(() {
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Product deleted."),
                      duration: Duration(seconds: 2),),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Something went wrong.",style: TextStyle(
                      color: Colors.red
                    ),),
                      duration: Duration(seconds: 2),),
                  );
                }
              });
            },
            product: product,
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => productDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
