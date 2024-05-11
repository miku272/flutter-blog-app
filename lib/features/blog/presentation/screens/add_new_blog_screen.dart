import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/widgets/blog_uploading_loader.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/pick_image.dart';
import '../../../../core/utils/show_snackbar.dart';

import '../widgets/blog_editor.dart';

import '../bloc/blog_bloc.dart';

import './blog_screen.dart';

class AddNewBlogScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogScreen(),
      );

  const AddNewBlogScreen({super.key});

  @override
  State<AddNewBlogScreen> createState() => _AddNewBlogScreenState();
}

class _AddNewBlogScreenState extends State<AddNewBlogScreen> {
  final _addBlogFormKey = GlobalKey<FormState>();

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

  void uploadBlog() {
    if (_addBlogFormKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final userId = context.read<AppUserCubit>().state as AppUserSignedin;

      context.read<BlogBloc>().add(
            BlogUpload(
              userId: userId.user.id,
              title: _blogTitleontroller.text.trim(),
              content: _blogContentController.text.trim(),
              image: image!,
              topics: selectedTopics.toList(),
            ),
          );
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
              onPressed: uploadBlog,
              icon: const Icon(Icons.done_rounded),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<BlogBloc, BlogState>(
            listener: (context, state) {
              if (state is BlogFailure) {
                showSnackbar(context, state.error);
              } else if (state is BlogSuccess) {
                showSnackbar(context, 'Blog added successfully!');
                Navigator.pushAndRemoveUntil(
                  context,
                  BlogScreen.route(),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is BlogLoading) {
                return const BlogUploadingLoader();
              }

              return SingleChildScrollView(
                child: Form(
                  key: _addBlogFormKey,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
              );
            },
          ),
        ));
  }
}
