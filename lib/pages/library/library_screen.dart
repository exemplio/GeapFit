// ignore_for_file: must_be_immutable, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geap_fit/pages/library/library_bloc.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:go_router/go_router.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import '../../styles/bg.dart';
import '../../styles/text.dart';
import 'package:table_calendar/table_calendar.dart';

class LibraryScreen extends StatefulWidget {
  LibraryBloc bloc;
  LibraryScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  LibraryBloc _bloc() => widget.bloc;
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

  Future<void> _refresh() async {
    _bloc().add(LibraryRefreshEvent());
  }

  Widget _showErrorMessage({String errorMessage = "NO HAY DATOS DISPONIBLES"}) {
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

  @override
  Widget build(BuildContext context) {
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
      body: BlocConsumer<LibraryBloc, LibraryState>(
        bloc: _bloc(),
        listener: (context, state) {
          if (state is LibraryLoadedProductState) {
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
          if (state is LibraryInitialState ||
              state is LibraryLoadingProductState) {
            _bloc().init();
            return _loadingCenter();
          }
          if (state is LibraryErrorProductState) {
            return _showErrorMessageService();
          }
          if (state is LibraryLoadingProductState) {
            return _loadingCenter();
          }
          if (state is LibraryLoadedProductState) {
            var library = state.library ?? [];
            if (library.isEmpty) {
              return _showErrorMessage();
            }
            return RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(10),
                    // Espaciado alrededor del contenido
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 600,
                            childAspectRatio: 12 / 5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      delegate: SliverChildBuilderDelegate((
                        BuildContext context,
                        int index,
                      ) {
                        return InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          radius: 10,
                          // focusColor: _colorProvider.primaryLight(),
                          // highlightColor: _colorProvider.primaryLight(),
                          // splashColor: _colorProvider.primaryLight(),
                          onTap:
                              () => context.goNamed(
                                StaticNames.message.name,
                                extra: library[index],
                              ),
                          child: Text(""),
                        );
                      }, childCount: library.length),
                    ),
                  ),
                ],
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
