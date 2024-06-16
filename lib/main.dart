import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'api.dart';
import 'models.dart';
import 'utils.dart';
import 'banco_sembast.dart';
import 'api.dart';
import 'cart_model.dart';
import 'drink_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/controller/generative_controller.dart';
import 'package:hello_world/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().open();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DrinkProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardápio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 5,
          indicatorColor: Colors.white,
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold);
            }
            return const TextStyle(color: Colors.black);
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.redAccent, opacity: 1);
            }
            return const IconThemeData(color: Colors.black, opacity: 0.4);
          }),
        ),
        chipTheme: ChipThemeData(
          disabledColor: Colors.white,
          selectedColor: Colors.white,
          secondarySelectedColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              width: 0.5,
            ),
          ),
        ),
        textTheme: TextTheme(
          headlineMedium: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          color: Colors.white,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<Food>> futureFoods;
  // Este valor pode ser obtido de uma variável específica ou banco de dados
  final UnsplashService unsplashService = UnsplashService();

  @override
  void initState() {
    super.initState();
    futureFoods =
        DatabaseHelper().foods(); // Buscar alimentos do banco de dados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardápio de comidas'),
      ),
      body: FutureBuilder<List<Food>>(
        future: futureFoods,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No foods available'));
          } else {
            // Pegar apenas os primeiros 3 itens
            final foods = snapshot.data!.take(3).toList();

            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                String searchTerm = '${food.name}';
                return FutureBuilder<List<String>>(
                  future: unsplashService.fetchImages(searchTerm),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (imageSnapshot.hasError) {
                      return Center(child: Text('Error loading image'));
                    } else if (!imageSnapshot.hasData ||
                        imageSnapshot.data!.isEmpty) {
                      return Center(child: Text('No images available'));
                    } else {
                      return MenuItem(
                        title: food.name,
                        description:
                            'Descrição do alimento', // Você pode ajustar isso conforme necessário
                        price: 'R\$ ${food.price.toStringAsFixed(2)}',
                        image: imageSnapshot.data!
                            .first, // Pegando a primeira URL da lista de URLs
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DrinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardápio de bebidas'),
      ),
      body: Consumer<DrinkProvider>(
        builder: (context, drinkProvider, child) {
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: drinkProvider.drinks.length,
            itemBuilder: (context, index) {
              final drink = drinkProvider.drinks[index];
              return MenuItem(
                title: drink.title,
                description: drink.description,
                price: drink.price,
                image: drink.image,
              );
            },
          );
        },
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localização no Mapa'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-28.26545877936513,
              -52.39748703386983), // Posição inicial do mapa
          zoom: 14.0, // Zoom inicial do mapa
        ),
        markers: {
          Marker(
            markerId: MarkerId('marker_1'),
            position: LatLng(
                -28.26545877936513, -52.39748703386983), // Posição do marcador
            infoWindow: InfoWindow(
              title: 'Localização',
              snippet: 'Passo Fundo, Brasil',
            ),
          ),
        },
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // meio da página
//       backgroundColor: Colors.white,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
//             child: Text(
//               "Bem-vindo(a) ao Restaurante Apelação!",
//               style: TextStyle(
//                 fontSize: 30,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Text(
//               "Especialidades do dia",
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.only(bottom: 50.0),
//             height: 250,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 buildSpecialtyCard(
//                   "Prato feito",
//                   "Arroz, feijão, ovo frito, bife, batata frita e salada.",
//                   "images/pratofeito.jpeg",
//                 ),
//                 buildSpecialtyCard(
//                   "Salada Caesar",
//                   "A deliciosa salada Caesar, perfeita para sua dieta!",
//                   "images/salada.jpg",
//                 ),
//                 buildSpecialtyCard(
//                   "Macarronada",
//                   "Deliciosa macarronada espaguete ao molho de tomate.",
//                   'images/macarronada.jpg',
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Text(
//               "Aqui no nosso restaurante, você encontra os melhores sabores e a melhor qualidade, além de se divertir com o desespero dos universitários! :)",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Text(
              "Bem-vindo(a) ao Restaurante Apelação!",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          Expanded(
            child: BlocProvider(
              create: (context) => GenerativeController(),
              child: ScreenHome(),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildSpecialtyCard(
      String title, String description, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              child: Image.asset(
                imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String image;

  MenuItem(
      {required this.title,
      required this.description,
      required this.price,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            image,
            fit: BoxFit.cover,
            height: 200.0,
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(description),
                SizedBox(height: 4.0),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Adicionar item ao carrinho
              },
              child: Text('Adicionar ao Carrinho'),
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  final List<String> textsOfChips = [
    "Fazendo checkout (1)",
    "Chegando em breve (1)",
    "Programados (1)",
    "Análise pendente (1)",
    "Hóspedes no momento (1)"
  ];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  List<bool> statesOfChips = [true, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //header
            backgroundColor: Colors.grey,
            toolbarHeight: 80,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark),
            elevation: 0,
            title: Row(children: [
              Icon(Icons.restaurant, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Restaurante Apelação',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ])),
        bottomNavigationBar: NavigationBar(
          //propriedade que define a função que será chamada
          //quando o usuário clicar em uma das tabs
          onDestinationSelected: (int index) {
            //a mudança da variável currentPageIndex está dentro do
            //setState, para que o State fique sujo e a Widget
            //seja reconstruída
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(
                Icons.content_paste_search,
              ),
              label: 'Gere sua receita',
            ),
            NavigationDestination(
              icon: Icon(Icons.fastfood),
              label: 'Pratos',
            ),
            NavigationDestination(
              icon: Icon(Icons.wine_bar),
              label: 'Bebidas',
            ),
            NavigationDestination(
              icon: Icon(Icons.map),
              label: 'Localização',
            ),
          ],
        ),
        //mudamos o body para uma matriz, onde:
        //a primeira linha define os conteúdos dinâmicos, selecionados
        //conforme o índice corrente.
        //a segunda linha indica justamente qual é o valor que indica
        //o índice corrente
        body: [
          todayTab,
          calendarTab,
          advertisingTab,
          messagesTab,
        ][currentPageIndex]);
  }

  //row interna, filha da coluna principaç
  Widget _getInternalRow() => IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Enviar mensagem",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
            ),
            const VerticalDivider(
              color: Colors.black26,
              width: 1,
            ),
            Expanded(
              child: TextButton(
                style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Ligar",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
            ),
          ],
        ),
      );
  get todayTab => HomeScreen();
  get calendarTab => MenuScreen();
  get advertisingTab => DrinkScreen();
  get messagesTab => MapScreen();

  Widget buildChoice(int index) => ActionChip(
        label: Text(
          widget.textsOfChips[index],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            width: statesOfChips[index] ? 2.0 : 0.5,
          ),
        ),
        onPressed: () {
          setState(() {
            statesOfChips[index] = !statesOfChips[index];
          });
        },
      );
}
