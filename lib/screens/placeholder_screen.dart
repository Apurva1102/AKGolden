import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height:  60.h,
            child: ClipPath(
              clipper: CurveClipper(),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffF2ECE6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: Image.asset(
                        'assets/images/iPhone1.png',
                        // fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.lexend(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  color: Colors.black,
                ),
                children: const [
                  TextSpan(text: "Bookmark Your \n"),
                  TextSpan(
                    text: "Bakery Favourites",
                    style: TextStyle(color: Color(0xff7B3F00)),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "Nisi do sunt veniam esse quis ex labore Lorem et. Excepteur labore minim ea ea ",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 150);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 130,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
