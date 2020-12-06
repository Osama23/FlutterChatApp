import 'package:FlutterChatApp/chat/messages.dart';
import 'package:FlutterChatApp/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    // ask for permissions
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg){
      print(msg);
      return;
    }, onLaunch: (msg) {
      print('#### onLaunch $msg');
      return;
    }, onResume: (msg){
      print('#### onResume $msg');
      return;
    });
    fbm.subscribeToTopic('chat');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('logout'),
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemId) {
              if (itemId == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Messages()),
            NewMessage(),
          ],
        ),
      ),
      // body: StreamBuilder(
      //     stream: Firestore.instance
      //         .collection('chats/X1BCyVOMFMf1BT4Vh0zp/messages')
      //         .snapshots(),
      //     builder: (context, streamSnapshot) {
      //       final documents = streamSnapshot.data.documents;
      //       if (streamSnapshot.connectionState == ConnectionState.waiting) {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       return ListView.builder(
      //         itemCount: documents.length,
      //         itemBuilder: (ctx, index) => Container(
      //           padding: EdgeInsets.all(8.0),
      //           child: Text(documents[index]['text']),
      //         ),
      //       );
      //     }),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           // There will always be one active instance
//           // Snapshots returns a stream
//           // Since this is a stream its going to emit new values whenever data changes
//           // This is the realtime data aspect, it always us to setup a listener throw the firebase flutter sdk to our firebase database
//           // whenever data changes there, this listener will be notified automatically
// //          Firestore.instance.collection('chats/X1BCyVOMFMf1BT4Vh0zp/messages')
// //              .snapshots().listen((data) {
// //                print('############## 0 ${data.documents[0]['text']}');
// //                // to execute a fun for every document
// //                data.documents.forEach((document){
// //                  print('########### ${document['text']}');
// //                });
// //          });
// //         },
//           Firestore.instance
//               .collection('chats/X1BCyVOMFMf1BT4Vh0zp/messages')
//               .add({
//             'text': 'added one item',
//           });
//         },
//       ),
    );
  }
}
