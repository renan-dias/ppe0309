import 'package:flutter/material.dart';
import 'new_habit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> habits = [];
  int _currentCarouselIndex = 0;

  final List<String> images = [
    'assets/images/felicidade.png',
    'assets/images/tristeza.png',
    'assets/images/habit3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rastreador de Hábitos'),
      ),
      body: Column(
        children: [
          // Carrossel de imagens
          CarouselSlider(
            options: CarouselOptions(
              height: 180.0,
              autoPlay: true,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
            ),
            items: images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                        width: 1000,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          // Indicadores do carrossel
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => {},
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCarouselIndex == entry.key
                          ? Colors.green
                          : Colors.grey),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: habits.isEmpty
                ? const Center(child: Text('Nenhum hábito registrado.'))
                : ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(habits[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Hábito Concluído!'),
                                content: Lottie.asset('assets/lottie/success.json', width: 100, height: 100),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newHabit = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
          if (newHabit != null) {
            setState(() {
              habits.add(newHabit);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
