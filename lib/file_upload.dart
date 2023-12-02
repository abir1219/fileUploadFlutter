
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';


class FileUpload extends StatelessWidget {
  const FileUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async{
          XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
          debugPrint("XFILE------>${file!.name}");

          uploadImage(file.name,File(file.path));
        },
        child: const Text("Upload Image"),),
      ),
    ));
  }

  Future<void> uploadImage(String name,File file) async{

    Dio call = Dio();


    if (isFilePathValid(file.path)) {
      print('File exists at ${file.parent.path}');
      var url = "https://api.motivateuedutech.com/api/v1/upload/avatar/6565b46172db710884e90e1f";
      // var url = "http://192.168.1.184:5007/api/v1/upload/avatar/655305cc9fe80a251c20f04a";

      // Map<String, dynamic> headers = {
      //   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTUzMDVjYzlmZTgwYTI1MWMyMGYwNGMiLCJyb2xlIjoiU3R1ZGVudCIsInBob25lIjoiOTgxNjI0MTMwMCIsInRpbWVzdGFtcCI6MTcwMTA3ODI1MjIxMCwiaWF0IjoxNzAxMDc4MjUyLCJleHAiOjE3MDExNjQ2NTJ9.ezoas6M__9G3t4BLHAU3vuOdo9RbRnnch1QPktBdi10',
      //   'Content-Type': 'multipart/form-data',
      // };

      // var headers = {
      //   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTUzMDVjYzlmZTgwYTI1MWMyMGYwNGMiLCJyb2xlIjoiU3R1ZGVudCIsInBob25lIjoiOTgxNjI0MTMwMCIsInRpbWVzdGFtcCI6MTcwMTA3ODI1MjIxMCwiaWF0IjoxNzAxMDc4MjUyLCJleHAiOjE3MDExNjQ2NTJ9.ezoas6M__9G3t4BLHAU3vuOdo9RbRnnch1QPktBdi10',
      //   'Content-Type': 'multipart/form-data'
      // };

      call.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTE1NmU3YmFhYzFmZTllZmZlNTAxMmEiLCJyb2xlIjoiU3R1ZGVudCIsInBob25lIjoiOTk5OTk5OTkxMiIsInRpbWVzdGFtcCI6MTcwMTE2NDA2NzMzNSwiaWF0IjoxNzAxMTY0MDY3LCJleHAiOjE3MDEyNTA0Njd9.RdlcLCFLfG2tHjFSf3iAb5pB2Y55gzvVw9GXebhdVYg';
      // call.options.headers['Content-Type'] = 'multipart/form-data';


      call.options.contentType = Headers.multipartFormDataContentType;
      // call.options.contentType = Headers.jsonContentType;

      call.options.validateStatus = (int? status) {
        debugPrint("----status---- $status");
        return status != null && status >= 200 && status < 500;
      };

      /*FormData formData = FormData.fromMap({
        'avatarFile': await MultipartFile.fromFile(
          file.path,
          filename: name,
        ),
      });*/

      String fileType = file.path.split('.').last; // Get file extension
      MediaType mediaType;
      switch (fileType.toLowerCase()) {
        case 'png':
          mediaType = MediaType('image', 'png');
          break;
        case 'jpg':
        case 'jpeg':
          mediaType = MediaType('image', 'jpeg');
          break;
        case 'gif':
          mediaType = MediaType('image', 'gif');
          break;
      // Add cases for other file types as needed
        default:
          mediaType = MediaType('application', 'octet-stream');
          break;
      }

      FormData formData = FormData();
      print('MultipartFile===> ${file.path},$name');
      print('contentType===> ${mediaType.type}');
      formData.files.add(MapEntry(
        'avatarFile',
        await MultipartFile.fromFile(
          file.path,
          filename: name,
          contentType: mediaType
        ),
      ));

// Print the formData to debug
      print('FormData: ${formData.files[0].value.contentType}');

      // Print the formData to debug
      print('FormData: ${formData.fields}');

      call.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));


      try {
        Response response = await call.post(url, data: formData);
        print('Upload successful: ${response.data}');
      } catch (error) {
        if (error is DioException) {
          print('Error uploading image: ${error.message}');
          // Access more error information if needed, e.g., error.response
        } else {
          print('Unexpected error: $error');
        }
      }
    }
  }

  bool isFilePathValid(String filePath) {
    File file = File(filePath);
    return file.existsSync();
  }

}
