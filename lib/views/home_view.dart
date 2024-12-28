// import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stock_reconcile/controller/recon_controller.dart';

import 'package:stock_reconcile/utils/authentication_manager.dart';
import 'package:stock_reconcile/views/recon_entry.dart';
// Ensure you import the model

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ReconController reconController = Get.put(ReconController());
  // Removed reconListController since it is not used here

  @override
  Widget build(BuildContext context) {
    AuthenticationManager _authManager = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Norden Communication Middle East FZE',
          style: TextStyle(
            fontSize: 17, // Set the text size here
          ),
        ),
        backgroundColor: Color.fromARGB(255, 189, 15, 15),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              _authManager.logOut();
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Obx(() {
        return reconController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  await reconController.fetchRecon();
                },
                child: ListView.builder(
                  itemCount: reconController.reconList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      elevation: 4.0, // Add a shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        onTap: () {
                          // Pass the entire ReconModel to the next screen
                          Get.to(() => ReconEntry(),
                              arguments: reconController.reconList[index]);
                        },
                        title: Text(
                          reconController.reconList[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('dd-MM-yyyy').format(
                            DateTime.parse(reconController
                                .reconList[index].creation
                                .toString()),
                          ),
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
      }),
    );
  }
}
