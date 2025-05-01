import 'dart:developer';

import 'package:collection/collection.dart' show groupBy;
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/constants.dart';
import 'package:shimmer/shimmer.dart';

import 'model/notes_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final HttpLink httpLink = HttpLink('http://192.168.17.62:8000/graphql');
  late GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache()
  );

  final QueryOptions query = QueryOptions(
    document: gql(
      r'''
        query GetTodos {
          getTodos {
            title
            completed
            userId
            user {
              name
            }
          }
        }
      ''',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        title: Text(
          "Notes",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: client.query(query),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Shimmer.fromColors(
                baseColor: CustomColor.shimmerColorBase,
                highlightColor: CustomColor.shimmerColorHighlight,
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      margin: const EdgeInsets.all(10),
                      color: Colors.red,
                    ),
                    Container(
                      height: 120,
                      margin: const EdgeInsets.all(10),
                      color: Colors.red,
                    ),
                  ],
                ),
              );
            }

            log((snapshot.data?.data).toString(), name: 'NotesData');

            final List<NoteModel> notes = ((snapshot.data?.data?['getTodos'] is List
                ? (snapshot.data!.data!['getTodos']) : <dynamic>[]) as List<dynamic>)
                .map((e) => NoteModel.fromJson(e)).toList();

            final Map<dynamic, List<NoteModel>> groupedByUsers = groupBy(notes, (value) => value.userId);

            return ListView.builder(
              itemCount: groupedByUsers.values.length,
              itemBuilder: (context, index) {
                final List<NoteModel> notes = groupedByUsers.values.elementAt(index);

                return ExpansionTile(
                  title: Text(notes.isNotEmpty ? (notes.first.user?.name ?? 'Na') : 'Na'),
                  children: List.generate(notes.length, (noteIndex) {
                    final NoteModel note = notes[noteIndex];

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.orangeAccent,
                        child: Text(
                          '${noteIndex + 1}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        note.title ?? 'Na',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          decoration: note.completed == true ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    );
                  }),
                );
              },
            );
          },
        ),
      ),
    );
  }
}