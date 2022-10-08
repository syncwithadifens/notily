import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notily/ui/edit_note_page.dart';
import 'package:notily/ui/home_page.dart';

class DetailNotePage extends StatelessWidget {
  final DocumentSnapshot noteData;
  final Query ref;
  const DetailNotePage({super.key, required this.ref, required this.noteData});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Row(
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back)),
                    const Text(
                      'Detail Catatan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditNotePage(ref: ref, noteData: noteData),
                          ));
                        },
                        icon: const Icon(Icons.edit_note)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                    'Apakah anda yakin untuk menghapus catatan ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      noteData.reference.delete().whenComplete(
                                            () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage(),
                                            )),
                                          );
                                    },
                                    child: const Text('Ya'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 15),
                  child: Text(
                    noteData['title'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(noteData['time']),
                ),
                Text(
                  noteData['content'],
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
