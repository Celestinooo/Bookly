import 'package:bookly_project/view/livro_form_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/livro_controller.dart';
import '../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => LivroController()..fetchLivros(),
      child: const BooklyApp(),
    ),
  );
}

class BooklyApp extends StatelessWidget {
  const BooklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookly',
      theme: ThemeData(
        primaryColor: Colors.red,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LivroController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LivroFormPage()),
              );
            },
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : controller.livros.isEmpty
          ? const Center(child: Text('Nenhum livro cadastrado'))
          : ListView.builder(
        itemCount: controller.livros.length,
        itemBuilder: (context, index) {
          final livro = controller.livros[index];
          return ListTile(
            title: Text(livro.titulo),
            subtitle: Text('${livro.autor} • ${livro.lido ? "Lido" : "Não Lido"}'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LivroFormPage(livro: livro)),
              );
              controller.fetchLivros();
            },
          );
        },
      ),
    );
  }
}
