part of 'agenda_bloc.dart';

abstract class AgendaEvent {
  const AgendaEvent();
}

class AgendaInitialEvent extends AgendaEvent {
  AgendaInitialEvent();
}

class AgendaLoadedEvent extends AgendaEvent {
  AgendaLoadedEvent();
}

class AgendaLoadingEvent extends AgendaEvent {
  AgendaLoadingEvent();
}

class AgendaErrorEvent extends AgendaEvent {
  AgendaErrorEvent();
}

class AgendaRefreshEvent extends AgendaEvent {
  AgendaRefreshEvent();
}
