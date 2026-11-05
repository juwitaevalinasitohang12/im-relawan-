import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:im_relawan/domain/models/bencana_list.dart';
import 'package:im_relawan/ui/bencana/view_models/bencana_view_model.dart';


class EditBencanaScreen extends ConsumerStatefulWidget {
  const EditBencanaScreen({
    super.key,
    required this.bencana,
  });

  final BencanaList bencana;

  @override
  ConsumerState<EditBencanaScreen> createState() =>
      _EditBencanaScreenState();
}

class _EditBencanaScreenState
    extends ConsumerState<EditBencanaScreen> {

  // CONTROLLER
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _nameReporterController;
  late final TextEditingController _phoneNumberController;

  // INIT STATE
  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.bencana.name);

    _locationController =
        TextEditingController(text: widget.bencana.location);

    _descriptionController =
        TextEditingController(text: widget.bencana.description);

    _nameReporterController =
        TextEditingController(text: widget.bencana.nameReporter);

    _phoneNumberController =
        TextEditingController(text: widget.bencana.phoneNumber);
  }

  // DISPOSE
  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _nameReporterController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  // UPDATE BENCANA
  Future<void> _updateBencana() async {
    if (_formKey.currentState!.validate()) {
      final berhasil = await ref
          .read(bencanaViewModelProvider.notifier)
          .updateBencana(
            id: widget.bencana.id!,
            createdAt: widget.bencana.createdAt,
            name: _nameController.text,
            location: _locationController.text,
            description: _descriptionController.text,
            nameReporter: _nameReporterController.text,
            phoneNumber: _phoneNumberController.text,
          );

      if (!mounted) return;

      if (berhasil) {
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Gagal memperbarui laporan, coba lagi.',
            ),
          ),
        );
      }
    }
  }

  // UI FORM
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Laporan Bencana',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // NAMA BENCANA
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Bencana',
                    hintText: 'Masukkan nama bencana',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama bencana wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // LOKASI
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi',
                    hintText: 'Masukkan lokasi bencana',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lokasi wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // DESKRIPSI
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Masukkan deskripsi bencana',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // NAMA PELAPOR
                TextFormField(
                  controller: _nameReporterController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pelapor',
                    hintText: 'Masukkan nama pelapor',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama pelapor wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // NOMOR HP
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor HP',
                    hintText: 'Masukkan nomor HP',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor HP wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // TOMBOL UPDATE
                ElevatedButton(
                  onPressed: _updateBencana,
                  child: const Text('Update Laporan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}