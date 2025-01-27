import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:btreed/src/impl/page_manager/page.dart';
import 'package:path/path.dart' as p;

/// Manages the way pages are loaded/unloaded from/to disk.
final class PageManager {
  final int pageSize;
  final int headerSize;
  final File _file;
  final File _deletedPagesFile;
  final Set<int> _deletedPages;
  final Map<int, Page> _cache;

  RandomAccessFile? _fileRaf;
  RandomAccessFile? _delPagesRaf;
  Timer? _cacheDumpTimer;

  PageManager({required String filePath, this.pageSize = 2048, this.headerSize = 256})
      : _deletedPages = {},
        _file = File(filePath),
        _deletedPagesFile = File(p.join(filePath, ".del")),
        _cache = {} {
    _cacheDumpTimer = Timer.periodic(const Duration(seconds: 15), _onTimerTick);
  }

  /// Retrieves a page with id [pageId]. If the page does not exist, it is created
  /// on the disk.
  Page getPage(int pageId) {
    Page? page = _cache[pageId];
    if (page != null) {
      if (!page.dirty) {
        return page;
      }
      // TODO: dump to file
      page = null;
    }

    page = _readPage(pageId);
    _cache[pageId] = page;
    return page;
  }

  Page _readPage(int pageId) {
    _fileRaf!.readIntoSync(buffer);

    return Page(id: pageId, data: Uint8List(0));
  }

  void open() {
    _fileRaf = _file.openSync(mode: FileMode.write);
    _delPagesRaf = _deletedPagesFile.openSync(mode: FileMode.write);
  }

  void close() {
    _dumpCachedPages();

    _cacheDumpTimer?.cancel();
    _cache.clear();
    _deletedPages.clear();
    _fileRaf?.closeSync();
    _delPagesRaf?.closeSync();
  }

  /// Called every time cached pages should be dumped to disk if they are dirty
  void _onTimerTick(_) {
    _dumpCachedPages();
  }

  void _dumpCachedPages() {
    for (final page in _cache.values) {
      if (page.dirty) {
        // TODO: dump to disk
      }
    }
  }

  void write(int pageId, Uint8List data) {}
}

/*
func (p *Pager) WriteTo(pageID int64, data []byte) error {
	p.DeletePage(pageID)
	// remove from deleted pages
	p.deletedPagesLock.Lock()
	defer p.deletedPagesLock.Unlock()

	for i, page := range p.deletedPages {
		if page == pageID {
			p.deletedPages = append(p.deletedPages[:i], p.deletedPages[i+1:]...)
		}

	}
	// the reason we are doing this is because we are going to write to the page thus having any overflowed pages which are linked to the page may not be needed

	// check if data is larger than the page size
	if len(data) > PAGE_SIZE {
		// create an array [][]byte
		// each element is a page

		chunks := splitDataIntoChunks(data)

		// clear data to free up memory
		data = nil

		headerBuffer := make([]byte, HEADER_SIZE)

		// We need to create pages for each chunk
		// after index 0
		// the next page is the current page + 1

		// index 0 would have the next page of index 1 index 1 would have the next page of index 2

		for i, chunk := range chunks {
			// check if we are at the last chunk
			if i == len(chunks)-1 {
				headerBuffer = make([]byte, HEADER_SIZE)
				nextPage := pageID + 1
				copy(headerBuffer, strconv.FormatInt(nextPage, 10))

				// if chunk is less than PAGE_SIZE, we need to pad it with null bytes
				if len(chunk) < PAGE_SIZE {
					chunk = append(chunk, make([]byte, PAGE_SIZE-len(chunk))...)
				}

				// write the chunk to the file
				_, err := p.file.WriteAt(append(headerBuffer, chunk...), pageID*(PAGE_SIZE+HEADER_SIZE))
				if err != nil {
					return err
				}

			} else {
				// update the header
				headerBuffer = make([]byte, HEADER_SIZE)
				nextPage := pageID + 1
				copy(headerBuffer, strconv.FormatInt(nextPage, 10))

				if len(chunk) < PAGE_SIZE {
					chunk = append(chunk, make([]byte, PAGE_SIZE-len(chunk))...)
				}

				// write the chunk to the file
				_, err := p.file.WriteAt(append(headerBuffer, chunk...), pageID*(PAGE_SIZE+HEADER_SIZE))
				if err != nil {
					return err
				}

				// update the pageID
				pageID = nextPage

			}
		}

	} else {
		// create a buffer to store the header
		headerBuffer := make([]byte, HEADER_SIZE)

		// set the next page to -1
		copy(headerBuffer, "-1")

		// if data is less than PAGE_SIZE, we need to pad it with null bytes
		if len(data) < PAGE_SIZE {
			data = append(data, make([]byte, PAGE_SIZE-len(data))...)
		}

		// write the data to the file
		_, err := p.file.WriteAt(append(headerBuffer, data...), (PAGE_SIZE+HEADER_SIZE)*pageID)
		if err != nil {
			return err
		}

	}

	return nil
}

 */