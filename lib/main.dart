import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

// Modelo da Tarefa
class Task {
  String id;
  String imageUrl;
  String name;
  int difficulty;
  int level = 0;

  get levelMax {
    return difficulty * 10;
  }

  double get progress {
    return level / levelMax;
  }

  Task({
    required this.id,
    this.imageUrl = '',
    required this.name,
    required this.difficulty,
    this.level = 0,
  });

  factory Task.fromJson(Map<String, dynamic> json, String id) {
    return Task(
      id: id,
      name: json["name"],
      imageUrl: json["imageUrl"],
      difficulty: json["difficulty"],
      level: json["level"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "imageUrl": imageUrl,
      "difficulty": difficulty,
      "level": level
    };
  }
}

// Serviço para Firebase Realtime Database
class DatabaseService {
  final String baseUrl =
      "https://todo-list-c3649-default-rtdb.firebaseio.com/tasks";

  Future<void> addTask(Task task) async {
    await http.post(
      Uri.parse("$baseUrl.json"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(task.toJson()),
    );
  }

  Future<void> updateTask(Task task) async {
    final url = "$baseUrl/${task.id}.json";
    await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(task.toJson()),
    );
  }

  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse("$baseUrl.json"));
    if (response.statusCode == 200 && response.body != "null") {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data.entries
          .map((entry) => Task.fromJson(entry.value, entry.key))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> updateTaskLevel(Task task) async {
    final url = "$baseUrl/${task.id}.json";
    await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"level": task.level}),
    );
  }

  Future<void> deleteTask(String id) async {
    await http.delete(Uri.parse("$baseUrl/$id.json"));
  }
}

// Tela Principal
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService dbService = DatabaseService();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController imageCtrl = TextEditingController();
  final TextEditingController difficultyCtrl = TextEditingController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await dbService.getTasks();
    setState(() {});
  }

  void addTask() async {
    if (nameCtrl.text.isNotEmpty && difficultyCtrl.text.isNotEmpty) {
      final task = Task(
        id: '',
        name: nameCtrl.text,
        imageUrl: imageCtrl.text,
        difficulty: int.parse(difficultyCtrl.text),
      );
      await dbService.addTask(task);
      loadTasks();
      clearFields();
    }
  }

  void clearFields() {
    nameCtrl.clear();
    imageCtrl.clear();
    difficultyCtrl.clear();
  }

  void deleteTask(String id) async {
    await dbService.deleteTask(id);
    loadTasks();
  }

  void updateLevel(Task task) async {
    if (task.level < task.levelMax) {
      task.level = task.level + 1;
    }
    await dbService.updateTaskLevel(task);
    loadTasks();
  }

  void updateTask(Task task) {
    showUpdateTaskPopup(task);
  }

  void showAddTaskPopup() {
    clearFields();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Tarefa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Nome")),
              TextField(
                  controller: imageCtrl,
                  decoration: const InputDecoration(labelText: "Imagem URL")),
              TextField(
                  controller: difficultyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Dificuldade")),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar")),
            TextButton(
                onPressed: () {
                  addTask();
                  Navigator.pop(context);
                },
                child: const Text("Adicionar")),
          ],
        );
      },
    );
  }
  showUpdateTaskPopup(Task task) {
    nameCtrl.text = task.name;
    imageCtrl.text = task.imageUrl;
    difficultyCtrl.text = task.difficulty.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Tarefa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Nome")),
              TextField(
                  controller: imageCtrl,
                  decoration: const InputDecoration(labelText: "Imagem URL")),
              TextField(
                  controller: difficultyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Dificuldade")),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar")),
            TextButton(
                onPressed: () async {
                  task.name = nameCtrl.text;
                  task.imageUrl = imageCtrl.text;
                  task.difficulty = int.parse(difficultyCtrl.text);
                  await dbService.updateTask(task);
                  loadTasks();
                  Navigator.pop(context);
                },
                child: const Text("Salvar")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarefas"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: showAddTaskPopup,
          child: const Icon(Icons.add)),
      body: tasks.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.blue,))
          : ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (context, i) => const SizedBox(height: 8),
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskWidget(
                    task: task, onDelete: deleteTask, onEdit: updateTask, onLevelUp: updateLevel);
              },
            ),
    );
  }
}
class TaskWidget extends StatefulWidget {
  final Task task;
  final Function(String) onDelete;
  final Function(Task) onEdit;
  final Function(Task) onLevelUp;
  const TaskWidget(
      {super.key,
      required this.task,
      required this.onDelete,
      required this.onEdit,
      required this.onLevelUp});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
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
                        maxLines: 1,
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
                  child: IconButton(
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                      onPressed: () => widget.onLevelUp(widget.task),
                      icon: const Column(
                        children: [
                          Icon(
                            Icons.arrow_drop_up,
                            color: Colors.white,
                          ),
                          Text(
                            'Lvl Up',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          )
                        ],
                      )),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    widget.onEdit(widget.task);
                  } else if (value == 'delete') {
                    widget.onDelete(widget.task.id);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Deletar'),
                    ),
                  ];
                },
              ),
            ],
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
            final int quantity = index + 1;
            final bool painted = quantity <= value;
            return Icon(
              Icons.star,
              size: 16,
              color: painted ? Colors.blue : Colors.grey[300],
            );
          }),
    );
  }
}
  