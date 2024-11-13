import 'dart:convert';

import 'package:e_commerce_riverpod_and_backend/mainpages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'HomePage',
          style: GoogleFonts.aBeeZee(),
        ),
        actions: const [
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('error : ${snapshot.error}');
            } else {
              List<dynamic> data = snapshot.data as List<dynamic>;
              return ListView.builder(itemBuilder: (context, index) {
                var product = data[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(DetailPage(
                        product: product,
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [BoxShadow(blurRadius: 10)]),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: Image.network(product['image']),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Text(
                                      product['title'],
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.aBeeZee(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 160,
                                    child: Text(
                                      product['category'],
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.aBeeZee(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Text(
                                        'Ratings : ${product['rating']['rate']}',
                                        style: GoogleFonts.aBeeZee(),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
            }
          }),
    );
  }
}
