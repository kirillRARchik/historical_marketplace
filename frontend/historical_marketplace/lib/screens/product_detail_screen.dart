import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: [
          // Большое фото
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 230,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Image.network(
                  'https://steel-masters.ru/sites/default/files/styles/product_large/public/2019-11/ba4b3dffb9c1644606a0a55ee81bb674.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 20, left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 20, right: 18,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.green),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          // Цена и наличие
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('12 000 тг', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                Text('Нет в наличии', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          // Способ изготовления
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Способ изготовления', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 6, runSpacing: 4,
                  children: [
                    _Chip('Нержавейка (2 мм); Полировка; Бармица клёпаная'),
                    _Chip('Ст3 (2 мм); Матовая шлифовка'),
                    _Chip('Ст3 (2 мм); Матовая шлифовка; Бармица клёпаная'),
                  ],
                ),
                const SizedBox(height: 7),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(text: 'Тип шлема '),
                      TextSpan(text: 'бацинет', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text('Толщина стали 2мм', style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // Информация, отзывы
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Шлем рыцарский средневековый', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 25),
                    const SizedBox(width: 4),
                    const Text('4,5', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 3),
                    const Text('12 отзывов', style: TextStyle(color: Colors.black54)),
                    const SizedBox(width: 10),
                    // Миниатюры-отзывы
                    ...List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://steel-masters.ru/sites/default/files/styles/product_large/public/2019-11/ba4b3dffb9c1644606a0a55ee81bb674.jpg',
                            width: 42, height: 32, fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),
          // Задать вопрос продавцу
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              ),
              child: const Text('Задать вопрос продавцу', style: TextStyle(fontSize: 17)),
            ),
          ),
          const SizedBox(height: 18),
          // Рекомендации
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Text('Рекомендуем также', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              children: [
                _RecommendationCard(),
                _RecommendationCard(),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Добавить в корзину', style: TextStyle(fontSize: 17)),
              Text('Доставка до 31 февраля', style: TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

// Реализация чипов спецификаций
class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: Text(text, style: const TextStyle(color: Colors.green, fontSize: 13)),
    );
  }
}

// Рекомендация
class _RecommendationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              'https://steel-masters.ru/sites/default/files/styles/product_large/public/2019-11/ba4b3dffb9c1644606a0a55ee81bb674.jpg',
              height: 85,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 7, right: 7,
            child: Icon(Icons.favorite_border, color: Colors.green, size: 23),
          ),
        ],
      ),
    );
  }
}