import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:agroconecta/config/theme/app_theme.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selected = DateTime.now();
  DateTime _firstDay = DateTime(DateTime.now().year - 1, 1, 1);
  DateTime _lastDay  = DateTime(DateTime.now().year + 1, 12, 31);

  // --- Data de ejemplo (puedes reemplazar por tu fuente real) ---
  final Map<DateTime, List<_Event>> _eventsByDay = {
    _d(2025, 10, 15): [
      _Event(
        title: 'Taller de Cultivo de Maíz',
        subtitle: '15 de Octubre, 9:00 AM',
        location: 'José María Morelos, Q. Roo',
        image: 'assets/banners/banner_1.jpg',
      ),
    ],
    _d(2025, 8, 17): [
      _Event(
        title: 'Capacitación de riego',
        subtitle: 'Módulo práctico',
        location: 'Mérida, Yucatán',
        image: 'assets/banners/banner_2.jpg',
      ),
      _Event(
        title: 'Curso de agricultura orgánica',
        subtitle: 'Jornada de actualización',
        location: 'Mérida, Yucatán',
        highlightDay: _d(2025, 7, 22),
      ),
    ],
  };

  static DateTime _d(int y, int m, int d) => DateTime(y, m, d);

  List<_Event> _eventsFor(DateTime day) {
    final k = DateTime(day.year, day.month, day.day);
    return _eventsByDay[k] ?? const [];
  }

  String _humanDate(DateTime d) {
    // Ej: "Lun, 17 Ago"
    const w = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final wd = w[(d.weekday - 1) % 7];
    final mo = m[d.month - 1];
    return '$wd, ${d.day} $mo';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final overlay = SystemUiOverlayStyle(
      statusBarColor: colorList[2],
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );

    final events = _eventsFor(_selected);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: colorList[2],
          elevation: 0,
          centerTitle: false,
          title: const Text(
            'Calendario de Eventos',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final r = GoRouter.of(context);
              if (r.canPop()) {
                r.pop();
              } else {
                r.go('/home');
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          children: [
            // Encabezado con fecha humana
            Text(
              _humanDate(_selected),
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: .9),
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),

            // Tarjeta con CalendarDatePicker
            Card(
              elevation: 0,
              color: cs.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CalendarDatePicker(
                  initialDate: _selected,
                  firstDate: _firstDay,
                  lastDate: _lastDay,
                  currentDate: DateTime.now(),
                  onDateChanged: (d) => setState(() => _selected = d),
                ),
              ),
            ),

            const SizedBox(height: 18),
            Text(
              'Eventos:',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: .85),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            if (events.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy,
                        color: cs.onSurface.withValues(alpha: .5)),
                    const SizedBox(width: 8),
                    Text(
                      'No hay eventos para este día',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: .7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...events.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _EventCard(event: e),
                  )),
          ],
        ),

        // Bottom Navigation (opcional, si usas Shell, quítalo)
        // bottomNavigationBar: ...
      ),
    );
  }
}

// ------------------------------------------------------------------
// Modelos + Widgets auxiliares
// ------------------------------------------------------------------

class _Event {
  final String title;
  final String subtitle;
  final String location;
  final String? image;        // si viene imagen se muestra thumb
  final DateTime? highlightDay; // si viene, muestra pill con día/mes

  const _Event({
    required this.title,
    required this.subtitle,
    required this.location,
    this.image,
    this.highlightDay,
  });
}

class _EventCard extends StatelessWidget {
  final _Event event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget leading() {
      if (event.image != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            event.image!,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        );
      }
      // “Pill” de fecha (similar al ejemplo 22/JUL)
      final d = event.highlightDay ?? DateTime.now();
      final mon = ['ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'][d.month-1];
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: colorList[0].withValues(alpha: .12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${d.day}',
              style: TextStyle(
                color: colorList[0],
                fontWeight: FontWeight.w900,
                fontSize: 18,
                height: .9,
              ),
            ),
            Text(mon,
              style: TextStyle(
                color: colorList[0],
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: .5,
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              leading(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 2),
                    Text(event.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: .8),
                          fontSize: 12.5,
                        )),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.place,
                            size: 16,
                            color: cs.onSurface.withValues(alpha: .6)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: .7),
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Icon(Icons.add, color: colorList[0]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
