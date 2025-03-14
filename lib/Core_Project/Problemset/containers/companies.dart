import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/comapnies.dart';

class Companies extends StatefulWidget {
  const Companies({super.key});
  @override
  State<Companies> createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  List<Map<String, dynamic>> filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    filteredCompanies = companies;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 400,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness != Brightness.light
            ? Color.fromRGBO(255, 255, 255, 1).withOpacity(0.1)
            : Colors.grey.withOpacity(0.3),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: Colors.deepPurple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Trending Companies",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white.withOpacity(0.9) : Colors.blue,
                fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              height: 35,
              child: TextField(
                style: const TextStyle(fontSize: 10),
                cursorHeight: 15.0,
                decoration: const InputDecoration(
                  labelText: "Search",
                  labelStyle:
                      TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 15,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    filteredCompanies = companies
                        .where((company) => company['name']
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                childAspectRatio: 16 / 3,
                children: [
                  for (Map<String, dynamic> company in filteredCompanies)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            child: Text(
                              company['name'],
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.center,
                            height: 20,
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              company['problemCount'].toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
