import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';

class AddItemPage extends StatefulWidget {
  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {

  final title_controller = TextEditingController();
  final descriptino_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<XFile>? _imageFileList;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  String? _retrieveDataError;


  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  Future<dynamic> saveOFfer(String title, String description) async {

    print('save offer ${_imageFileList!.map((XFile image){
      return {
        'name': image.name
      };
    }).toList()}');

    var url = Uri.parse('http://192.168.110.96:8080/api/offer/add');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, dynamic>{
          'title': title,
          'description': description,
          'imagesOffer': _imageFileList!.map((XFile image){
            return {
              'name': image.name
            };
          }).toList()
        }));
    if (response.statusCode == 201) {
      print("Add successfully");
      dynamic offer = json.decode(utf8.decode(response.bodyBytes));
      uploadFiles(offer['id'].toString());
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }


  Future<dynamic> uploadFiles(String offerId) async {
    print('Upload file with id ${offerId}');
    Uri uri = Uri.parse('http://192.168.110.96:8080/api/offer/upload-images');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    for(var i = 0; i < _imageFileList!.length; i++) {
      request.files.add(await http.MultipartFile.fromPath('files', _imageFileList![i].path));
    }
    request.fields['offerId'] = offerId;

    http.StreamedResponse response = await request.send();

    print('response.statusCode ${response.statusCode}');
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }

  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {

    if (isMultiImage) {
      try {
        final List<XFile>? pickedFileList = await _picker.pickMultiImage(
          maxWidth: null,
          maxHeight: null,
          imageQuality: null,
        );
        setState(() {
          _imageFileList = pickedFileList;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: null,
          maxHeight: null,
          imageQuality: null,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }




  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _displayAllImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return SizedBox(
          height: 150,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageFileList!.length,
              itemBuilder: (_, index) {
                return Row(
                  children: <Widget>[
                    Container(
                        color: Colors.grey,
                        margin: new EdgeInsets.symmetric(horizontal: 10.0),
                        child: Stack(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Image.file(File(_imageFileList![index].path), width: 150, height: 150),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              width: 50,
                              height: 100,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      tooltip: 'Increase volume by 10',
                                      iconSize: 30,
                                      onPressed: () {

                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Remove'),
                                              content: const Text('Remove this image'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, 'Cancel');

                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, 'Remove');
                                                    setState(() {
                                                      print("Remove image ${index}");
                                                      _imageFileList!.removeAt(index);
                                                    });
                                                  },
                                                  child: const Text('Remove', style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            ));


                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                    )
                  ],
                );
              }
          )
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: TextFormField(
                  controller: title_controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title offer',
                      hintText: 'Enter yout title'),
                  validator: (val) => val!.length < 1 ? 'Your title is too short..' : null,
                )
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 20),
                child: TextFormField(
                  controller: descriptino_controller,
                  maxLines: 6, //or null
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description offer',
                      hintText: 'Enter your description'),
                  validator: (val) => val!.length < 1 ? 'Your description is too short..' : null,
                )
            ),
            _displayAllImages(),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  print('validate ${_formKey.currentState!.validate()}');
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    print('length ${_imageFileList!.length}');
                    print('title_controller ${title_controller.text}');
                    saveOFfer(title_controller.text, descriptino_controller.text);
                  }
                },
                child: const Text('Add offer'),
              ),
            ),
          ],
        )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(
                  ImageSource.gallery,
                  context: context,
                  isMultiImage: true,
                );
              },
              heroTag: 'image1',
              tooltip: 'Pick Multiple Image from gallery',
              child: const Icon(Icons.photo_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image2',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }

}
