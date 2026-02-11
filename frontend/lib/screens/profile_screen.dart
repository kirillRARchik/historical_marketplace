import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Аватар
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage('https://api.dicebear.com/7.x/bottts/svg?seed=profile'), // заглушка
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Войти',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, size: 28, color: Colors.grey),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, size: 28, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        children: [
          // Доставка статус
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              title: const Text('Доставлено', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 19)),
              subtitle: const Text('Почтовый пункт Адресатово', style: TextStyle(color: Colors.black54)),
              trailing: Container(
                width: 40, height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          // Основные секции
          _ProfileSection([
            _ProfileTile('Заказы', () {}),
            _ProfileTile('Возвраты', () {}),
            _ProfileTile('Купленные товары', () {}),
            _ProfileTile('Избранное', () {}),
          ]),

          _ProfileSection([
            _ProfileTile('Настройки', () {}),
            _ProfileTile('Способ оплаты', () {}),
            _ProfileTile('О приложении', () {}),
            _ProfileTile('Помощь', () {}),
          ]),

          _ProfileSection([
            _ProfileTile('Стать продавцом', () {}),
          ]),
          const SizedBox(height: 24),
        ],
      ),
      // BottomNavigationBar управляется MainNavigationScreen
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final List<Widget> children;
  const _ProfileSection(this.children);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _ProfileTile(this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
      trailing: const Icon(Icons.chevron_right, color: Colors.green, size: 24),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      horizontalTitleGap: 2,
    );
  }
}
