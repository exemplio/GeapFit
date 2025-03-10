// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:sports_management/pages/details/bloc/details_bloc.dart';
import 'package:sports_management/styles/bg.dart';
import 'package:sports_management/styles/text.dart';
import 'package:sports_management/utils/error_message.dart';
import '../../widgets/calendary.dart';
import 'models/details_report_model.dart';

class DetailsScreen extends StatefulWidget {
  DetailsBloc bloc;
  DetailsScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  DetailsBloc _bloc() => widget.bloc;
  final format2 = DateFormat('y-MM-dd');

  @override
  void initState() {
    _bloc().init();
    super.initState();
  }

  DatePickerDialog? calendaryInitial() =>
      Calendary.pickDateDialog(context, (DateTime? date) {
        if (date != null) {
          _bloc().setDateGte(dateGte: format2.format(date.toLocal()));
        }
      });
  DatePickerDialog? calendaryFinal() =>
      Calendary.pickDateDialog(context, (DateTime? date) {
        if (date != null) {
          _bloc().setDateLte(dateLte: format2.format(date.toLocal()));
        }
      });

  TextFormField _datePaymentInitial(bool isLoading) {
    return TextFormField(
      showCursor: false,
      mouseCursor: MouseCursor.uncontrolled,
      controller: _bloc().dateInitialController,
      keyboardType: TextInputType.none,
      onTap: calendaryInitial,
      maxLength: 12,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      validator: _bloc().validateInitialDate,
      decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: calendaryInitial,
              icon: const Icon(Icons.date_range_rounded)),
          suffixIcon: IconButton(
              onPressed: getInventario, icon: const Icon(Icons.search)),
          labelText: "Período (inicio)",
          border: const OutlineInputBorder(),
          hintText: ''),
    );
  }

  TextFormField _datePaymentInitialMini(bool isLoading) {
    return TextFormField(
      showCursor: false,
      mouseCursor: MouseCursor.uncontrolled,
      controller: _bloc().dateInitialController,
      keyboardType: TextInputType.none,
      onTap: calendaryInitial,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      validator: _bloc().validateInitialDate,
      decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: calendaryInitial,
              icon: const Icon(Icons.date_range_rounded)),
          suffixIcon: IconButton(
              onPressed: getInventario, icon: const Icon(Icons.search)),
          labelText: "Período (inicio)",
          border: const OutlineInputBorder(),
          hintText: ''),
    );
  }

  TextFormField _datePaymentFinal(bool isLoading) {
    return TextFormField(
      showCursor: false,
      mouseCursor: MouseCursor.uncontrolled,
      controller: _bloc().dateFinalController,
      keyboardType: TextInputType.none,
      onTap: calendaryFinal,
      maxLength: 12,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      validator: _bloc().validateEndDate,
      decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: calendaryFinal,
              icon: const Icon(Icons.date_range_rounded)),
          suffixIcon: IconButton(
              onPressed: getInventario, icon: const Icon(Icons.search)),
          labelText: "Período (fin)",
          border: const OutlineInputBorder(),
          hintText: ''),
    );
  }

  TextFormField _datePaymentFinalMini(bool isLoading) {
    return TextFormField(
      showCursor: false,
      mouseCursor: MouseCursor.uncontrolled,
      controller: _bloc().dateFinalController,
      keyboardType: TextInputType.none,
      onTap: calendaryFinal,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      validator: _bloc().validateEndDate,
      decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: calendaryFinal,
              icon: const Icon(Icons.date_range_rounded)),
          suffixIcon: IconButton(
              onPressed: getInventario, icon: const Icon(Icons.search)),
          labelText: "Período (fin)",
          border: const OutlineInputBorder(),
          hintText: ''),
    );
  }

  NumberPaginator _paginate() {
    return NumberPaginator(
      controller: _bloc().paginateController,
      numberPages: _bloc().totalPages,
      initialPage: _bloc().currentPage,
      onPageChange: _bloc().setPageChange,
    );
  }

  Widget _filters(bool isLoading) {
    return MediaQuery.of(context).size.height > 432
        ? Visibility(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _datePaymentInitial(isLoading)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _datePaymentFinal(isLoading)),
                    ],
                  ),
                  const Divider()
                ]),
              ),
            ),
          )
        : Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _datePaymentInitialMini(isLoading)),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10)),
                    Expanded(child: _datePaymentFinalMini(isLoading)),
                  ],
                ),
                const Divider()
              ]),
            ),
          );
  }

  Widget get _loadingCenter => const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 50, height: 50, child: CircularProgressIndicator()),
              SizedBox(height: 10),
              Text("Cargando detalles")
            ]),
      );

  Widget _rowDetail(
      {required String title, required String text, Color? colorTwo}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text(
                title,
                style: const TitleTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorUtil.dark_gray),
              )),
          Expanded(
              flex: 3,
              child: Text(text,
                  textAlign: TextAlign.right,
                  style: TitleTextStyle(
                      fontSize: 14, color: colorTwo ?? ColorUtil.dark_gray)))
        ]);
  }

  Widget _detail(Movement result) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _rowDetail(title: "Fecha", text: result.formattedTimestamp ?? ""),
            _rowDetail(title: "Tipo", text: result.formattedType ?? ""),
            _rowDetail(
                title: "Descripción",
                text:
                    "${result.formattedDescription ?? ""} - ${result.formattedService ?? ""}"),
            _rowDetail(
                title: result.type == "IN" ? "Entrada" : "Salida",
                text: result.formattedAmount ?? "",
                colorTwo:
                    result.type == "IN" ? ColorUtil.success : ColorUtil.error),
            _rowDetail(
                title: "Saldo",
                text: result.formattedInventoryBalanceAfter ?? ""),
          ],
        ),
      ),
    );
  }

  Widget _listReport({required bool isLoading, DetailsReportModel? report}) {
    if (isLoading) {
      return Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _loadingCenter,
        ],
      ));
    }
    var results = report?.results ?? [];
    return Expanded(
      child: Column(
        mainAxisAlignment: results.isEmpty
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          results.isEmpty
              ? Column(
                  children: [
                    Center(
                      child: IconButton(
                        onPressed: getInventario,
                        icon: const Center(
                            child: Icon(
                          Icons.search,
                          size: 50,
                        )),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(child: Text("Buscar detalles")),
                  ],
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return _detail(results[index]);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void getInventario() {
    bool state = _formKey.currentState!.validate();
    if (state) {
      _bloc().getInv();
    }
  }

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
      body: BlocConsumer<DetailsBloc, DetailsState>(
        bloc: _bloc(),
        listener: (context, state) {},
        builder: (context, state) {
          var isLoading = state is DetailsLoadingState;
          var showError = state is DetailsErrorState;
          return MediaQuery.of(context).size.height > 432
              ? Visibility(
                  child: Column(
                    children: [
                      _filters(isLoading),
                      showError
                          ? Expanded(
                              child: SingleChildScrollView(
                                  child: ShowErrorMessage(
                                      errorMessage: state.errorMessage!,
                                      error: true)))
                          : _listReport(
                              isLoading: isLoading, report: state.report),
                      state.report != null ? _paginate() : const SizedBox()
                    ],
                  ),
                )
              : ListView(
                  children: [
                    _filters(isLoading),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      child: showError
                          ? ShowErrorMessage(
                              errorMessage: state.errorMessage!, error: true)
                          : _listReport(
                              isLoading: isLoading, report: state.report),
                    ),
                    state.report != null ? _paginate() : const SizedBox()
                  ],
                );
        },
      ),
    );
  }
}
