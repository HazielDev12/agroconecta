import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:agroconecta/config/theme/app_theme.dart';


enum EventType { evento, convocatoria, taller, curso, feria }

Color typeColor(EventType t, ColorScheme cs) {
  switch (t) {
    case EventType.evento:
      return colorList[0];
    case EventType.convocatoria:
      return Colors.teal;
    case EventType.taller:
      return Colors.amber.shade700;
    case EventType.curso:
      return Colors.blue;
    case EventType.feria:
      return Colors.pink.shade400;
  }
}

String typeLabel(EventType t) {
  switch (t) {
    case EventType.evento:
      return 'Evento';
    case EventType.convocatoria:
      return 'Convocatoria';
    case EventType.taller:
      return 'Taller';
    case EventType.curso:
      return 'Curso';
    case EventType.feria:
      return 'Feria';
  }
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

class CalEvent {
  final DateTime date;
  final String title;
  final String subtitle;
  final String location;
  final EventType type;
  final String? image;
  CalEvent({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.type,
    this.image,
  });
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final DateTime _today;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  late final List<CalEvent> _all;
  late final Map<DateTime, List<CalEvent>> _byDay;

  @override
  void initState() {
    super.initState();
    _today = _day(DateTime.now());
    _focusedDay = _today;
    _selectedDay = _today;

    _all = <CalEvent>[
      // --- Próximos (relativos a hoy) ---
      CalEvent(
        date: _today.add(const Duration(days: 1)),
        title: 'Jornada de sanidad vegetal',
        subtitle: 'Próximo · Mañana · 10:00 a. m.',
        location: 'José María Morelos, Q. Roo',
        type: EventType.evento,
        image: 'assets/banners/banner_3.jpg',
      ),
      CalEvent(
        date: _today.add(const Duration(days: 3)),
        title: 'Convocatoria: Semillas mejoradas',
        subtitle: 'Próximo · Cierra en 3 días',
        location: 'Quintana Roo',
        type: EventType.convocatoria,
      ),
      CalEvent(
        date: _today.add(const Duration(days: 7)),
        title: 'Curso de riego por goteo',
        subtitle: 'Próximo · Sáb · 9:00 a. m.',
        location: 'Mérida, Yucatán',
        type: EventType.curso,
        image: 'assets/banners/banner_2.jpg',
      ),
      CalEvent(
        date: _today.add(const Duration(days: 14)),
        title: 'Feria de innovación agro',
        subtitle: 'Próximo · 10:00 a. m. — Stands y encuentros',
        location: 'Chetumal, Q. Roo',
        type: EventType.feria,
        image: 'assets/banners/banner_1.jpg',
      ),

      // --- Fijos (fechas específicas) ---
      CalEvent(
        date: DateTime(2025, 8, 17, 9, 00),
        title: 'Capacitación de riego',
        subtitle: 'Dom 17 Ago · 9:00 a. m. | Módulo práctico',
        location: 'Mérida, Yucatán',
        type: EventType.taller,
        image: 'assets/banners/banner_2.jpg',
      ),
      CalEvent(
        date: DateTime(2025, 7, 22, 9, 00),
        title: 'Curso de agricultura orgánica',
        subtitle: 'Mar 22 Jul · 9:00 a. m. — Jornada de actualización',
        location: 'Mérida, Yucatán',
        type: EventType.curso,
      ),
      CalEvent(
        date: DateTime(2025, 10, 15, 9, 00),
        title: 'Taller de Cultivo de Maíz',
        subtitle: 'Mié 15 Oct · 9:00 a. m. - Explanada y práctica',
        location: 'José María Morelos, Q. Roo',
        type: EventType.taller,
        image: 'assets/banners/banner_1.jpg',
      ),
      CalEvent(
        date: DateTime(2025, 9, 30, 23, 59),
        title: 'Convocatoria SEDARPE',
        subtitle: 'Mar 30 Sep · 11:59 p. m. — Apoyo a insumos',
        location: 'Quintana Roo',
        type: EventType.convocatoria,
      ),
      CalEvent(
        date: DateTime(2025, 9, 5, 10, 00),
        title: 'Feria Agro 2025',
        subtitle: 'Vie 05 Sep · 10:00 a. m. — Stands y encuentros',
        location: 'Chetumal, Q. Roo',
        type: EventType.feria,
        image: 'assets/banners/banner_3.jpg',
      ),
      CalEvent(
        date: DateTime(2025, 6, 28, 17, 00),
        title: 'Evento de productores',
        subtitle: 'Sáb 28 Jun · 5:00 p. m. — Asamblea regional',
        location: 'Dziuché, Q. Roo',
        type: EventType.evento,
      ),
    ];

    // Indexar por día
    _byDay = {};
    for (final e in _all) {
      final k = _day(e.date);
      _byDay.putIfAbsent(k, () => []).add(e);
    }
  }

  List<CalEvent> _eventsFor(DateTime day) => _byDay[_day(day)] ?? const [];

  String _headerDate(DateTime d) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    const wd = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return '${wd[(d.weekday + 5) % 7]}, ${d.day} ${months[d.month - 1]}';
  }

  Iterable<CalEvent> get _upcoming =>
      _all.where((e) => _day(e.date).isAfter(_today) || _day(e.date) == _today).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  Iterable<CalEvent> get _past =>
      _all.where((e) => _day(e.date).isBefore(_today)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final overlay = SystemUiOverlayStyle(
      statusBarColor: colorList[2],
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );

    final selectedEvents = _eventsFor(_selectedDay ?? _focusedDay);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      // Manejo del botón físico/gesto "Atrás"
      child: WillPopScope(
        onWillPop: () async {
          final r = GoRouter.of(context);
          if (r.canPop()) {
            r.pop();
          } else {
            r.go('/home');
          }
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
          return false; // ya manejamos la navegación
        },
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
                if (r.canPop()) r.pop();
                else r.go('/home');
              },
            ),
            actions: [
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            children: [
              Text(
                _headerDate(_selectedDay ?? _focusedDay),
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: .9),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),

              // ---------- Calendar ----------
              Card(
                elevation: 0,
                color: cs.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                  child: TableCalendar<CalEvent>(
                    locale: 'es_MX',
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2026, 12, 31),
                    focusedDay: _focusedDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarFormat: CalendarFormat.month,
                    availableGestures: AvailableGestures.horizontalSwipe,
                    selectedDayPredicate: (d) =>
                        _selectedDay != null && _day(d) == _day(_selectedDay!),
                    onDaySelected: (sel, foc) {
                      setState(() {
                        _selectedDay = _day(sel);
                        _focusedDay = foc;
                      });
                    },
                    onPageChanged: (foc) => _focusedDay = foc,
                    eventLoader: _eventsFor,
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: cs.onSurface),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: cs.onSurface),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: cs.onSurface.withValues(alpha: .8),
                        fontWeight: FontWeight.w700,
                      ),
                      weekendStyle: TextStyle(
                        color: cs.onSurface.withValues(alpha: .8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      todayDecoration: BoxDecoration(
                        border: Border.all(color: colorList[0]),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: colorList[0],
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return const SizedBox.shrink();
                        // Máx 4 puntitos por día
                        final markers = (events as List<CalEvent>)
                            .take(4)
                            .map((e) => _Dot(color: typeColor(e.type, cs)))
                            .toList();
                        return Positioned(
                          bottom: 4,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: markers
                                .expand((w) => [w, const SizedBox(width: 3)])
                                .toList()
                              ..removeLast(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ---------- Eventos del día ----------
              if (selectedEvents.isNotEmpty) ...[
                _SectionTitle(text: 'Eventos de este día'),
                const SizedBox(height: 8),
                ...selectedEvents.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _EventCard(event: e),
                    )),
                const SizedBox(height: 16),
              ],

              // ---------- Próximos ----------
              _SectionTitle(text: 'Próximos'),
              const SizedBox(height: 8),
              if (_upcoming.isEmpty)
                _EmptyRow(text: 'No hay próximos eventos')
              else
                ..._upcoming.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _EventCard(event: e),
                    )),

              const SizedBox(height: 16),

              // ---------- Pasados ----------
              _SectionTitle(text: 'Pasados'),
              const SizedBox(height: 8),
              if (_past.isEmpty)
                _EmptyRow(text: 'Aún no hay eventos pasados')
              else
                ..._past.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _EventCard(event: e),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------- UI helpers -----------------------

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: cs.onSurface.withValues(alpha: .85),
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: .1,
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  final String text;
  const _EmptyRow({required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, color: cs.onSurface.withValues(alpha: .5)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: .7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final CalEvent event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tagColor = typeColor(event.type, cs);

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
      // Pill de fecha (DD / MES)
      final d = event.date;
      final mon = [
        'ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN',
        'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'
      ][d.month - 1];
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: tagColor.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${d.day}',
              style: TextStyle(
                color: tagColor,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                height: .9,
              ),
            ),
            Text(
              mon,
              style: TextStyle(
                color: tagColor,
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
                    Row(children: [
                      Flexible(
                        child: Text(
                          event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          typeLabel(event.type),
                          style: TextStyle(
                            color: tagColor,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 2),
                    Text(
                      event.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: .8),
                        fontSize: 12.5,
                      ),
                    ),
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
                    ),
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
                  child: Icon(Icons.add, color: tagColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
