import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder/API/api.dart';
import 'package:pathfinder/Entity/Message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  late Future<List<Message>> futureMessage;
  Api api = const Api();

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Messages',
              style: GoogleFonts.ubuntu(
                  color: Colors.amber[800],
                  fontSize: 25,
                  decoration: TextDecoration.none),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(2.0),
            child: FutureBuilder<List<dynamic>>(
              future: futureMessage,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Icon(Icons.error)));
                }
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        tileColor: Colors.black12,
                        title: Text(
                          '${snapshot.data![index].sender['name']}',
                          style: GoogleFonts.ubuntu(
                              color: Colors.amber[800],
                              fontSize: 18,
                              decoration: TextDecoration.none),
                        ),
                        subtitle: Text(
                          '${snapshot.data![index].context}',
                          style: GoogleFonts.ubuntu(
                              color: Colors.amber[800],
                              fontSize: 12,
                              decoration: TextDecoration.none),
                        ),
                        trailing: Icon(
                          Icons.message,
                          size: 24,
                          color: Colors.amber[800],
                        ),
                        onTap: () {},
                      );
                    });

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ],
    );
  }

  void getMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      futureMessage = api.fetchMessageByUser(prefs.getString('userEmail')!);
    });
  }
}
