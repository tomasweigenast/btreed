import 'dart:io';
import 'package:path/path.dart' as p;

/// Manages the way pages are loaded/unloaded from/to disk.
final class PageManager {
  final int pageSize;
  final int headerSize;
  final File file;
  final File deletedPagesFile;
  final Set<int> deletedPages;

  RandomAccessFile? _fileRaf;
  RandomAccessFile? _delPagesRaf;

  PageManager({required String filePath, this.pageSize = 2048, this.headerSize = 256})
      : deletedPages = {},
        file = File(filePath),
        deletedPagesFile = File(p.join(filePath, ".del"));

  Future<void> open({FileMode fileMode = FileMode.write}) async {
    final [fileRaf, delPagesRaf] = await Future.wait([file.open(mode: fileMode), deletedPagesFile.open(mode: FileMode.write)]);
    _fileRaf = fileRaf;
    _delPagesRaf = delPagesRaf;
  }

  Future<void> close() async {
    await _fileRaf?.close();
    await _delPagesRaf?.close();
  }
}
