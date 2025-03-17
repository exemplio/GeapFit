// ignore_for_file: no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:go_router/go_router.dart';
import 'package:geap_fit/pages/client/client_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:geap_fit/styles/bg.dart';
import 'package:geap_fit/styles/text.dart';
import 'package:geap_fit/styles/theme_provider.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import '../../di/injection.dart';
import '../../services/http/domain/productModel.dart';
import 'models/initModel.dart';

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
  final _colorProvider = getIt<ThemeProvider>().colorProvider();

  ClientEqBloc _bloc() => widget.bloc;

  @override
  void initState() {
    _bloc().init();
    super.initState();
  }

  void _refresh() async {
    _bloc().add(ClientRefreshProductEvent());
  }

  Widget _showErrorMessage({
    String errorMessage = "NO HAY SERVICIOS DISPONIBLE",
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Lottie.asset(
            "assets/img/warning.json",
            repeat: false,
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

  Widget _cliente(Fields product) {
    // var company = product.company?.toLowerCase();
    // int isExistsImage = listCompanies.indexOf(company ?? "");

    return Card(
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            const SizedBox(width: 5),
            Text(
              product.born?.integerValue ?? "",
              textAlign: TextAlign.center,
              style: const TitleTextStyle(
                color: ColorUtil.dark_gray,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader({ProfileModel? profile}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 2,
        color: ColorUtil.grayLight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.businessName ?? "",
                      style: const TitleTextStyle(
                        fontSize: 16,
                        color: ColorUtil.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profile?.idDoc ?? "",
                      style: const TitleTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorUtil.dark_gray,
                      ),
                    ),
                    // SizedBox(height: 5),
                  ],
                ),
              ),
              //const Padding(padding: EdgeInsets.symmetric(horizontal: 45, vertical: 0)),
              const Flexible(
                flex: 1,
                child: Image(
                  image: AssetImage("assets/img/sunmi.png"),
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
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
          SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
          SizedBox(height: 10),
          Text("Cargando"),
        ],
      ),
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
      body: SafeArea(
        child: BlocConsumer<ClientEqBloc, ClientEqState>(
          bloc: _bloc(),
          listener: (context, state) {
            if (state is ClientLoadingProductState) {
              void _refrescar() async {
                setState(() {
                  refreshState = true;
                });
                await _bloc().getProducts();
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
              // return _showErrorMessageService();
            }
            if (refreshState) {
              // return _loadingCenter();
            }
            if (state is ClientLoadedProductState) {
              var products = state.products ?? [];
              var profile = state.profile;
              String? save = "";
              String? save1 = "";
              String? save2 = "";
              if (products.isEmpty) {
                return _showErrorMessage();
              }
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        profile != null
                            ? _profileHeader(profile: profile)
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "SERVICIOS DISPONIBLES",
                                    style: TitleTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _refresh();
                                    },
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ],
                              ),
                              const Row(children: []),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(10),
                    // Espaciado alrededor del contenido
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 325,
                            childAspectRatio: 12 / 11,
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
                          focusColor: _colorProvider.primaryLight(),
                          highlightColor: _colorProvider.primaryLight(),
                          splashColor: _colorProvider.primaryLight(),
                          onTap:
                              () => context.goNamed(
                                StaticNames.product.name,
                                extra: products[index],
                              ),
                          child: _cliente(products[index]),
                        );
                      }, childCount: products.length),
                    ),
                  ),
                ],
              );
            }
            return Text("Error de prueab");
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
