import 'package:flutter/material.dart';

import '../../pages/auth_page.dart';

class FavoriteNotLogged extends StatelessWidget {
  const FavoriteNotLogged({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        title: const Text('Danh sách yêu thích'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bạn chưa đăng nhập!'),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthPage()));
                },
                child: const Text('Đăng nhập')),
          ],
        ),
      ),
    );
  }
}
