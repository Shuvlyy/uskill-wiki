import 'package:app/core/theme.dart';
import 'package:app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NavbarItem {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  NavbarItem({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });
}

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final List<NavbarItem> items;
  final Widget? logo;
  final double breakpoint;
  final double desktopHeight;
  final double mobileHeight;

  const Navbar({
    super.key,
    required this.items,
    this.logo,
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
        title: logo ?? const Logo.app(height: 40),
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
        children: [
          logo ?? const Logo.app(height: 60),
          const Gap(40),
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
  final Widget? logo;
  final double breakpoint;
  final double desktopHeight;
  final double mobileHeight;

  const NavbarWrapper({
    super.key,
    required this.items,
    this.logo,
    this.breakpoint = 800,
    this.desktopHeight = 100,
    this.mobileHeight = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Navbar(
      items: items,
      logo: logo,
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
                        color: item.isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.blackColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      item.onTap();
                    },
                    selected: item.isSelected,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.whiteColor.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppTheme.whiteColor.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
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
    final isSelected = widget.item.isSelected;

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
      underlineColor = Colors.transparent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.item.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.label,
                style: TextStyle(
                  fontFamily: AppTheme.titleFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const Gap(4),
              Container(width: 26, height: 3, color: underlineColor),
            ],
          ),
        ),
      ),
    );
  }
}
