import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Gallery extends StatelessWidget {
  const Gallery({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Gallery',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add action functionality here
            },
            icon: Icon(
              Icons.add,
              size: 30.0,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Images').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var images = snapshot.data!.docs;
            return ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Dismissible(
                      key: Key(images[index].id),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.grey,
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 100,
                        ),
                      ),
                      onDismissed: (direction) {
                        // Remove the item from the database
                        FirebaseFirestore.instance
                            .collection('Images')
                            .doc(images[index].id)
                            .delete();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(images[index]['url']),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
