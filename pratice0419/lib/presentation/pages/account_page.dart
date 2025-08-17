import 'package:pratice0419/presentation/presentation.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: const Text('這是帳號資訊頁面'),
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const BottomBar(currentIndex: 2),
    );
  }
}
