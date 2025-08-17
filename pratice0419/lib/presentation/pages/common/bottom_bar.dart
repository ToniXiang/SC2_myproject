import 'package:pratice0419/presentation/presentation.dart';

class BottomBar extends StatefulWidget {
  final int currentIndex;
  const BottomBar({super.key, this.currentIndex = 0});

  @override
  State<BottomBar> createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  late int selectedPageIndex;
  @override
  void initState() {
    super.initState();
    selectedPageIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedPageIndex,
      selectedLabelStyle: const TextStyle(fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '購物車'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '個人資料'),
      ],
      onTap: (index) {
        setState(() {
          selectedPageIndex = index;
        });
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryPage()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AccountPage()),
            );
            break;
        }
      },
    );
  }
}
