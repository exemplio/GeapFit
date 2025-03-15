// ignore_for_file: must_be_immutable, depend_on_referenced_packages, unnecessary_null_comparison, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/pages/store/models/collect_channel_model.dart';
import 'package:geap_fit/styles/color_provider/color_provider.dart';
import 'package:geap_fit/styles/theme_provider.dart';
import 'package:geap_fit/utils/error_message.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import 'package:geap_fit/utils/translate.dart';
import 'package:geap_fit/widgets/rich_text.dart';

import '../../styles/bg.dart';
import '../../styles/text.dart';
import 'bloc/recharge_bloc.dart';

class RechageScreen extends StatefulWidget {
  RechargeBloc bloc;

  RechageScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<RechageScreen> createState() => _RechageScreenState();
}

class _RechageScreenState extends State<RechageScreen> {
  final _formKey = GlobalKey<FormState>();
  final ColorProvider _colorProvider = getIt<ThemeProvider>().colorProvider();
  RechargeBloc _bloc() {
    return widget.bloc;
  }

  @override
  void initState() {
    _bloc().setInit();
    super.initState();
  }

  Widget _buttonClean(bool isLoading) {
    return Expanded(
      child: TextButton.icon(
          icon: const Icon(Icons.restore_from_trash_sharp,
              color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: ColorUtil.gray,
              padding: const EdgeInsets.all(20)),
          onPressed: !isLoading ? _bloc().clean : null,
          label: const Text("LIMPIAR",
              style: TitleTextStyle(color: ColorUtil.white))),
    );
  }

  Widget _buttonSend(bool isLoading) {
    return Expanded(
      child: TextButton.icon(
          icon: isLoading
              ? const SizedBox()
              : const Icon(Icons.payment_outlined, color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: isLoading
                  ? _colorProvider.primaryLight()
                  : _colorProvider.primary(),
              padding: const EdgeInsets.all(20)),
          onPressed: () async => _formKey.currentState!.validate() && !isLoading
              ? await _bloc().sendRechage()
              : null,
          label: isLoading
              ? const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(color: ColorUtil.white))
              : const Text("VALIDAR",
                  style: TitleTextStyle(color: ColorUtil.white, fontSize: 14))),
    );
  }

  Widget _header(BankInfo? bank) {
    var bankName = bank!.acronym != null
        ? "banks/${bank.acronym!.toLowerCase()}"
        : "not_found";
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 10),
          Column(children: [
            // Icon(Icons.phone_iphone, color: Colors.black, size: 75),
            Text("Pago móvil",
                style:
                    TitleTextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ]),
          // Column(children: [
          //   Text("Monto a pagar", style: TitleTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          //   Text("Bs. 50.00", style: TitleTextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _colorProvider.primaryLight()))
          // ]),
          // bank != null
          //     ? Image.asset("assets/img/$bankName.png", width: 250, height: 150)
          //     : const SizedBox(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  DropdownButtonFormField<CollectMethods> _banks(bool isLoading) {
    var banks = _bloc().banks;
    return DropdownButtonFormField<CollectMethods>(
      value: _bloc().bankSelected,
      icon: const Icon(Icons.arrow_downward),
      style: const TextStyle(color: Colors.deepPurple),
      isExpanded: true,
      onChanged: isLoading ? null : (bank) => _bloc().setBank(bank),
      validator: (bank) => _bloc().validateBank(bank),
      items:
          banks?.map<DropdownMenuItem<CollectMethods>>((CollectMethods bank) {
        return DropdownMenuItem<CollectMethods>(
            enabled: !isLoading,
            value: bank,
            child: MRichText.rich(
                title: "${bank.bankInfo?.acronym} - ",
                text: bank.bankInfo?.name ?? "",
                fontSize: 13));
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _typeDoc(bool isLoading) {
    return DropdownButtonFormField<String>(
      value: _bloc().typeDniSelected,
      icon: const Icon(Icons.arrow_downward),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: Colors.deepPurple),
      isExpanded: true,
      validator: (type) => _bloc().validateTypeDni(type),
      onChanged: isLoading ? null : (type) => _bloc().setTypeDoc(type),
      items: _bloc().types_docs.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
            enabled: !isLoading,
            value: type,
            child: Text(type,
                style: const TitleTextStyle(color: ColorUtil.dark_gray)));
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _typeService(bool isLoading) {
    return DropdownButtonFormField<String>(
      value: _bloc().typeServiceSelected,
      icon: const Icon(Icons.arrow_downward),
      style: const TextStyle(color: Colors.deepPurple),
      isExpanded: true,
      validator: (type) => _bloc().validateTypeService(type),
      onChanged: isLoading ? null : (type) => _bloc().setTypeService(type),
      items: _bloc().listTypes.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(translate(type),
              style: const TitleTextStyle(color: ColorUtil.dark_gray)),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _typePhone(bool isLoading) {
    return DropdownButtonFormField<String>(
      value: _bloc().typePhoneSelected,
      icon: const Icon(Icons.arrow_downward),
      style: const TextStyle(color: Colors.deepPurple),
      isExpanded: true,
      validator: (type) => _bloc().validateTypePhone(type),
      onChanged: isLoading ? null : (type) => _bloc().setTypePhone(type),
      items: _bloc().types_phones.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
            value: type,
            child: Text(type,
                style: const TitleTextStyle(color: ColorUtil.dark_gray)));
      }).toList(),
    );
  }

  Widget _rowInformation({required String title, required String text}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text(title,
                  style: const TitleTextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal))),
          Expanded(
            flex: 3,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(text,
                          textAlign: TextAlign.end,
                          style: const TitleTextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: 4,
                  ),
                  title == "Número de teléfono"
                      ? Expanded(
                          flex: 1,
                          child: IconButton(
                              icon: const Icon(Icons.paste),
                              onPressed: () => Clipboard.setData(ClipboardData(
                                      text: text.substring(5, 14)))
                                  .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              "$title copiado con éxito"))))))
                      : const SizedBox(),
                  title == "Rif"
                      ? Expanded(
                          flex: 1,
                          child: IconButton(
                              icon: const Icon(Icons.paste),
                              onPressed: () => Clipboard.setData(ClipboardData(
                                      text: text.substring(1, text.length)))
                                  .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              "$title copiado con éxito"))))))
                      : const SizedBox(),
                  title != "Banco" &&
                          title != "Número de teléfono" &&
                          title != "Rif"
                      ? Expanded(
                          flex: 1,
                          child: IconButton(
                              icon: const Icon(Icons.paste),
                              onPressed: () => Clipboard.setData(
                                      ClipboardData(text: text))
                                  .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              "$title copiado con éxito"))))))
                      : const SizedBox(),
                ]),
          ),
        ],
      );

  Widget _informationRecharge(CollectMethods bank) {
    return Center(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("REALIZAR PAGO MÓVIL A:",
                  style:
                      TitleTextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ],
          ),
          //_rowInformation(title: "Monto mínimo de compra", text: "${_bloc().formattedRate} bs" ?? ""),
          // SizedBox(height: 5),
          // _rowInformation(title: "Tasa del día", text: "${_bloc().showRate} bs" ?? ""),
          const SizedBox(height: 5),
          _rowInformation(
              title: "Número de teléfono", text: bank.formattedPhone ?? ""),
          const SizedBox(height: 5),
          _rowInformation(title: "Rif", text: bank.idDoc ?? ""),
          const SizedBox(height: 5),
          _rowInformation(title: "Banco", text: bank.bankInfo?.name ?? ""),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _noteRechange() {
    return const Column(
      children: [
        Wrap(
          children: [
            Text("Nota: ",
                style: TitleTextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorUtil.error,
                    fontSize: 15)),
            Text(
                "Los pagos se deben registrar el mismo dia de realizados, de lo contrario tendra problemas para la recarga automática, de ser asi por favor enviar el soporte del pago,número de telefono pagador, rif del pagador, rif registrado en el sistema al correo: Soportepos@sunmivzla.com, o a los siguientes números: \n 0424919488, 04128133097, 04241254792",
                textAlign: TextAlign.justify,
                style: TitleTextStyle(
                    fontWeight: FontWeight.normal, fontSize: 15)),
          ],
        ),
      ],
    );
  }

  TextFormField _amount(bool isLoading) => TextFormField(
        controller: _bloc().amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        maxLength: 9,
        readOnly: false,
        enabled: !isLoading,
        textInputAction: TextInputAction.next,
        inputFormatters: [_bloc().numFormat],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (amount) => _bloc().validateAmount(amount),
        onChanged: (amount) => _bloc().setAmount(amount),
        decoration: const InputDecoration(
            // prefixIcon: Column(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text("Bs."),
            //     SizedBox(height: 4)
            //   ],),
            labelText: "Monto",
            border: OutlineInputBorder(),
            hintText: ''),
      );

  TextFormField _phoneNumber(bool isLoading) {
    return TextFormField(
      controller: _bloc().numberController,
      keyboardType: TextInputType.number,
      maxLength: 8,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      inputFormatters: [_bloc().maskFormatter],
      validator: (value) => _bloc().validateNumber(value),
      decoration: const InputDecoration(
          labelText: "Número de teléfono",
          border: OutlineInputBorder(),
          hintText: ''),
    );
  }

  // TextFormField _datePayment(bool isLoading){
  //   return TextFormField(
  //     showCursor: false,
  //     mouseCursor: MouseCursor.uncontrolled,
  //     controller: _bloc().dateController,
  //     keyboardType: TextInputType.none,
  //     onTap: () =>
  //         Calendary.pickDateDialog(context, (date) => _bloc().setDate(date)),
  //     maxLength: 12,
  //     readOnly: false,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     enabled: !isLoading,
  //     validator: (value) => _bloc().validateDate(value),
  //     decoration: InputDecoration(
  //         labelText: "Fecha de pago",
  //         border: OutlineInputBorder(),
  //         hintText: ''),
  //   );
  // }
  //
  TextFormField _dni(bool isLoading) {
    return TextFormField(
      controller: _bloc().dniController,
      keyboardType: TextInputType.number,
      maxLength: 9,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$'))
      ],
      validator: (value) => _bloc().validateDni(value),
      decoration: const InputDecoration(
          labelText: "Cédula", border: OutlineInputBorder(), hintText: ''),
    );
  }

  TextFormField _reference(bool isLoading) {
    return TextFormField(
      controller: _bloc().referenceController,
      keyboardType: TextInputType.number,
      maxLength: 12,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$'))
      ],
      validator: (value) => _bloc().validateReference(value),
      decoration: const InputDecoration(
          labelText: "Referencia",
          border: OutlineInputBorder(),
          hintText: '000000'),
    );
  }

  Form _pay(bool isLoading) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 15),
          _noteRechange(),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                  child: Text("COLOCA LOS DATOS DEL PAGO MÓVIL REALIZADO",
                      textAlign: TextAlign.center,
                      style: TitleTextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)))
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [Expanded(child: _typeService(isLoading))],
          ),
          // SizedBox(height: 20),
          // Row(children: [
          //   Expanded(child: _banks(isLoading))
          // ],),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(flex: 1, child: _typePhone(isLoading)),
              const SizedBox(width: 5),
              Flexible(flex: 3, child: _phoneNumber(isLoading))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [Expanded(child: _amount(isLoading))],
          ),

          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(flex: 1, child: _typeDoc(isLoading)),
              const SizedBox(width: 5),
              Flexible(flex: 3, child: _dni(isLoading))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [Expanded(child: _reference(isLoading))],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buttonClean(isLoading),
              const SizedBox(width: 5),
              _buttonSend(isLoading)
            ],
          ),
        ],
      ),
    );
  }

  void dialog(String errorMessage) => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title:
                Text(errorMessage, style: const TitleTextStyle(fontSize: 16)),
            actions: [
              TextButton(
                  child: const Text('Regresar'),
                  onPressed: () => {
                        if (errorMessage == "Pago exitoso")
                          {
                            context.go(StaticNames.store.path),
                            Navigator.of(context).pop(),
                          }
                        else
                          {
                            Navigator.of(context).pop(),
                          }
                      })
            ]);
      });

  Widget _loadingCenter() {
    return const Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
            SizedBox(height: 10),
            Text("Cargando información")
          ]),
    );
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
      body: BlocConsumer<RechargeBloc, RechargeState>(
        bloc: _bloc(),
        listener: (_, state) {
          if (state is RechargeErrorPaymentState) {
            var errorMessage = state.errorMessage;
            dialog(errorMessage);
          }
          if (state is RechargeSuccessState) {
            dialog("Pago exitoso");
            _bloc().clean();
          }
        },
        builder: (_, state) {
          bool isLoading = state is RechargeLoadingState;
          if (state is RechargeInitialState) {
            _bloc().setInit();
            return _loadingCenter();
          }
          if (state is RechargeErrorState) {
            return ShowErrorMessage(
                errorMessage: state.errorMessage, error: true);
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: MediaQuery.of(context).size.height > 432
                  ? Visibility(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _bloc().bankSelected != null
                              ? _header(_bloc().bankSelected!.bankInfo)
                              : const SizedBox(),
                          _bloc().bankSelected != null
                              ? _informationRecharge(_bloc().bankSelected!)
                              : const SizedBox(),
                          _pay(isLoading)
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // _bloc().bankSelected!=null ? _header(_bloc().bankSelected!.bankInfo): SizedBox(),
                        _bloc().bankSelected != null
                            ? _informationRecharge(_bloc().bankSelected!)
                            : const SizedBox(),
                        _pay(isLoading)
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
