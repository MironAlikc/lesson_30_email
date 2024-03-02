import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lesson_30_email/app_consts.dart';
import 'package:lesson_30_email/dio_settings.dart';
import 'package:lesson_30_email/email_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controllerName = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerInfo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomTextField(
                  hintText: 'Name',
                  controller: controllerName,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Phone',
                  controller: controllerPhone,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  maxLines: 6,
                  hintText: 'Info',
                  controller: controllerInfo,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendEmail,
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ),
    );
  }

  Future<void> sendEmail() async {
    final Dio dio = DioSettings().dio;
    try {
      await dio.post(
        'https://api.emailjs.com/api/v1.0/email/send',
        data: EmailModel(
          // templateId: AppConsts.templateId,
          serviceId: AppConsts.serviceId,
          userId: AppConsts.userId,
          accessToken: AppConsts.accessToken,
          templateParams: TemplateParams(
            fromName: controllerName.text,
            toName: controllerPhone.text,
            message: controllerInfo.text,
          ),
        ).toJson(),
      );
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            'OK',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      String? errorText = e.toString();
      if (e is DioException) {
        errorText = e.response?.data;
//         if(e.response?.statusCode == 401){
// Navigator.pushReplacement(context, newRoute)
//         }
      }
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            e.toString(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
  });
  final String hintText;
  final TextEditingController controller;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 5,
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
