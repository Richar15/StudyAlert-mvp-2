# StudyAlert MVP version 2

Un sistema de gestión de tareas académicas inteligente, diseñado para ayudarte a mantenerte organizado y productivo en tu vida estudiantil.

## 📋 Índice
- [Descripción](#descripción)
- [Características principales](#características-principales)
- [Estructura de datos](#estructura-de-datos)
- [Instalación y configuración](#instalación-y-configuración)
- [Uso](#uso)
- [Licencia](#licencia)

## 📚 Descripción

StudyAlert MVP es una aplicación Flutter centrada en la gestión eficiente de tareas académicas. Con una interfaz limpia y responsiva, te permite organizar tus compromisos educativos, establecer prioridades y recibir notificaciones oportunas.

## ✨ Características principales

- **Gestión semanal**: Visualiza tus tareas organizadas por semanas con paginación intuitiva
- **Priorización automática**: Las tareas se ordenan según la cercanía de su fecha límite
- **Estados visuales**: Identificación por colores para tareas sin iniciar, en proceso o vencidas
- **Notificaciones inteligentes**: Alertas para recordatorios, tareas sin fecha y compromisos vencidos
- **Interfaz adaptativa**: Diseño responsivo optimizado para dispositivos móviles y escritorio

## 🧰 Estructura de datos

Cada tarea se estructura de la siguiente manera:

```json
{
  "id": 1,
  "fecha": "2023-12-31",
  "dia": "domingo",
  "tipoEvento": "Examen",
  "titulo": "Evaluación final",
  "asignatura": "Matemáticas",
  "hora": "14:30",
  "done": false,
  "snoozedUntil": null,
  "link": "https://ejemplo.com/recurso"
}
```

**Descripción de campos:**
- `id`: Identificador numérico único
- `fecha`: Fecha en formato YYYY-MM-DD
- `dia`: Nombre del día de la semana (ej. "domingo")
- `tipoEvento`: Categoría de la tarea
- `titulo`: Título descriptivo de la tarea
- `asignatura`: Materia académica relacionada
- `hora`: Hora de entrega en formato HH:mm
- `done`: Estado de finalización (true/false)
- `snoozedUntil`: Fecha hasta la que se pospuso (null si no está pospuesta)
- `link`: URL externa con recursos o entregas

## 🔧 Instalación y configuración

1. Clona el repositorio:
```bash
git clone https://github.com/Richar15/StudyAlert-mvp-2.git
```
2. Instala las dependencias:
```bash
cd studyalert_mvp_2
flutter pub get
```

3. Ejecuta la aplicación:
```bash
flutter run
```

## 🚀 Uso

### Vista principal
- Encabezado con título "Módulo de Tareas" y selector de mes (ejemplo: Julio 2025)
- Navegación semanal mediante botones "anterior" y "siguiente"
- Tarjetas de tareas ordenadas por prioridad (menos tiempo restante primero)

### Cada tarjeta muestra
- 📌 Título y tipo de evento
- 📚 Asignatura
- 🗓 Día, fecha y hora
- ⏳ Tiempo restante hasta la entrega
- 🔗 Acceso directo al recurso externo
- 🔘 Botón para marcar como completada

### Sistema de estados
- Verde: "Sin iniciar" (la fecha no ha llegado)
- Amarillo: "En proceso" (la fecha es hoy)
- Rojo: "Vencida" (ya pasó la fecha)
- Azul: "Pospuesta hasta [fecha]" (cuando existe snoozedUntil)

## 📄 Licencia
Este proyecto está licenciado bajo [especificar licencia] - consulta el archivo `LICENSE` para más detalles.

---

Desarrollado con 💙 usando Flutter