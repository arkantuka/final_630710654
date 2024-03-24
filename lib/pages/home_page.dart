import 'dart:convert';
import 'package:final_630710654/helpers/my_list_tile.dart';
import 'package:final_630710654/helpers/my_text_field.dart';
import 'package:flutter/material.dart';
import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';
import '../models/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> _todoItems = [];
  final myController = TextEditingController();
  int choosed_index = 0;

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  Future<void> _loadTodoItems() async {
    try {
      final data = await ApiCaller().get("web_types");
      List list = jsonDecode(data);
      setState(() {
        _todoItems = list.map((e) => TodoItem.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: Column(
          children: [
            Center(
              child: Text('Webby Fondue'),
            ),
            Center(
              child: Text('ระบบรายงานเว็ปเลวๆ'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
                child: Text('* ต้องกรอกข้อมูล', style: textTheme.titleMedium)),
            const SizedBox(height: 16.0),
            MyTextField(
              controller: myController,
              hintText: 'URL *',
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              controller: myController,
              hintText: 'รายละเอียด',
            ),
            const SizedBox(height: 16.0),
            Text('ระบุประเภทเว็ปเลว *', style: textTheme.titleMedium),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  final item = _todoItems[index];
                  return MyListTile(
                    title: item.title,
                    subtitle: item.subtitle,
                    imageUrl: ApiCaller.host + item.image,
                    onTap: () {
                      print(index);
                      choosed_index = index;
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),

            // ปุ่มทดสอบ POST API
            ElevatedButton(
              onPressed: _handleApiPost,
              child: const Text('ส่งข้อมูล'),
            ),

            const SizedBox(height: 8.0),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "report_web",
        params: {
          "id": "gambling",
          "title": "เว็บพนัน",
        },
      );
      // API นี้จะส่งข้อมูลที่เรา post ไป กลับมาเป็น JSON object ดังนั้นต้องใช้ Map รับค่าจาก jsonDecode()
      Map map = jsonDecode(data);
      String text =
          'ส่งข้อมูลสำเร็จ\n\n - id: ${map['id']} \n - userId: ${map['title']} \n';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }
}
