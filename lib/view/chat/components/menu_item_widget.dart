import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final String iconPath;
  final VoidCallback onItemClick;
  final String title;

  const MenuItemWidget({
    super.key,
    required this.iconPath,
    required this.onItemClick,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // https://flutter.salon/flutter/deferfirstframe-precacheimage/
    // precacheImage(AssetImage(iconPath), context);
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            height: 24,
            child: GestureDetector(
              onTap: onItemClick,
              child: SizedBox(
                height: 10,
                width: 30,
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain, // Cover fit
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
