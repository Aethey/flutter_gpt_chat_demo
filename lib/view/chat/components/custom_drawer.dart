import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 120,
            child: DrawerHeader(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/artificial_intelligence.png',
                    width: 48, // Image width
                    height: 48, // Image height
                    fit: BoxFit.cover, // Cover fit
                  ),
                  Text(
                    'Your Conversations',
                    style: GoogleFonts.oswald(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          letterSpacing: .5),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue, // Solid color
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey], // Gradient
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return _buildConversionItem();
                  })),
          Container(
            height: 200,
          )
          // Add more list tiles for more users
        ],
      ),
    );
  }

  Widget _buildConversionItem({String userID = "User1"}) {
    return ListTile(
      title: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.ac_unit),
            const SizedBox(width: 4), // Add space between items
            Text(userID),
            const SizedBox(width: 12), // Add space between items
            Expanded(
              child: Text(
                'this is a test that is quite long and should be truncated at some point...',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print(userID);
      },
    );
  }
}
