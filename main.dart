import 'dart:io';
import 'dart:convert';

var host = "localhost";
var port = 4041;
var content_types = {
  'html': 'text/html',
  'txt': 'text/plain',
  'octet': 'application/octet-stream',
  'png': 'image/png',
  'jpg': 'image/jpeg'
};

var files = [];

bytesize(String input) {
  List<int> bytes = UTF8.encode(input);
  return (bytes.length);
}

what_type(String file_name) {
    if (file_name.contains(".html") == true) {
      var content_type = content_types['html'];
      return(content_type);
    } else if (file_name.contains(".txt") == true) {
      var content_type = content_types['txt'];
      return(content_type);
    }else{
      var content_type = content_types['octet'];
      return(content_type);
      };
    }

main() async {
  var files_dir = new Directory("/home/greg/dev/dart/thbbt/html");
  Stream<FileSystemEntity> entityList =
      files_dir.list(recursive: true, followLinks: false);
  await for (FileSystemEntity entity in entityList) files.add(entity.path);
  for (var i in files) {
    new File(i).readAsString().then((String contents) {
      var html_content = contents;
      var file_name = i;
      var content_type = what_type(file_name);
      Int content_length = bytesize(html_content);
      print("found file: $file_name");
      print("size: $content_length");
      print("type: $content_type");
      ServerSocket.bind(host, port).then((serverSocket) {
        serverSocket.listen((socket) {
          socket.write('HTTP/1.1 200 OK\r\n');
          socket.write('Content-Type: $content_type\r\n');
          socket.write('Content-Length: $content_length\r\n');
          socket.write('Connection: close\r\n');
          socket.write('\r\n');
          socket.write(html_content);
        });
      });
    });
  }
  //if (files.contains("index.html") == false) {
    //ServerSocket.bind(host, port).then((serverSocket) {
      //serverSocket.listen((socket) {
        //socket.write('HTTP/1.1 200 OK\r\n');
        //socket.write('Content-Type: $content_type\r\n');
        //socket.write('Content-Length: $content_length\r\n');
        //socket.write('Connection: close\r\n');
        //socket.write('\r\n');
        //socket.write("hello");
      //});
    //});
  //}
}
