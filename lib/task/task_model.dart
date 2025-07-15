class TaskModel {
  final String tipoActividad;
  final String asignatura;
  final DateTime fechaVencimiento;
  final String tiempoRestante;
  final String estado;
  final String enlace;

  TaskModel({
    required this.tipoActividad,
    required this.asignatura,
    required this.fechaVencimiento,
    required this.tiempoRestante,
    required this.estado,
    required this.enlace,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      tipoActividad: json['tipoActividad'],
      asignatura: json['asignatura'],
      fechaVencimiento: DateTime.parse(json['fechaVencimiento']),
      tiempoRestante: json['tiempoRestante'],
      estado: json['estado'],
      enlace: json['enlace'],
    );
  }
}
