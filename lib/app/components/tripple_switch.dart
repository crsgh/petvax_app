import 'package:flutter/material.dart';

class TripleSwitchMenuScreen extends StatefulWidget {
  const TripleSwitchMenuScreen({super.key});

  @override
  State<TripleSwitchMenuScreen> createState() => _TripleSwitchMenuScreenState();
}

class _TripleSwitchMenuScreenState extends State<TripleSwitchMenuScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  static const List<Map<String, String>> _menuContent = [
    {
      'title': 'Grooming',
      'text':
          "You've selected the first menu option. This triple switch design provides an elegant way to navigate between different sections or categories.",
    },
    {
      'title': 'Vaccine',
      'text':
          'Welcome to the second menu section. The smooth sliding animation and glassmorphism effects create a premium user experience.',
    },
    {
      'title': 'De-worming',
      'text':
          "You're now viewing the third menu option. This switch-like interface is perfect for toggles, tabs, or category selections.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double switchHeight = 52;
    final double switchPadding = 4;
    final double switchRadius = 50;
    final double indicatorRadius = 8;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth =
              constraints.maxWidth < 400 ? constraints.maxWidth : 400;
          return SizedBox(
            width: maxWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Switch Bar
                Container(
                  height: switchHeight,
                  padding: EdgeInsets.all(switchPadding),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a1b),
                    borderRadius: BorderRadius.circular(switchRadius),
                    border: Border.all(
                      color: const Color(0xFF2d2d30),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.05),
                        blurRadius: 0,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Animated Indicator
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOutCubic,
                        left:
                            _selectedIndex * (maxWidth - switchPadding * 2) / 3,
                        top: 0,
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: (maxWidth - switchPadding * 2) / 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(
                                _selectedIndex == 0
                                    ? switchRadius
                                    : indicatorRadius,
                              ),
                              right: Radius.circular(
                                _selectedIndex == 2
                                    ? switchRadius
                                    : indicatorRadius,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Menu Items
                      Row(
                        children: List.generate(3, (index) {
                          final isActive = _selectedIndex == index;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedIndex = index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.easeOut,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isActive
                                          ? Colors.transparent
                                          : Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(
                                    switchRadius,
                                  ),
                                ),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: TextStyle(
                                      color:
                                          isActive
                                              ? const Color(0xFF1a1a1b)
                                              : (_selectedIndex != index
                                                  ? const Color(0xFFA1A1A6)
                                                  : Colors.white),
                                      fontWeight:
                                          isActive
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: -0.02,
                                    ),
                                    child: Text('Menu ${index + 1}'),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Content Area
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.12),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                  child: Column(
                    key: ValueKey(_selectedIndex),
                    children: [
                      Text(
                        _menuContent[_selectedIndex]['title']!,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.02,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _menuContent[_selectedIndex]['text']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFA1A1A6),
                          height: 1.6,
                          letterSpacing: -0.01,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
