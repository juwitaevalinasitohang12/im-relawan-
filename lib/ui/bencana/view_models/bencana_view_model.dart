import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_relawan/data/services/bencana_firestore_service.dart';
import 'package:im_relawan/data/services/bencana_repository_firebase_impl.dart';
import 'package:im_relawan/repositories/bencana_repository.dart';
import 'package:uuid/uuid.dart';


import 'package:im_relawan/domain/models/bencana_list.dart';

// Menginisiasi repositori yang digunakan
final bencanaRepositoryProvider = Provider<BencanaRepository>((ref) {
  // return BencanaRepositoryImpl(BencanaDatabaseService.instance); // nonaktif dulu SQL
  return BencanaRepositoryFirebaseImpl(BencanaFirestoreService());
});

class BencanaViewModel extends AsyncNotifier<List<BencanaList>> {
  // Generator id unik bertipe String
  final _uuid = const Uuid();

  @override
  Future<List<BencanaList>> build() async {
    final repository = ref.watch(bencanaRepositoryProvider);

    return repository.getAllBencana();
  }

  // TAMBAH DATA
  Future<bool> tambahBencana({
    required String name,
    required String location,
    required String description,
    required String nameReporter,
    required String phoneNumber,
  }) async {
    try {
      final repository = ref.read(bencanaRepositoryProvider);

      final sekarang = DateTime.now().toIso8601String();
      final uniqueId = _uuid.v4();

      final bencana = BencanaList(
        id: uniqueId,
        name: name,
        location: location,
        description: description,
        createdAt: sekarang,
        updatedAt: sekarang,
        nameReporter: nameReporter,
        phoneNumber: phoneNumber,
      );

      await repository.tambahBencana(bencana);

      state = AsyncData(
        await repository.getAllBencana(),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // UPDATE DATA
  Future<bool> updateBencana({
    required String id,
    required String createdAt,
    required String name,
    required String location,
    required String description,
    required String nameReporter,
    required String phoneNumber,
  }) async {
    try {
      final repository = ref.read(bencanaRepositoryProvider);

      final updated = BencanaList(
        id: id,
        name: name,
        location: location,
        description: description,
        createdAt: createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        nameReporter: nameReporter,
        phoneNumber: phoneNumber,
      );

      await repository.updateBencana(updated);

      final currentList = state.value ?? [];

      state = AsyncData([
        for (final b in currentList)
          if (b.id == id) updated else b,
      ]);

      return true;
    } catch (e) {
      return false;
    }
  }

  // DELETE DATA
  Future<bool> deleteBencana(String id) async {
    try {
      final repository = ref.read(bencanaRepositoryProvider);

      await repository.deleteBencana(id);

      state = AsyncData(
        await repository.getAllBencana(),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}

final bencanaViewModelProvider =
    AsyncNotifierProvider<BencanaViewModel, List<BencanaList>>(
  BencanaViewModel.new,
);