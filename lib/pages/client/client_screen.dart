// ignore_for_file: no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:go_router/go_router.dart';
import 'package:geap_fit/pages/client/client_bloc.dart';
import 'package:geap_fit/styles/bg.dart';
import 'package:geap_fit/styles/text.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import 'models/user_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ClientScreen extends StatefulWidget {
  final ClientEqBloc bloc;

  const ClientScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  bool refreshState = false;
  List<String> listCompanies = [];
  bool collapsePostpaid = false;
  final Cache _cache = Cache();

  ClientEqBloc _bloc() => widget.bloc;

  @override
  void initState() {
    _bloc().init();
    super.initState();
  }

  Future<void> _refresh() async {
    _bloc().add(ClientRefreshEvent());
  }

  Widget _showErrorMessage({
    String errorMessage = "NO HAY CLIENTES DISPONIBLE",
  }) {
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

  Widget _cliente(List<Fields> user, index) {
    const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    String dropdownValue = list.first;
    return InkWell(
      focusColor: Colors.black,
      highlightColor: Colors.black,
      splashColor: Colors.black,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 75,
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                "https://cdn-icons-png.flaticon.com/512/6858/6858504.png",
              ),
              radius: 28,
            ),
            const Gap(20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user[index].first?.stringValue ?? "N/A",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(1),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user[index].last?.stringValue ?? "N/A",
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                // style: const TextStyle(color: Colors.deepPurple),
                underline: Container(height: 2),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items:
                    list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("GEAP FIT", style: TitleTextStyle(fontSize: 24)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            // tooltip: 'Increase volume by 10',
            onPressed: () => closeSession(),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<ClientEqBloc, ClientEqState>(
          bloc: _bloc(),
          listener: (context, state) {
            if (state is ClientLoadingProductState) {
              void _refrescar() async {
                setState(() {
                  refreshState = true;
                });
                await _bloc().getUsers();
                setState(() {
                  refreshState = false;
                });
              }

              _refrescar();
            }
          },
          builder: (context, state) {
            if (state is ClientInitialState ||
                state is ClientLoadingProductState) {
              _bloc().init();
              return _loadingCenter();
            }
            if (state is ClientErrorProductState) {
              return _showErrorMessageService();
            }
            if (refreshState) {
              return _loadingCenter();
            }
            if (state is ClientLoadedProductState) {
              var usuarios = state.usuarios ?? [];
              if (usuarios.isEmpty) {
                return _showErrorMessage();
              }
              return RefreshIndicator(
                onRefresh: _refresh,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
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
                          return _cliente(usuarios, index);
                        }, childCount: usuarios.length),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Text("Error");
          },
        ),
      ),
    );
  }

  void closeSession() {
    _cache.emptyCacheData();
    context.go(StaticNames.loginName.path);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc().close();
  }
}
