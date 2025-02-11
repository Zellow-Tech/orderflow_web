import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: // the view for desktop/web
          Row(
        children: [
          // Expanded division for the drawer and main content area

          // the main drawer
          Expanded(
            flex: 1,
            child: Drawer(),
          ),

          // the main content area
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  // the first row structure for Page name,
                  // search bar, create a portfolio button
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // the page title
                        Row(
                          children: [
                            Icon(
                              Icons.folder,
                              color: Colors.grey[300],
                            ),
                            Text(
                              '  Dashboard',
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  fontSize: height * 0.016,
                                  color: Colors.black),
                            ),
                          ],
                        ),

                        SizedBox(width: width * 0.55),

                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              label: Text(
                                'Share',
                                style: TextStyle(color: Colors.black),
                              ),
                              icon: Icon(
                                Icons.link,
                                color: Colors.black,
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          6)), // Make the button rectangular
                                ), // Set black background
                              ),
                              label: Text(
                                'Create',
                                style: TextStyle(
                                    color: Colors.white), // Set white text
                              ),
                              icon: Icon(
                                Icons.add,
                                color: Colors.white, // Set white icon
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 4),
                      ],
                    ),
                  ),

                  // the overview tab
                  // shows the customers, income, and performance overall
                  Container(
                    height: height * 0.125,
                    margin: EdgeInsets.all(
                      10,
                    ),
                    decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        // The text for Overvirew
                        Text(
                          'Overview',
                          style: GoogleFonts.roboto(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),

                  // The portfolios section
                  // shows the portfolios created by the firm
                  Text(
                    'Portfolios',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  // the row showing portfolios created and managed by the company
                  SizedBox(
                    height: height * 0.2,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Container(
                          width: width * 0.15,
                          height: height,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text('index $index'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
