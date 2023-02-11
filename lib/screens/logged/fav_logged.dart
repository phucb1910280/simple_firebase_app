// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteLogged extends StatefulWidget {
  const FavoriteLogged({super.key});

  @override
  State<FavoriteLogged> createState() => _FavoriteLoggedState();
}

class _FavoriteLoggedState extends State<FavoriteLogged> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách yêu thích'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('userFavItems')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('favItems')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Somthing Wrong!'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  String docId = snapshot.data!.docs[index].id;
                  return CustomeListTile(
                    docID: docId,
                    documentSnapshot: documentSnapshot,
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

class CustomeListTile extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final String docID;
  const CustomeListTile({
    Key? key,
    required this.documentSnapshot,
    required this.docID,
  }) : super(key: key);

  Future deleteData() async {
    try {
      await FirebaseFirestore.instance
          .collection('userFavItems')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('favItems')
          .doc(docID)
          .delete();
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 0, right: 5, bottom: 5),
      child: SizedBox(
        height: 150,
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.network(
                      documentSnapshot['biaSach'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            documentSnapshot['tenSP'],
                            // overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${documentSnapshot['giaBan']}₫',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () async {
                          await deleteData();
                        },
                        icon: const Icon(Icons.favorite, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}