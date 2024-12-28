import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_reconcile/controller/login_controller.dart';
import 'package:stock_reconcile/controller/recon_controller.dart';
import 'package:stock_reconcile/login/view/loginpage.dart';
import 'package:stock_reconcile/model/recon_list_model.dart';
import 'package:stock_reconcile/utils/authentication_manager.dart';
import 'package:stock_reconcile/views/home_view.dart';
import 'package:stock_reconcile/views/login/login_view.dart';

class ReconEntry extends StatelessWidget {
  final ReconController recon = Get.put(ReconController());
  final TextEditingController warehouse = TextEditingController();
  final TextEditingController itemCode = TextEditingController();
  final TextEditingController physicalQty = TextEditingController();
  final TextEditingController reenterQty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ReconModel reconModel = Get.arguments;
    AuthenticationManager _authManager = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Norden Communication Middle East FZE',
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: const Color.fromARGB(255, 189, 15, 15),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              _authManager.logOut();
              Get.to(() => const LoginView());
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            // Card for scanning warehouse and item
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Column(
                      children: <Widget>[
                        TextFormField(
                          controller:
                              TextEditingController(text: reconModel.name),
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the field
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, // Makes the text bold
                            fontSize: 16.0, // Adjust the font size if needed
                          ), // Aligns the text to the center
                          readOnly:
                              true, // Set to  // Set to true to prevent editing
                        ),
                        TextFormField(
                          controller:
                              TextEditingController(text: "Main Stores - NCME"),
                          decoration:
                              const InputDecoration(labelText: 'Warehouse'),
                          readOnly: true, // Set to true to prevent editing
                        ),
                        TextFormField(
                          onEditingComplete: () {
                            recon.scanBarcode('warehouse', warehouse.text);
                            recon.warehouse.value = warehouse.text;
                            recon.update();
                          },
                          controller: warehouse,
                          decoration: InputDecoration(
                            labelText: 'Scan Rack',
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (recon.warehouse.value != '')
                                  if (recon.is_valid_warehouse.value)
                                    const Icon(
                                      Icons.check_outlined,
                                      color: Colors.green,
                                    )
                                  else
                                    const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                GetBuilder<ReconController>(
                                  init: ReconController(),
                                  builder: (recon) {
                                    return IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        warehouse.clear();
                                        recon.warehouse.value = '';
                                        recon.is_valid_warehouse.value = false;
                                        recon.update();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (recon.warehouse.value != '' &&
                            recon.is_valid_warehouse.value)
                          TextFormField(
                            onEditingComplete: () {
                              recon.scanBarcode('item', itemCode.text);
                              recon.item_code.value = itemCode.text;
                              recon.update();
                            },
                            controller: itemCode,
                            decoration: InputDecoration(
                              labelText: 'Scan Item',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (recon.item_code.value != '')
                                    if (recon.is_valid_item.value)
                                      const Icon(
                                        Icons.check_outlined,
                                        color: Colors.green,
                                      )
                                    else
                                      const Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red,
                                      ),
                                  IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      itemCode.clear();
                                      recon.item_code.value = '';
                                      recon.is_valid_item.value = false;
                                      recon.update();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )),
              ),
            ),

            const SizedBox(height: 16.0), // Space between cards

            // Card for quantity inputs and buttons
            Obx(() {
              if (recon.is_valid_warehouse.value && recon.is_valid_item.value) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            recon.itemName.value.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 189, 15, 15),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: ListTile(
                            leading: const Text('Stock Qty'),
                            title: TextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: recon.stockQty.value.toString(),
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text('Qty'),
                          title: TextFormField(
                            controller: physicalQty,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        ListTile(
                          leading: const Text('Re-Enter Qty'),
                          title: TextFormField(
                            controller: reenterQty,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Obx(() {
                              if (recon.isSubmitClicked.value) {
                                return const SizedBox.shrink(); // Hide button
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  double? physicalQtyValue =
                                      double.tryParse(physicalQty.text);
                                  double? reenterQtyValue =
                                      double.tryParse(reenterQty.text);
                                  if (physicalQtyValue == null ||
                                      reenterQtyValue == null) {
                                    // Show error if one or both quantities are not valid numbers
                                    Get.snackbar(
                                      'Error',
                                      'Please enter valid qty',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else if (physicalQtyValue !=
                                      reenterQtyValue) {
                                    // Show error if quantities do not match
                                    Get.snackbar(
                                      'Error',
                                      'Qty and Re-Enter Qty do not match',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    // Proceed with submission if they are valid and match
                                    recon.updatePhysicalQty(
                                        recon.warehouse.value,
                                        recon.item_code.value,
                                        recon.stockQty.value,
                                        physicalQtyValue,
                                        reconModel.name);
                                    Get.to(ReconEntry());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 32,
                                      139, 226), // Button background color
                                  foregroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius
                                        .zero, // Makes the button rectangular
                                  ), // Button text (foreground) color
                                ),
                                child: const Text('Submit'),
                              );
                            }),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(() => const HomeView());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 32,
                                    139, 226), // Button background color
                                foregroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius
                                      .zero, // Makes the button rectangular
                                ), // Button text (foreground) color
                              ),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        // Display the message below the button
                        Obx(() => Text(
                              recon.message.value,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 56, 131, 59),
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox
                    .shrink(); // Return an empty widget if conditions are not met
              }
            }),
          ],
        ),
      ),
    );
  }
}