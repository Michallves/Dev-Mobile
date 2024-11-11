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
        debugShowCheckedModeBanner: false,
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: HomePage());
  }
}

class Task {
  String imageUrl;
  String name;
  int difficulty;
  int _level = 0;

  get levelMax {
    return difficulty * 10;
  }

  double get progress {
    return _level / levelMax;
  }

  Task({
    this.imageUrl = '',
    required this.name,
    required this.difficulty,
  });

  int get level => _level;
  
  incrementLevel(){
    _level += 1;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class TaskWidget extends StatefulWidget {
  final Task task;
  const TaskWidget({super.key, required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  levelUp() {
    if (widget.task.level < widget.task.levelMax) {
      setState(() {
        widget.task.incrementLevel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                    width: 80,
                    height: 90,
                    child: Image.network(
                      widget.task.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis),
                        ),
                        StarsWidget(
                          value: widget.task.difficulty,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: IconButton.filled(
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))),
                        onPressed: levelUp,
                        icon: const SizedBox(
                          height: 40,
                          child: Column(
                            children: [
                              Icon(Icons.arrow_drop_up),
                              Text(
                                'Lvl Up',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              )
                            ],
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 40,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: widget.task.progress,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  'Nível: ${widget.task.level}',
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class StarsWidget extends StatelessWidget {
  final int value;
  const StarsWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            final bool painted = index <= value;
            return Icon(
              Icons.star,
              size: 18,
              color: painted ? Colors.blue : Colors.grey[300],
            );
          }),
    );
  }
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameTextEditingController =
      TextEditingController();

  final TextEditingController descriptionTextEditingController =
      TextEditingController();

  final TextEditingController dateTextEditingController =
      TextEditingController();

  List<Task> tasks = [
    Task(
      imageUrl:
          'https://static6.depositphotos.com/1057968/615/i/600/depositphotos_6153518-stock-photo-cleaning.jpg',
      name:
          "Limpar a casa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      difficulty: 3,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    ),
    Task(
      imageUrl:
          'https://st.depositphotos.com/4218696/61575/i/600/depositphotos_615750566-stock-photo-sales-offer-happy-customers-couple.jpg',
      name: "Fazer as compras",
      difficulty: 1,
    )
  ];

  addTask() {
    // setState(() {
    //   tasks.add(Task(
    //       name: nameTextEditingController.text,
    //       difficulty: descriptionTextEditingController.text,
    //       date: dateTextEditingController.text));
    // });
    clearTextFields();
    Navigator.of(context).pop();
  }

  clearTextFields() {
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
                      onPressed: addTask, child: const Text("Adicionar tarefa"))
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
        title: const Text(
          "Tarefas",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: const Color.fromARGB(255, 229, 233, 231),
      body: ListView.separated(
          itemCount: tasks.length,
          separatorBuilder: (context, i) => const SizedBox(height: 8),
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final Task task = tasks[index];
            return TaskWidget(
              task: task,
            );
          }),
    );
  }
}
