import 'package:im_relawan/data/services/bencana_firestore_service.dart';
import 'package:im_relawan/domain/models/bencana_list.dart';
import 'package:im_relawan/repositories/bencana_repository.dart';

class BencanaRepositoryFirebaseImpl implements BencanaRepository {
  BencanaRepositoryFirebaseImpl(this._service);

  final BencanaFirestoreService _service;

  // CREATE
  @override
  Future<void> tambahBencana(BencanaList bencana) async {
    await _service.setBencana(bencana.id!, {
      // 'id': bencana.id, // hapus field id (id jadi identitas document)
      'name': bencana.name,
      'location': bencana.location,
      'description': bencana.description,
      'createdAt': bencana.createdAt,
      'updatedAt': bencana.updatedAt,
      'nameReporter': bencana.nameReporter,
      'phoneNumber': bencana.phoneNumber,
    });
  }

  // READ
  @override
  Future<List<BencanaList>> getAllBencana() async {
    final rows = await _service.getAllBencana();

    return rows
        .map(
          (row) => BencanaList(
            name: row['name'] as String,
            location: row['location'] as String,
            description: row['description'] as String,
            createdAt: row['createdAt'] as String,
            updatedAt: row['updatedAt'] as String,
            nameReporter: row['nameReporter'] as String,
            phoneNumber: row['phoneNumber'] as String,
            id: row['id'] as String,
          ),
        )
        .toList();
  }

  // UPDATE
  @override
  Future<void> updateBencana(BencanaList bencana) async {
    await _service.updateBencana(bencana.id!, {
      'name': bencana.name,
      'location': bencana.location,
      'description': bencana.description,
      'createdAt': bencana.createdAt,
      'updatedAt': bencana.updatedAt,
      'nameReporter': bencana.nameReporter,
      'phoneNumber': bencana.phoneNumber,
    });
  }

  // DELETE
  @override
  Future<void> deleteBencana(String id) async {
    await _service.deleteBencana(id);
  }
}