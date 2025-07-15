import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyalert_mvp_2/login/login.dart';
import 'package:studyalert_mvp_2/task/pomodoro_screen.dart';
import 'package:studyalert_mvp_2/task/task_card.dart';
import 'package:studyalert_mvp_2/task/task_model.dart';
import 'package:studyalert_mvp_2/main.dart';
import 'package:studyalert_mvp_2/task/workflow_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Map<int, List<TaskModel>> tareasPorSemana = {};
  int semanasTotales = 1;

  @override
  void initState() {
    super.initState();
    cargarTareas();
  }

  Future<void> cargarTareas() async {
    final String data = await rootBundle.loadString('assets/task.json');
    final List<dynamic> jsonResult = jsonDecode(data);
    final List<TaskModel> tareas = jsonResult
        .map((json) => TaskModel.fromJson(json))
        .where((t) => t.estado != 'completado')
        .toList();
    tareas.sort((a, b) => a.fechaVencimiento.compareTo(b.fechaVencimiento));

    final now = DateTime.now();
    final Map<int, List<TaskModel>> agrupadas = {};
    for (final tarea in tareas) {
      final diferenciaDias = tarea.fechaVencimiento.difference(now).inDays;
      final semana = (diferenciaDias ~/ 7) + 1;
      if (!agrupadas.containsKey(semana)) {
        agrupadas[semana] = [];
      }
      agrupadas[semana]!.add(tarea);
    }

    setState(() {
      tareasPorSemana = agrupadas;
      semanasTotales = agrupadas.keys.length;
    });
  }

  void marcarComoCompletada(TaskModel tarea, int semana) {
    setState(() {
      tareasPorSemana[semana]?.remove(tarea);
      if (tareasPorSemana[semana]?.isEmpty ?? false) {
        tareasPorSemana.remove(semana);
        semanasTotales = tareasPorSemana.keys.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final semanas = tareasPorSemana.keys.toList()..sort();
    return DefaultTabController(
      length: semanasTotales,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tu Calendario de Estudio', // Título más atractivo
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.8,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 8,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFF62A8EA), // Color de la app
          elevation: 0,
          centerTitle: true,
          leading: Builder( // Botón para abrir el Drawer
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  color: Colors.black54,
                ),
              ],
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black54,
                ),
              ],
            ),
            indicatorColor: Colors.white,
            tabs: semanas.map((semana) {
              String tabText;
              if (semana == 1) {
                tabText = 'Esta Semana'; // Texto más amigable
              } else if (semana == 2) {
                tabText = 'Próxima Semana'; // Texto más amigable
              } else {
                tabText = 'Semana $semana';
              }
              return Tab(text: tabText);
            }).toList(),
          ),
        ),
        drawer: Drawer( // El Drawer que contiene las opciones
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color(0xFF62A8EA),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Tu escudo
                      height: 60,
                      width: 60,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'StudyAlert',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Menú de Opciones',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.timer),
                title: const Text('Pomodoro'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PomodoroScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.workspaces_outline),
                title: const Text('Crear Flujo de Trabajo'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkflowScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar Sesión'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  Navigator.pushReplacement( // Reemplaza la pantalla actual
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: semanas.map((semana) {
            final tareas = tareasPorSemana[semana] ?? [];
            if (tareas.isEmpty) {
              return const Center(
                child: Text(
                  "¡Tiempo libre! No hay tareas pendientes esta semana.", // Mensaje más positivo
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                final tarea = tareas[index];
                return TaskCard(
                  tarea: tarea,
                  onCompletar: () => marcarComoCompletada(tarea, semana),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
