// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:go_router/go_router.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import '../../styles/bg.dart';
import '../../styles/text.dart';
import 'agenda_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaScreen extends StatefulWidget {
  AgendaBloc bloc;
  AgendaScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  AgendaBloc _bloc() => widget.bloc;
  final Cache _cache = Cache();

  @override
  void initState() {
    super.initState();
  }

  Widget _loadingCenter() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: SpinKitSpinningCircle(color: ColorUtil.black),
          ),
        ],
      ),
    );
  }

  void dialog(String errorMessage) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(title: Text(errorMessage));
    },
  );

  Widget _showErrorMessage({String errorMessage = "NO HAY AGENDA DISPONIBLE"}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Image(
            image: AssetImage("assets/icons/warning.png"),
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(height: 10),
        Text(errorMessage),
      ],
    );
  }

  Widget _showErrorMessageService({String errorMessage = "Test screen"}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [const SizedBox(height: 10), Center(child: Text(errorMessage))],
    );
  }

  Future<void> _refresh() async {
    _bloc().add(AgendaRefreshEvent());
  }

  @override
  Widget build(BuildContext context) {
    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "GEAP FIT",
          style: TitleTextStyle(fontSize: 24, color: ColorUtil.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            // tooltip: 'Increase volume by 10',
            onPressed: () => closeSession(),
          ),
        ],
      ),
      //backgroundColor: _colorProvider.primaryLight(),
      body: BlocConsumer<AgendaBloc, AgendaState>(
        bloc: _bloc(),
        listener: (context, state) {
          if (state is AgendaLoadedProductState) {
            void _refrescar() async {
              setState(() {
                // refreshState = true;
              });
              await _bloc().getUsers();
              setState(() {
                // refreshState = false;
              });
            }

            _refrescar();
          }
        },
        builder: (context, state) {
          if (state is AgendaInitialState ||
              state is AgendaLoadingProductState) {
            _bloc().init();
            return _loadingCenter();
          }
          if (state is AgendaErrorProductState) {
            return _showErrorMessageService();
          }
          if (state is AgendaLoadingProductState) {
            return _loadingCenter();
          }
          if (state is AgendaLoadedProductState) {
            var library = state.agenda ?? [];
            if (library.isEmpty) {
              return _showErrorMessage();
            }
            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    formatButtonTextStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          }
          return const Text("Error");
        },
      ),
    );
  }

  void closeSession() {
    _cache.emptyCacheData();
    context.go(StaticNames.loginName.path);
  }

  @override
  void dispose() {
    _bloc().close();
    super.dispose();
  }
}
