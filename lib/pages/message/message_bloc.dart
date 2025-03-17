// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geap_fit/pages/agenda/models/store_model.dart';
import 'package:logger/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:optional/optional.dart';
import 'package:geap_fit/pages/agenda/bloc/agenda_service.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageLoadingState()) {
    on<MessageEvent>((event, emit) async {
      switch (event.runtimeType) {
        case MessageLoadingEvent:
          emit(MessageLoadingState(inventory: inventory));
          break;
        case MessageInitialEvent:
          emit(MessageInitialState(inventory: inventory));
          break;
        case MessageLoadedEvent:
          emit(
            MessageLoadedState(
              inventory: inventory,
              consigned: consigned,
              listTypes: listTypes,
            ),
          );
          break;
        case MessageErrorEvent:
          emit(MessageErrorState(errorMessage: errorMessage));
          break;
        case MessageGoNextEvent:
          emit(
            MessageGoNextState(
              next: next,
              product: mproduct,
              listTypes: listTypes,
            ),
          );
          break;
      }
    });
  }
  String next = "";
  String errorMessage = "";
  InventoryModel? inventory;
  final Logger _logger = Logger();
  List<String> listTypes = [];
  Results? consigned;
  Results? mproduct;

  void goNext({
    required String path,
    Results? product,
    List<String>? listTypes,
  }) {
    next = path;
    mproduct = product;
    listTypes = listTypes;
    add(const MessageGoNextEvent());
  }

  Future<void> mInventory() async {
    var result = await getInventory();
    if (result.success) {
      if (result.obj != null) {
        // inventory = result.obj;
        if (inventory?.count != 0) {
          for (int i = 0; i < inventory!.results!.length; i++) {
            if (inventory!.results![i].type != null) {
              listTypes.add(inventory!.results![i].type!);
            }
          }
          var consignedResult =
              inventory?.results
                  ?.where((x) => x.type == "POSTPAID" && (x.minLimit ?? 0) > 0)
                  .firstOptional
                  .orElseNull;
          if (consignedResult != null) {
            consigned = consignedResult;
          }
          add(const MessageLoadedEvent());
        } else {
          listTypes = [];
          _logger.i(result.errorMessage);
          errorMessage =
              result.errorMessage ??
              "El aliado no posee actualmente un inventario asignado";
          add(const MessageErrorEvent());
        }
      }
    } else {
      listTypes = [];
      _logger.i(result.errorMessage);
      errorMessage = result.errorMessage ?? "Error al obtener el inventario";
      add(const MessageErrorEvent());
    }
  }
}
