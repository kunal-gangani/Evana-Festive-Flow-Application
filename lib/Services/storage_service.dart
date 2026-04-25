import 'dart:async';

import 'package:evana_event_management_app/Helpers/app_exception.dart';
import 'package:evana_event_management_app/Models/ticket_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  static const String _ticketsBoxName = 'user_tickets';

  Future<void>? _initialization;
  Future<void> _operationQueue = Future<void>.value();
  Box<dynamic>? _ticketsBox;

  Future<void> initialize({
    String? storagePath,
  }) {
    return _initialization ??= _initializeInternal(storagePath: storagePath);
  }

  Future<void> _initializeInternal({
    String? storagePath,
  }) async {
    try {
      if (storagePath == null) {
        await Hive.initFlutter();
      } else {
        Hive.init(storagePath);
      }
      _ticketsBox = await Hive.openBox<dynamic>(_ticketsBoxName);
    } catch (_) {
      throw AppException('Unable to initialize local storage.');
    }
  }

  Future<List<TicketModel>> getTickets() {
    return _enqueue<List<TicketModel>>(() async {
      try {
        await initialize();

        final tickets = _ticketsBox!.values
            .whereType<Map>()
            .map(TicketModel.fromMap)
            .toList()
          ..sort(
            (left, right) => right.purchaseDate.compareTo(left.purchaseDate),
          );

        return List<TicketModel>.unmodifiable(tickets);
      } on AppException {
        rethrow;
      } catch (_) {
        throw AppException('Unable to restore your saved tickets.');
      }
    });
  }

  Future<void> saveTicket(TicketModel ticket) {
    return _enqueue<void>(() async {
      try {
        await initialize();
        await _ticketsBox!.put(ticket.secureHash, ticket.toMap());
      } on AppException {
        rethrow;
      } catch (_) {
        throw AppException('Unable to save your ticket locally.');
      }
    });
  }

  Future<TicketModel?> getTicketByHash(String secureHash) {
    return _enqueue<TicketModel?>(() async {
      try {
        await initialize();

        final directValue = _ticketsBox!.get(secureHash);
        if (directValue is Map) {
          return TicketModel.fromMap(directValue);
        }

        for (final dynamic value in _ticketsBox!.values) {
          if (value is! Map) {
            continue;
          }

          final ticket = TicketModel.fromMap(value);
          if (ticket.secureHash == secureHash) {
            return ticket;
          }
        }

        return null;
      } on AppException {
        rethrow;
      } catch (_) {
        throw AppException('Unable to read the scanned ticket.');
      }
    });
  }

  Future<TicketModel> markTicketAsScanned(String secureHash) {
    return _enqueue<TicketModel>(() async {
      try {
        await initialize();

        dynamic storageKey = secureHash;
        dynamic value = _ticketsBox!.get(secureHash);

        if (value is! Map) {
          for (final dynamic key in _ticketsBox!.keys) {
            final dynamic entry = _ticketsBox!.get(key);
            if (entry is! Map) {
              continue;
            }

            final ticket = TicketModel.fromMap(entry);
            if (ticket.secureHash == secureHash) {
              storageKey = key;
              value = entry;
              break;
            }
          }
        }

        if (value is! Map) {
          throw AppException('This ticket could not be found.');
        }

        final updatedTicket = TicketModel.fromMap(value).copyWith(
          isScanned: true,
        );

        await _ticketsBox!.delete(storageKey);
        await _ticketsBox!.put(updatedTicket.secureHash, updatedTicket.toMap());
        return updatedTicket;
      } on AppException {
        rethrow;
      } catch (_) {
        throw AppException('Unable to update ticket entry status.');
      }
    });
  }

  Future<void> clearTickets() {
    return _enqueue<void>(() async {
      try {
        await initialize();
        await _ticketsBox!.clear();
      } on AppException {
        rethrow;
      } catch (_) {
        throw AppException('Unable to clear saved tickets.');
      }
    });
  }

  Future<T> _enqueue<T>(Future<T> Function() action) {
    final completer = Completer<T>();

    _operationQueue = _operationQueue.catchError((Object _) {}).then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });

    return completer.future;
  }
}
