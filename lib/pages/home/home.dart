import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/services/auth.dart';
import 'package:wisy/services/database.dart';
import 'package:wisy/shared/loading.dart';
import 'package:wisy/providers/photos_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {

  @override
  Widget build(BuildContext context) {
    final photoList = ref.watch(photosProvider);
    final databaseService = ref.watch(databaseServiceProvider);
    final authService = ref.watch(authServiceProvider);
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Inicio'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await authService.signOut();
            },
            label: const Text('Cerrar sesión'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
      body: photoList.when(
        data: (photos) => ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            DateTime date = photo.dateTime;
            return Card(
              margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.png',
                      image: photo.url,
                      height: 200.0,
                      width: 100.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Foto tomada el: \n ${date.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          databaseService.deletePhoto(photo.id).then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(value)));
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
            );
          },
        ),
        error: (error, stack) => ElevatedButton(onPressed:()=> ref.invalidate(photosProvider), child:const Text("Refrescar")),
        loading: () => const Loading(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/camera');
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Tomar foto'),
        ),
      ),
    );
  }
}
