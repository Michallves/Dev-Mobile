import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage());
  }
}

class Task {
  String name;
  String description;
  String date;

  Task({
    required this.name,
    required this.description,
    required this.date,
  });
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameTextEditingController =
      TextEditingController();

  final TextEditingController descriptionTextEditingController =
      TextEditingController();

  final TextEditingController dateTextEditingController =
      TextEditingController();

  List<Task> tasks = [
    Task(name: "Limpar a casa", description: "...", date: '04/11/2024'),
    Task(name: "Arrumar o quarto", description: "...", date: "04/11/2024")
  ];

  addTask() {
    setState(() {
      tasks.add(Task(
          name: nameTextEditingController.text,
          description: descriptionTextEditingController.text,
          date: dateTextEditingController.text));
    });
    clearTextFields();
    Navigator.of(context).pop();
  }

  clearTextFields(){
    nameTextEditingController.clear();
    descriptionTextEditingController.clear();
    dateTextEditingController.clear();
  }
  showPopupAddTask(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Adicionar Tarefa"),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: "Nome da tarefa"),
                    controller: nameTextEditingController,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Descrição da tarefa"),
                    controller: descriptionTextEditingController,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Data da tarefa"),
                    controller: dateTextEditingController,
                  ),
                  OutlinedButton(
                      onPressed: addTask, child: Text("Adicionar tarefa"))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To-Do List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => showPopupAddTask(context)),
      body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final Task task = tasks[index];

            return ListTile(
              tileColor: Colors.red[100],
              title: Text(task.name),
              subtitle: Text('${task.description}\n${task.date}'),
            );
          }),
    );
  }
}
