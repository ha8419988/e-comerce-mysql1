import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.product});
  final dynamic product;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Page',
          style: GoogleFonts.aBeeZee(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.network(widget.product['image']),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 1),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 160,
                        child: Text(
                          widget.product['category'],
                          style:
                              GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Text(
                            'Ratings : ${widget.product['rating']['rate']}',
                            style: GoogleFonts.aBeeZee(),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 160,
                    child: Text(
                      widget.product['title'],
                      style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Descripton',
                    style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 160,
                    child: Text(
                      widget.product['description'],
                      style: GoogleFonts.aBeeZee(),
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
