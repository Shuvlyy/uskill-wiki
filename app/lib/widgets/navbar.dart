import 'package:app/core/theme.dart';
import 'package:app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavbarItem {
  final String label;
  final String route;

  NavbarItem({
    required this.label,
    required this.route,
  });
}

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final List<NavbarItem> items;
  final double breakpoint;
  final double desktopHeight;
  final double mobileHeight;

  const Navbar({
    super.key,
    required this.items,
    this.breakpoint = 800,
    this.desktopHeight = 100,
    this.mobileHeight = 70,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < breakpoint;

    if (isMobile) {
      return AppBar(
        backgroundColor: AppTheme.whiteColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: mobileHeight,
        title: const Logo.app(height: 40, goHome: true),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.blackColor),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppTheme.fieldOutlineColor.withValues(alpha: 0.5),
            height: 1,
          ),
        ),
      );
    }

    return Container(
      height: desktopHeight,
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.fieldOutlineColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        spacing: 40,
        children: [
          const Logo.app(height: 60, goHome: true),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: items
                  .map((item) => _NavbarItemWidget(item: item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class NavbarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final List<NavbarItem> items;
  final double breakpoint;
  final double desktopHeight;
  final double mobileHeight;

  const NavbarWrapper({
    super.key,
    required this.items,
    this.breakpoint = 800,
    this.desktopHeight = 100,
    this.mobileHeight = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Navbar(
      items: items,
      breakpoint: breakpoint,
      desktopHeight: desktopHeight,
      mobileHeight: mobileHeight,
    );
  }

  @override
  Size get preferredSize {
    final data = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first,
    );
    final isMobile = data.size.width < breakpoint;
    return Size.fromHeight(isMobile ? mobileHeight : desktopHeight);
  }
}

class NavbarDrawer extends StatelessWidget {
  final List<NavbarItem> items;
  final Widget? logo;

  const NavbarDrawer({super.key, required this.items, this.logo});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.whiteColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: logo ?? const Logo.app(height: 60),
            ),
            const Divider(color: AppTheme.fieldOutlineColor, thickness: 1),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(
                  color: AppTheme.fieldOutlineColor,
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];

                  final currentRoute = GoRouterState.of(context).uri.path;
                  final isSelected = currentRoute == item.route ||
                      (item.route != '/' && currentRoute.startsWith(item.route));

                  return ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontFamily: AppTheme.titleFont,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.blackColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(item.route);
                    },
                    selected: isSelected,
                    selectedTileColor: AppTheme.primaryColor.withValues(
                      alpha: 0.05,
                    ),
                  );
                },
              ),
            ),
            Container(
              color: AppTheme.blackColor,
              padding: const EdgeInsets.symmetric(vertical: 24),
              width: double.infinity,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Logo.univWhite(width: 150),
                  Text(
                    '© 2026 U-Skill Wiki',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavbarItemWidget extends StatefulWidget {
  final NavbarItem item;

  const _NavbarItemWidget({required this.item});

  @override
  State<_NavbarItemWidget> createState() => _NavbarItemWidgetState();
}

class _NavbarItemWidgetState extends State<_NavbarItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    final isSelected = currentRoute == widget.item.route ||
        (widget.item.route != '/' && currentRoute.startsWith(widget.item.route));

    final Color textColor;
    final Color underlineColor;

    if (isSelected) {
      textColor = AppTheme.primaryColor;
      underlineColor = AppTheme.primaryColor;
    } else if (_isHovered) {
      textColor = AppTheme.primaryColor.withValues(alpha: .7);
      underlineColor = AppTheme.primaryColor.withValues(alpha: .7);
    } else {
      textColor = AppTheme.blackColor;
      underlineColor = AppTheme.primaryColor.withValues(alpha: 0);
    }

    const animationDuration = Duration(milliseconds: 100);
    const animationCurve = Curves.easeInOut;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.item.route),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              AnimatedDefaultTextStyle(
                duration: animationDuration,
                curve: animationCurve,
                style: TextStyle(
                  fontFamily: AppTheme.titleFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
                child: Text(
                  widget.item.label,
                ),
              ),
              AnimatedContainer(
                duration: animationDuration,
                curve: animationCurve,
                width: 26,
                height: 3,
                color: underlineColor
              ),
            ],
          ),
        ),
      ),
    );
  }
}
