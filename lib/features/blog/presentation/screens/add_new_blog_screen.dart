import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/pick_image.dart';

import '../widgets/blog_editor.dart';

class AddNewBlogScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogScreen(),
      );

  const AddNewBlogScreen({super.key});

  @override
  State<AddNewBlogScreen> createState() => _AddNewBlogScreenState();
}

class _AddNewBlogScreenState extends State<AddNewBlogScreen> {
  final TextEditingController _blogTitleontroller = TextEditingController();
  final TextEditingController _blogContentController = TextEditingController();

  Set<String> selectedTopics = {};

  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    _blogTitleontroller.dispose();
    _blogContentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Blog'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.done_rounded),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: selectImage,
                  child: image == null
                      ? DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          color: AppPallete.borderColor,
                          strokeCap: StrokeCap.round,
                          dashPattern: const [15, 4],
                          child: const SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.folder_open, size: 40),
                                SizedBox(height: 15),
                                Text(
                                  'Select your image',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            image!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <String>[
                      'Technology',
                      'Business',
                      'Programming',
                      'Entertainment',
                    ]
                        .map(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!selectedTopics.contains(e)) {
                                    selectedTopics.add(e);
                                  } else {
                                    selectedTopics.remove(e);
                                  }
                                });
                              },
                              child: Chip(
                                label: Text(e),
                                color: selectedTopics.contains(e)
                                    ? const MaterialStatePropertyAll(
                                        AppPallete.gradient1,
                                      )
                                    : null,
                                side: selectedTopics.contains(e)
                                    ? null
                                    : const BorderSide(
                                        color: AppPallete.borderColor,
                                      ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                BlogEditor(
                  controller: _blogTitleontroller,
                  hintText: 'Blog title',
                ),
                const SizedBox(height: 15),
                BlogEditor(
                  controller: _blogContentController,
                  hintText: 'Blog content',
                ),
              ],
            ),
          ),
        ));
  }
}
