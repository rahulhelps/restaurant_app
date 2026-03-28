// import 'package:flutter/material.dart';
// import 'package:restaurant_app/presentation/screens/cart/cart_screen.dart';
// import 'package:restaurant_app/presentation/screens/home/home_screen.dart';
// import 'package:restaurant_app/presentation/screens/menu/menu_screen.dart';
// import 'package:restaurant_app/presentation/screens/profile/profile_screen.dart';
//
// class NavScreen extends StatefulWidget {
//   const NavScreen({super.key});
//
//   @override
//   State<NavScreen> createState() => _NavScreenState();
// }
//
// class _NavScreenState extends State<NavScreen> {
//   int currentIndex = 0;
//   List<Widget> screens = [
//     HomeScreen(),
//     MenuScreen(),
//     CartScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(index: currentIndex, children: screens),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: "Cart",
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:restaurant_app/presentation/screens/cart/cart_screen.dart';
import 'package:restaurant_app/presentation/screens/home/home_screen.dart';
import 'package:restaurant_app/presentation/screens/menu/menu_screen.dart';
import 'package:restaurant_app/presentation/screens/profile/profile_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const MenuScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        height: 80,
        margin: EdgeInsetsGeometry.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 25,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final bool isSelected = currentIndex == index;

            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isSelected ? _scaleAnimation.value : 1.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with bubble effect
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.green.shade100
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIcon(index),
                            size: isSelected ? 32 : 28,
                            color: isSelected ? Colors.green.shade700 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Label
                        AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.7,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            _getLabel(index),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.green.shade700 : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0: return Icons.home_rounded;
      case 1: return Icons.restaurant_menu_rounded;
      case 2: return Icons.shopping_cart_rounded;
      case 3: return Icons.person_rounded;
      default: return Icons.home_rounded;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0: return "Home";
      case 1: return "Menu";
      case 2: return "Cart";
      case 3: return "Profile";
      default: return "";
    }
  }
}