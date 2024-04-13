import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            })),
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

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardápio'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          MenuItem(
            title: 'Pizza',
            description: 'Deliciosa pizza com diversos sabores',
            price: 'R\$ 25,00',
            image: 'images/pizza.jpeg',
          ),
          MenuItem(
            title: 'Hambúrguer',
            description: 'Suculento hambúrguer artesanal',
            price: 'R\$ 15,00',
            image: 'assets/hamburguer.jpg',
          ),
          MenuItem(
            title: 'Massa',
            description: 'Massa fresca feita na hora',
            price: 'R\$ 20,00',
            image: 'assets/massa.jpg',
          ),
        ],
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
          Image.asset(
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
          toolbarHeight: 80,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
          elevation: 0,
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_outlined))
              ],
            )
          ],
        ),
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
                Icons.home,
              ),
              label: 'Home',
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
            NavigationDestination(
              icon: Icon(Icons.menu),
              label: 'Menu',
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
          menuTab
        ][currentPageIndex]);
  }

  get todayTab => Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          insidePadding(
              Text(
                "Seja bem-vindo(a)!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              bottomPadding: 64),
          insidePadding(Text("HOMEEEEEEEEEEEEEEE",
              style: Theme.of(context).textTheme.titleLarge)),
          Container(
            margin: const EdgeInsets.only(bottom: 24.0),
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 10,
                ),
                buildChoice(0),
                const SizedBox(
                  width: 10,
                ),
                buildChoice(1),
                const SizedBox(
                  width: 10,
                ),
                buildChoice(2),
                const SizedBox(
                  width: 10,
                ),
                buildChoice(3),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          insidePadding(Container(
              margin: const EdgeInsets.only(bottom: 48.0),
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black26,
                    style: BorderStyle.solid,
                    width: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _getMainColumn())),
          insidePadding(Text("Todas as reservas",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    decoration: TextDecoration.underline,
                  ))),
        ],
      ));

  //coluna principal
  Widget _getMainColumn() => Column(
        children: [
          _getInternalColumn(),
          const Divider(
            color: Colors.black26,
            height: 1,
          ),
          _getInternalRow()
        ],
      );

  //coluna interna, filha da coluna principa/
  Widget _getInternalColumn() => Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          //crossAxis é o eixo cruzado, logo, estamos em uma coluna e o eixo cruzado é na horizontal]
          //em quase todo mundo, o início de um eixo horizontal é na esquerda
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 48.0),
              child: Text("Checkout amanhã",
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Michael",
                          style: Theme.of(context).textTheme.titleLarge),
                      Text("25 - 26 de jan.",
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage("images/download.jpeg"),
                  radius: 24,
                )
              ],
            )
          ],
        ),
      );

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

  get calendarTab => MenuScreen();
  get advertisingTab => const Center(child: Text("Anúncio"));
  get messagesTab => const Center(child: Text("Mensagens"));
  get menuTab => const Center(child: Text("Menu"));

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
