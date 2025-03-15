// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/pages/store/models/store_model.dart';
import 'package:geap_fit/styles/theme_provider.dart';
import 'package:geap_fit/utils/error_message.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import '../../styles/bg.dart';
import '../../styles/text.dart';
import 'bloc/store_bloc.dart';

class StoreScreen extends StatefulWidget {
  StoreBloc bloc;
  StoreScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final _colorProvider = getIt<ThemeProvider>().colorProvider();
  StoreBloc _bloc() => widget.bloc;

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
            SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
            SizedBox(height: 10),
            Text("Cargando inventario")
          ]),
    );
  }

  Widget _buttonPayment() {
    return Expanded(
      child: TextButton.icon(
          icon: const Icon(Icons.payment, color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: _colorProvider.primary(),
              padding: const EdgeInsets.all(20)),
          onPressed: () => _bloc().goNext(path: StaticNames.recharge.name),
          label: const Text(
            "COMPRA",
            style: TitleTextStyle(color: ColorUtil.white),
          )),
    );
  }

  Widget _buttonGet() {
    return Expanded(
      child: TextButton.icon(
          icon: const Icon(Icons.phone_android_sharp, color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: _colorProvider.primaryLight(),
              padding: const EdgeInsets.all(20)),
          onPressed: () => _bloc().goNext(path: StaticNames.withdraw.name),
          label: const Text(
            "RETIRO",
            style: TitleTextStyle(color: ColorUtil.white),
          )),
    );
  }

  Widget _consigedWidget(Results consigned) {
    return Column(children: [
      const Text(
        "INVENTARIO EN CONSIGNACIÓN",
        style: TitleTextStyle(
            fontWeight: FontWeight.bold, color: ColorUtil.black, fontSize: 20),
      ),
      const Text(
        "(Pospago)",
        style: TitleTextStyle(
            fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
      ),
      const SizedBox(height: 15),
      consigned.minLimit != null
          ? Column(
              children: [
                const Text(
                  "Cantidad límite unidades: ",
                  style: TitleTextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorUtil.black,
                      fontSize: 15),
                ),
                Text(
                  "${consigned.formattedMinLimit?.toString()} unid.",
                  style: TitleTextStyle(
                      fontWeight: FontWeight.bold,
                      color: _colorProvider.primary(),
                      fontSize: 25),
                ),
              ],
            )
          : const SizedBox(),
      consigned.balance != null
          ? Column(
              children: [
                const Text(
                  "Cantidad de unidades disponibles: ",
                  style: TitleTextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorUtil.black,
                      fontSize: 15),
                ),
                Text(
                  "${consigned.formattedBalance?.toString()} unid.",
                  style: TitleTextStyle(
                      fontWeight: FontWeight.bold,
                      color: _colorProvider.primary(),
                      fontSize: 25),
                ),
              ],
            )
          : const SizedBox(),
      TextButton(
          onPressed: () => _bloc()
              .goNext(path: StaticNames.details.name, product: consigned),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Ver detalles"), Icon(Icons.arrow_forward)],
          )),
      // consigned.minLimit != null ? MRichText.rich(title: "Cantidad límite unidades: ", text: "${consigned.formattedMinLimit?.toString()} unid." ?? "", fontSize: ) : SizedBox()
      // ,consigned.balance != null ? MRichText.rich(title: "Cantidad de unidades disponibles: ", text: "${consigned.formattedBalance?.toString()} unid." ?? "") : SizedBox()
    ]);
  }

  Widget _inventory(Results product, Results? consigned) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                product.type == "PREPAY"
                    ? Column(
                        children: [
                          const Text(
                            "INVENTARIO DISPONIBLE",
                            style: TitleTextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorUtil.black,
                                fontSize: 20),
                          ),
                          const Text(
                            "(Prepago)",
                            style: TitleTextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12),
                          ),
                          Text(
                            "${product.formattedBalance!} unid.",
                            style: TitleTextStyle(
                                fontWeight: FontWeight.bold,
                                color: _colorProvider.primary(),
                                fontSize: 30),
                          ),
                          TextButton(
                              onPressed: () => _bloc().goNext(
                                  path: StaticNames.details.name,
                                  product: product),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Ver detalles"),
                                  Icon(Icons.arrow_forward)
                                ],
                              )),
                          const SizedBox(height: 10),
                          consigned != null
                              ? _consigedWidget(consigned)
                              : const SizedBox(),
                        ],
                      )
                    : consigned != null
                        ? _consigedWidget(consigned)
                        : const SizedBox(),
              ]),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buttonGet(),
                  const SizedBox(width: 5),
                  _buttonPayment()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dialog(String errorMessage) => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(errorMessage),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "SPORT",
          style: TitleTextStyle(fontSize: 24, color: ColorUtil.white),
        ),
        centerTitle: true,
      ),
      //backgroundColor: _colorProvider.primaryLight(),
      body: BlocConsumer<StoreBloc, StoreState>(
        bloc: _bloc(),
        listener: (context, state) {
          if (state is StoreGoNextState) {
            if (state.product != null) {
              context.goNamed(state.next, extra: state.product);
            } else {
              if (state.listTypes != null) {
                context.goNamed(state.next, extra: state.listTypes);
              }
              // context.goNamed(state.next);
            }
          }
        },
        builder: (context, state) {
          if (state is StoreLoadedState) {
            var inventory = state.inventory?.results?[0];
            var consigned = state.consigned;

            if (inventory != null) {
              return _inventory(inventory, consigned);
            }
          }
          if (state is StoreLoadingState) {
            _bloc().mInventory();
            return _loadingCenter();
          }
          if (state is StoreErrorState) {
            return Center(
                child: SingleChildScrollView(
                    child: ShowErrorMessage(
                        errorMessage: state.errorMessage, error: true)));
          }
          return Center(
              child: SingleChildScrollView(
                  child: ShowErrorMessage(
                      errorMessage: "No hay inventario disponible",
                      error: false)));
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc().close();
    super.dispose();
  }
}
