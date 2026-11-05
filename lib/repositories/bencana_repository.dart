import 'package:im_relawan/domain/models/bencana_list.dart';

abstract class BencanaRepository {
  Future<List<BencanaList>> getAllBencana();

  Future<void> deleteBencana(String id);

  Future<void> tambahBencana(BencanaList bencana);

  Future<void> updateBencana(BencanaList bencana);
}