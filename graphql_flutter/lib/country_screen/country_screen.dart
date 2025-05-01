import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/constants.dart';
import 'package:shimmer/shimmer.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CountryScreen> {
  final HttpLink httpLink = HttpLink('https://countries.trevorblades.com');
  late GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache()
  );

  final QueryOptions query = QueryOptions(
    document: gql(
      r'''
        query getContients {
          continents {
            code
            name
            countries {
              name
              code
            }
          },
        }
      ''',
    ),
  );

  final QueryOptions specificContinent = QueryOptions(
    document: gql(
      r'''
        query getContients($code: code) {
          continent(code: $code) {
            code
            name
            countries {
              name
              code
            }
          },
        }
      ''',
    ),
    variables: const {
      'code': 'AF',
    }
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        title: Text(
          "Countries",
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

            log((snapshot.data?.data).toString(), name: 'response');
            final List<dynamic> dataContinents = snapshot.data?.data?['continents'] ?? [];
            return ListView.builder(
              itemCount: dataContinents.length,
              itemBuilder: (context, index1) {

                return ExpansionTile(
                  title: Text(dataContinents[index1]['name']),
                  children: [
                    ... List.generate(dataContinents[index1]['countries'].length ?? 0, (index) {
                      final country = dataContinents[index1]['countries'][index];

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 15,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            '${index + 1}',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          country['name']?.toString() ?? 'Na',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          country['code']?.toString() ?? 'Na',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    })
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}