// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geap_fit/pages/agenda/models/store_model.dart';
import 'package:logger/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:optional/optional.dart';
import 'package:geap_fit/pages/agenda/bloc/agenda_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatLoadingState()) {
    on<ChatEvent>((event, emit) async {
      switch (event.runtimeType) {
        case ChatLoadingEvent:
          emit(ChatLoadingState(inventory: inventory));
          break;
        case ChatInitialEvent:
          emit(ChatInitialState(inventory: inventory));
          break;
        case ChatLoadedEvent:
          emit(
            ChatLoadedState(
              inventory: inventory,
              consigned: consigned,
              listTypes: listTypes,
            ),
          );
          break;
        case ChatErrorEvent:
          emit(ChatErrorState(errorMessage: errorMessage));
          break;
        case ChatGoNextEvent:
          emit(
            ChatGoNextState(
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
    add(const ChatGoNextEvent());
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
          add(const ChatLoadedEvent());
        } else {
          listTypes = [];
          _logger.i(result.errorMessage);
          errorMessage =
              result.errorMessage ??
              "El aliado no posee actualmente un inventario asignado";
          add(const ChatErrorEvent());
        }
      }
    } else {
      listTypes = [];
      _logger.i(result.errorMessage);
      errorMessage = result.errorMessage ?? "Error al obtener el inventario";
      add(const ChatErrorEvent());
    }
  }
}
