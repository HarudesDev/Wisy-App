import 'package:extended_image/extended_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/shared/exceptions.dart';
import 'package:wisy/shared/loading.dart';
import 'package:wisy/providers/photos_provider.dart';
import 'package:wisy/repositories/firebase_auth_repository.dart';
import 'package:wisy/shared/style.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final photoList = ref.watch(photosProvider);
    final authService = ref.watch(firebaseAuthRepositoryProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Inicio',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await authService.signOut();
            },
            label: const Text('Cerrar sesión'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
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
            final date = photo.dateTime;
            return Card(
              margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ExtendedImage.network(
                                      photo.url,
                                      fit: BoxFit.cover,
                                      mode: ExtendedImageMode.gesture,
                                      initGestureConfigHandler: (_) {
                                        return GestureConfig(
                                          minScale: 1,
                                          animationMinScale: 1,
                                          inPageView: true,
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.png',
                        image: photo.url,
                        height: 80.0,
                        width: 80.0,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Foto tomada el: \n ${DateFormat('yyyy-MM-dd').format(date)} a las ${DateFormat('H:mm').format(date)}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          /*databaseService.deletePhoto(photo.id).then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(value)));
                          });*/
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
        error: (error, stack) {
          error as GenericException;
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    error.message,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(photosProvider);
                  },
                  child: const Text("Refrescar"),
                ),
              ],
            ),
          );
        },
        loading: () => const Loading(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: primaryColor,
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
