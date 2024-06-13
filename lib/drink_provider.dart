import 'package:flutter/foundation.dart';

class Drink {
  final String title;
  final String description;
  final String price;
  final String image;

  Drink({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });
}

class DrinkProvider with ChangeNotifier {
  List<Drink> _drinks = [
    Drink(
      title: 'Caipirinha',
      description: 'A melhor caipirinha já provada em todo esse Brasil',
      price: 'R\$ 15,00',
      image: 'assets/images/caipirinha.jpg',
    ),
    Drink(
      title: 'Cerveja',
      description: 'As melhores cervejas você encontra aqui',
      price: 'R\$ 7,00',
      image: 'assets/images/cerveja.jpg',
    ),
    Drink(
      title: 'Vinho',
      description: 'Vinho tinto de ótima qualidade e de uma excelente safra.',
      price: 'R\$ 20,00',
      image: 'assets/images/Vinhotinto.jpg',
    ),
    Drink(
      title: 'Coca Cola',
      description: '',
      price: 'R\$ 8,00',
      image: 'assets/images/cocacola.jpeg',
    ),
    Drink(
      title: 'Água',
      description: '',
      price: 'R\$ 5,00',
      image: 'assets/images/agua.png',
    ),
  ];

  List<Drink> get drinks => _drinks;

  void addDrink(Drink drink) {
    _drinks.add(drink);
    notifyListeners();
  }
}