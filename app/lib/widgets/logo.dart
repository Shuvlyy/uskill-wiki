import 'package:flutter/material.dart';

enum _LogoVariant { app, univWhite, univBlack }

class Logo extends StatelessWidget {
  final _LogoVariant _variant;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const Logo.app({super.key, this.width, this.height, this.fit})
    : _variant = .app;

  const Logo.univWhite({super.key, this.width, this.height, this.fit})
    : _variant = .univWhite;

  const Logo.univBlack({super.key, this.width, this.height, this.fit})
    : _variant = .univBlack;

  String get _assetPath {
    switch (_variant) {
      case _LogoVariant.app:
        return 'assets/logos/Logotype_U-Skill-Wiki_noir-72dpi.png';
      case _LogoVariant.univWhite:
        return 'assets/logos/Logotype_Nantes-U_blanc-72dpi.png';
      case _LogoVariant.univBlack:
        return 'assets/logos/Logotype_Nantes-U_noir-72dpi.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _assetPath,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
    );
  }
}
