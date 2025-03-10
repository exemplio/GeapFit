// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_management/di/injection.dart';
import 'package:sports_management/domain/initDataModel.dart';
import 'package:sports_management/pages/withdraw/bloc/withdraw_bloc.dart';
import 'package:sports_management/styles/bg.dart';
import 'package:sports_management/styles/text.dart';
import 'package:sports_management/styles/theme_holder.dart';
import 'package:sports_management/utils/translate.dart';
import 'package:sports_management/widgets/alert_dialog.dart';

class WithdrawScreen extends StatefulWidget {
  List<String> listTypes;
  WithdrawScreen({required this.listTypes, super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  String? typeServiceSelected;
  String? typePhoneSelected;
  String? typeDniSelected;
  double totalBalance = 0.0;
  bool isTotal = true;
  double amountToPay = 0.0;
  Inventory inventoryService = Inventory();

  TextEditingController banksController = TextEditingController(text: "Bancos");
  TextEditingController numberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dniController = TextEditingController();

    late Color _primaryColor;

  final List<SelectedListItem> listBanks = [
    SelectedListItem(
      name: "0102 - Banco de Venezuela (BDV)",
      value: "0102",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0104 - Banco Venezolano de Crédito (BVC)",
      value: "0104",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0105 - Banco Mercantil",
      value: "0105",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0108 - Banco Provincial (BBVA)",
      value: "0108",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0114 - Bancaribe",
      value: "0114",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0115 - Banco Exterior",
      value: "0115",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0128 - Banco Caroní",
      value: "0128",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0134 - Banesco Banco Universal",
      value: "0134",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0114 - Bancaribe",
      value: "0114",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0151 - Banco Fondo Común (BFC)",
      value: "0151",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0163 - Banco del Tesoro",
      value: "0163",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0166 - Banco Agrícola de Venezuela",
      value: "0166",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0168 - Bancrecer",
      value: "0168",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0169 - Mi Banco, Banco Microfinanciero C.A",
      value: "0169",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0172 - Bancamiga",
      value: "0172",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0175 - Banco Bicentenario del Pueblo",
      value: "0175",
      isSelected: false,
    ),
    SelectedListItem(
      name: "0191 - Banco Nacional de Crédito (BNC)",
      value: "0191",
      isSelected: false,
    ),
  ];
  List<String> typesPhones = ["412", "414", "416", "424", "426"];
  List<String> typesDocs = ["V", "E", "J", "P"];

  WithdrawBloc _bloc() {
    return context.read<WithdrawBloc>();
  }

  @override
  void initState() {
    _primaryColor = getIt<ThemeHolder>().colorProvider().primary();
    typeDniSelected = typesDocs[0];
    typePhoneSelected = typesPhones[0];
    typeServiceSelected = widget.listTypes[0];
    getTotalBalance();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      body: BlocConsumer<WithdrawBloc, WithdrawState>(
          bloc: _bloc(),
          listener: (context, state) {
            if (state is WithdrawReloadingState) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    if (state.loaded) {
                      Navigator.pop(context);
                    }
                    return const PopScope(
                      canPop: false,
                      child: Center(
                          child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator())),
                    );
                  });
            }
            if (state is WithdrawErrorState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Alerts.error(
                      state.errorMsg, () => Navigator.pop(context));
                },
              );
            }
          },
          builder: (context, state) {
            var isLoading = state is WithdrawLoadingState;
            return SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [_pay(isLoading)],
                ),
              ),
            ));
          }),
    );
  }

  Form _pay(bool isLoading) {
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                        child: Text("RETIRO DE DINERO",
                            textAlign: TextAlign.center,
                            style: TitleTextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)))
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [Expanded(child: _typeService(isLoading))],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () {
                      dropdown();
                    },
                    child: TextFormField(
                      readOnly: false,
                      enabled: false,
                      validator: (value) {
                        if (value == "Bancos") {
                          return "Debe seleccionar un código de banco";
                        }
                        return null;
                      },
                      controller: banksController,
                      decoration: InputDecoration(
                        errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorUtil.error, width: 1)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _primaryColor,
                                width: 2)),
                        suffixIcon: const Icon(
                          Icons.arrow_downward,
                          color: Color.fromARGB(255, 97, 97, 97),
                        ),
                        label: Text("Bancos", style: subtitleStyleText("", 15)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _primaryColor)),
                        hintText: '',
                      ),
                    ),
                  ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(flex: 1, child: _typePhone(isLoading)),
                    const SizedBox(width: 5),
                    Flexible(flex: 3, child: _phoneNumber(isLoading))
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Balance: $totalBalance Bs",
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          enabled: !isLoading,
                          title: const Text("Monto total"),
                          leading: Radio(
                            value: true,
                            groupValue: isTotal,
                            onChanged: (value) {
                              if (!isTotal) {
                                setState(() {
                                  isTotal = true;
                                  amountToPay = totalBalance;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          enabled: !isLoading,
                          title: const Text("Otro monto"),
                          leading: Radio(
                            value: false,
                            groupValue: isTotal,
                            onChanged: (value) {
                              if (isTotal) {
                                setState(() {
                                  isTotal = false;
                                  amountToPay = 0;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ]),
                isTotal
                    ? const SizedBox()
                    : Row(
                        children: [Expanded(child: _amount(isLoading))],
                      ),
                const SizedBox(height: 10),
              ],
            ),
            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10),
            //   child: Text(
            //       "Pinpagos transferirá los fondos descontando comisiones bancarias que acarree el mismo",
            //       style: TextStyle(color: Colors.red)),
            // ),
            Row(
              children: [
                _buttonClean(isLoading),
                const SizedBox(width: 5),
                _buttonSend(isLoading)
              ],
            ),
          ],
        ));
  }

  void dropdown() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Banco a pagar", style: titleStyleText("", 18)),
            ],
          ),
        ),
        data: listBanks,
        selectedItems: (List<dynamic> selectedList) {
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              setState(() {
                banksController.text = item.value ?? "Bs";
              });
            }
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  _typeService(bool isLoading) {
    return SizedBox(
      height: 59,
      child: DropdownButtonFormField<String>(
        value: typeServiceSelected,
        icon: const Icon(Icons.arrow_downward),
        style: const TextStyle(color: Colors.deepPurple, fontFamily: "Kalinga"),
        isExpanded: true,
        validator: (type) => _bloc().validateTypeService(type),
        onChanged: isLoading
            ? null
            : (type) {
                setTypeService(type);
                getTotalBalance();
              },
        items: widget.listTypes.map<DropdownMenuItem<String>>((String type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(translate(type),
                style: const TitleTextStyle(color: ColorUtil.dark_gray)),
          );
        }).toList(),
      ),
    );
  }

  _typePhone(bool isLoading) {
    return SizedBox(
      height: 59,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: isLoading
                  ? const BorderSide(
                      color: Color.fromARGB(255, 199, 199, 199), width: 1)
                  : BorderSide(color: _primaryColor, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderSide: isLoading
                  ? const BorderSide(
                      color: Color.fromARGB(255, 199, 199, 199), width: 1)
                  : BorderSide(color: _primaryColor, width: 2)),
        ),
        value: typePhoneSelected,
        icon: const Icon(Icons.arrow_downward),
        style: const TextStyle(color: Colors.deepPurple, fontFamily: "Kalinga"),
        isExpanded: true,
        validator: (type) => _bloc().validateTypePhone(type),
        onChanged: isLoading ? null : (type) => setTypePhone(type),
        items: typesPhones.map<DropdownMenuItem<String>>((String type) {
          return DropdownMenuItem<String>(
              value: type,
              child: Text(type,
                  style: const TitleTextStyle(color: ColorUtil.dark_gray)));
        }).toList(),
      ),
    );
  }

  _typeDoc(bool isLoading) {
    return SizedBox(
      height: 59,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: isLoading
                  ? const BorderSide(
                      color: Color.fromARGB(255, 199, 199, 199), width: 1)
                  : BorderSide(color: _primaryColor, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderSide: isLoading
                  ? const BorderSide(
                      color: Color.fromARGB(255, 199, 199, 199), width: 1)
                  : BorderSide(color: _primaryColor, width: 2)),
        ),
        value: typeDniSelected,
        icon: const Icon(Icons.arrow_downward),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(color: Colors.deepPurple, fontFamily: "Kalinga"),
        isExpanded: true,
        validator: (type) => _bloc().validateTypeDni(type),
        onChanged: isLoading ? null : (type) => setTypeDoc(type),
        items: typesDocs.map<DropdownMenuItem<String>>((String type) {
          return DropdownMenuItem<String>(
              enabled: !isLoading,
              value: type,
              child: Text(type,
                  style: const TitleTextStyle(color: ColorUtil.dark_gray)));
        }).toList(),
      ),
    );
  }

  SizedBox _phoneNumber(bool isLoading) {
    return SizedBox(
      height: 79,
      child: TextFormField(
        controller: numberController,
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
      ),
    );
  }

  SizedBox _dni(bool isLoading) {
    return SizedBox(
      height: 79,
      child: TextFormField(
        controller: dniController,
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
      ),
    );
  }

  SizedBox _amount(bool isLoading) => SizedBox(
        height: 79,
        child: TextFormField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          maxLength: 9,
          readOnly: false,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          inputFormatters: [_bloc().numFormat],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (amount) => _bloc().validateAmount(amount),
          onChanged: (amount) => setAmount(amount),
          decoration: const InputDecoration(
              labelText: "Monto", border: OutlineInputBorder(), hintText: ''),
        ),
      );

  Widget _buttonClean(bool isLoading) {
    return Expanded(
      child: TextButton.icon(
          icon: const Icon(Icons.restore_from_trash_sharp,
              color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: ColorUtil.gray,
              padding: const EdgeInsets.all(20)),
          onPressed: !isLoading ? clean : null,
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
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.all(20)),
          onPressed: () async => _formKey.currentState!.validate() && !isLoading
              ? await payDialog(context)
              : null,
          label: isLoading
              ? const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(color: ColorUtil.white))
              : const Text("RETIRAR",
                  style: TitleTextStyle(color: ColorUtil.white, fontSize: 14))),
    );
  }

  setTypeService(String? type) {
    typeServiceSelected = type ?? widget.listTypes[0];
  }

  setTypePhone(String? type) {
    typePhoneSelected = type ?? typesPhones[0];
  }

  setTypeDoc(String? type) {
    typeDniSelected = type ?? typesDocs[0];
  }

  setAmount(String? amount) {
    if (!isTotal && amount != null) {
      amountToPay = double.parse(amount.replaceAll(",", "."));
    }
    if (amount != null && amount.trim() != "") {
      amountController.value = TextEditingValue(
        text: amount,
        selection: TextSelection.collapsed(offset: amount.length),
      );
    }
  }

  clean() {
    setState(() {
      typeDniSelected = typesDocs[0];
      typePhoneSelected = typesPhones[0];
      typeServiceSelected = widget.listTypes[0];
      numberController.text = "";
      dniController.text = "";
      amountController.text = "";
      numberController.text = "";
      dniController.text = "";
      amountController.text = "";
      banksController.text = "Bancos";
      totalBalance = 0;
    });
  }

  getTotalBalance() async {
/*     var getInit = await cache.getInitData();
    if (getInit != null) {
      List<Inventory>? roleInv = getInit.inventories;
      if (roleInv != null) {
        if (roleInv.isNotEmpty) {
          inventoryService = roleInv
              .where((inventory) => inventory.type == typeServiceSelected)
              .toList()
              .first;
          if (inventoryService.balance == 0) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "No hay saldo para retirar en tu inventario ${translate(inventoryService.type!).toLowerCase()}"),
              duration: const Duration(seconds: 2),
            ));
          }
          setState(() {
            totalBalance = inventoryService.balance;
          });
        } else {
          _bloc().add(const WithdrawErrorEvent(
              "El aliado no posee actualmente un inventario asignado"));
        }
      } else {
        _bloc().add(const WithdrawErrorEvent(
            "El aliado no posee actualmente un inventario asignado"));
      }
    } */
  }

  payDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          var dni = "$typeDniSelected${dniController.text.padLeft(9, "0")}";
          var phone =
              '$typePhoneSelected${_bloc().maskFormatter.unmaskText(numberController.text)}';
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text("Verifica los datos antes de aceptar",
                style: TextStyle(
                    color: _primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                    text: TextSpan(
                        children: [
                      const TextSpan(text: "Monto: "),
                      TextSpan(
                          text: "${amountController.text} Bs",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                        style: const TextStyle(
                            fontFamily: "Kalinga",
                            color: Colors.black,
                            fontSize: 16))),
                RichText(
                    text: TextSpan(
                        children: [
                      const TextSpan(text: " Banco: "),
                      TextSpan(
                          text: banksController.text,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                        style: const TextStyle(
                            fontFamily: "Kalinga",
                            color: Colors.black,
                            fontSize: 16))),
                RichText(
                    text: TextSpan(
                        children: [
                      const TextSpan(text: " CI: "),
                      TextSpan(
                          text: dni,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                        style: const TextStyle(
                            fontFamily: "Kalinga",
                            color: Colors.black,
                            fontSize: 16))),
                RichText(
                    text: TextSpan(
                        children: [
                      const TextSpan(text: " Teléfono: "),
                      TextSpan(
                          text: phone,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                        style: const TextStyle(
                            fontFamily: "Kalinga",
                            color: Colors.black,
                            fontSize: 16))),
                RichText(
                    text: TextSpan(
                        children: [
                      const TextSpan(text: " Inventario: "),
                      TextSpan(
                          text: typeServiceSelected,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                        style: const TextStyle(
                            fontFamily: "Kalinga",
                            color: Colors.black,
                            fontSize: 16))),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("CERRAR",
                      style: TextStyle(color: Colors.white))),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(_primaryColor)),
                  onPressed: () {
                    sendRecharge();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ACEPTAR",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );
        });
  }

  sendRecharge() {
    Map<String, dynamic> params = {
      "inventory_owner_id": inventoryService.businessId
    };
    Map<String, dynamic> body = {
      "total_amount": amountToPay,
      "inventory_type": typeServiceSelected,
    };
    _bloc().sendRecharge(body, params);
  }
}
