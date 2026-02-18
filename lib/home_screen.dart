import 'package:flutter/material.dart';
import 'package:hive_sticky_notes/hive_functions.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List myHiveData = [];


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();


  getHiveData() {
    myHiveData = HiveFunctions.getAllUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getHiveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Записная книжка"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              getHiveData();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      // To add or create the data in Hive
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        label: const Text("Добавить запись"),
        icon: const Icon(Icons.add),
        onPressed: () {
          showForm(null);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            myHiveData
                    .isEmpty 
                ? const Center(
                  child: Text(
                    "Добавьте заметку",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                )

                : Column(
                  children:
                      List.generate(myHiveData.length, (index) {
                        final userData = myHiveData[index];
                        return Card(
                          child: ListTile(
                            title: 
                                Text("Заголовок : ${userData["title"]}"),
                            subtitle: 
                                Text("Описание : ${userData["body"]}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showForm(userData["key"]);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {

                                    showDialog(
                                       context: context,
                                      builder: (ctx) => AlertDialog(
                                      title: const Text("Оповещение"),
                                       content: const Text("Вы действительно хотите удалить заметку?"),
                                                                      
                                          actions: <Widget>[
                  TextButton(
                    onPressed: () {
                                    HiveFunctions.deleteUser(userData["key"]);
                                                                        getHiveData();
                                                                                              Navigator.of(ctx).pop();
                    },
                    child: const Text("Да"),
                  ),

                                    TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();

                    },
                    child: const Text("Нет"),
                  ),
                ],
              ),
            );
         


                                  },

                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
      ),
    );
  }


  void showForm(int? itemKey) async {


    if (itemKey != null) {

      final existingItem = myHiveData.firstWhere(
        (element) => element['key'] == itemKey,
      );
      _titleController.text = existingItem['title'];
      _bodyController.text = existingItem['body'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder:
          (_) => Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    itemKey == null ? 'Создать' : 'Редактировать',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _bodyController,

                  decoration: const InputDecoration(hintText: 'Body'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    // Save new item
                    if (itemKey == null) {
                      HiveFunctions.createUser({
                        "body": _bodyController.text,
                        "title": _titleController.text,
                      });
                    }

                    if (itemKey != null) {
                      HiveFunctions.updateUser(itemKey, {
                        "body": _bodyController.text,
                        "title": _titleController.text,
                      });
                    }


                    _titleController.text = '';
                    _bodyController.text = '';

                    Navigator.of(context).pop(); 

                    getHiveData();
                  },
                  child: Text(itemKey == null ? 'Создать' : 'Редактировать'),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
    );
  }
}