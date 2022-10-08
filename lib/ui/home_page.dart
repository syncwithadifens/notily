import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notily/ui/create_note_page.dart';
import 'package:notily/ui/detail_note_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List warna = [
      const Color(0xff372948),
      const Color(0xff628E90),
      Colors.deepPurple,
      const Color(0xff256D85),
      const Color(0xffC98474)
    ];
    final ref = FirebaseFirestore.instance
        .collection("notes")
        .orderBy("time", descending: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.my_library_books),
        title: const Text('Catatanku'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffBCBE40),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateNotePage(),
            ),
          );
        },
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('Belum ada catatan dibuat'),
              );
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailNotePage(
                            ref: ref, noteData: snapshot.data!.docs[index]),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: warna[index % warna.length],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.docs[index]['title'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 4),
                              child: Text(
                                snapshot.data!.docs[index]['time'],
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white54),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data!.docs[index]['content'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
