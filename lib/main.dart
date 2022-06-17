import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:logic_circuits_simulator/pages/edit_component.dart';
import 'package:logic_circuits_simulator/pages/project.dart';
import 'package:logic_circuits_simulator/pages/projects.dart';
import 'package:logic_circuits_simulator/pages/settings.dart';
import 'package:logic_circuits_simulator/pages_arguments/edit_component.dart';
import 'package:logic_circuits_simulator/state/project.dart';
import 'package:logic_circuits_simulator/state/projects.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: findSystemLocale().then((_) => initializeDateFormatting()).then((_) => true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Wait until locale is detected
          return Container();
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProjectsState()),
            ChangeNotifierProvider(create: (_) => ProjectState()),
          ],
          child: MaterialApp(
            title: 'Logic Circuits Simulator',
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.orange,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.orange,
              brightness: Brightness.dark,
            ),
            routes: {
              ProjectsPage.routeName:(context) {
                return const ProjectsPage();
              },
              MainPage.routeName:(context) {
                return const MainPage();
              },
              SettingsPage.routeName:(context) => const SettingsPage(),
              ProjectPage.routeName: (context) {
                return const ProjectPage();
              },
              EditComponentPage.routeName: (context) {
                final arguments = ModalRoute.of(context)!.settings.arguments as EditComponentPageArguments;
                return EditComponentPage(
                  component: arguments.component,
                  newComponent: arguments.newComponent,
                );
              },
            },
            initialRoute: MainPage.routeName,
          ),
        );
      }
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Logic Circuits Simulator',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(ProjectsPage.routeName);
                  }, 
                  icon: const Icon(Icons.book),
                  label: const Text('Projects'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SettingsPage.routeName);
                  }, 
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ].map((e) => Padding(padding: const EdgeInsets.all(8), child: e,)).toList(growable: false),
            )
          ],
        ),
      ),
    );
  }
}