import 'package:flutter/material.dart';
import 'package:kite/dao/library/book_search.dart';
import 'package:kite/dao/library/holding_preview.dart';
import 'package:kite/dao/library/image_search.dart';
import 'package:kite/entity/library/book_image.dart';
import 'package:kite/entity/library/holding_preview.dart';
import 'package:kite/service/library.dart';
import 'package:kite/service/library/holding_preview.dart';
import 'package:kite/service/session_pool.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/library/search.dart';
import 'package:kite/util/logger.dart';

import 'book_info.dart';

class BookSearchResultWidget extends StatefulWidget {
  final String keyword;
  final BookSearchDao bookSearchDao = BookSearchService(SessionPool.librarySession);
  final BookImageSearchDao bookImageSearchDao = BookImageSearchService(SessionPool.librarySession);
  final HoldingPreviewDao holdingPreviewDao = HoldingPreviewService(SessionPool.librarySession);

  BookSearchResultWidget(this.keyword, {Key? key}) : super(key: key);

  @override
  _BookSearchResultWidgetState createState() => _BookSearchResultWidgetState();
}

class _BookSearchResultWidgetState extends State<BookSearchResultWidget> {
  final _scrollController = ScrollController();
  Widget buildBookCover(String? imageUrl) {
    const def = Icon(
      Icons.library_books_sharp,
      size: 100,
    );
    if (imageUrl == null) {
      return def;
    }

    return Image(
      image: NetworkImage(imageUrl),
      fit: BoxFit.cover,
    );
  }

  Widget buildListTile(BookImageHolding bi) {
    var book = bi.book;
    var holding = bi.holding ?? [];
    // 计算总共馆藏多少书
    int copyCount = holding.map((e) => e.copyCount).reduce((value, element) => value + element);
    // 计算总共可借多少书
    int loanableCount = holding.map((e) => e.loanableCount).reduce((value, element) => value + element);
    var row = Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: buildBookCover(bi.image?.resourceLink),
            height: 130,
          ),
          flex: 3,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('作者:  ${book.author}'),
              Text('索书号:  ${book.callNo}'),
              Text('ISBN:  ${book.isbn}'),
              Text('${book.publisher}  ${book.publishDate}'),
              Row(
                children: [
                  const Expanded(child: Text(' ')),
                  ColoredBox(
                    color: Colors.black12,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                      // width: 80,
                      // height: 20,
                      child: Text('馆藏($copyCount)/在馆($loanableCount)'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          flex: 7,
        ),
      ],
    );
    return InkWell(
      child: row,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return BookInfoPage(bi.book.bookId);
          }),
        );
      },
    );
  }

  var useTime = 0.0;
  var searchResultCount = 0;
  var currentPage = 1;
  var totalPage = 10;

  /// 获得搜索结果
  Future<List<BookImageHolding>> get(int rows, int page) async {
    var searchResult = await widget.bookSearchDao.search(
      keyword: widget.keyword,
      rows: rows,
      page: page,
    );

    // 页数越界
    if (searchResult.currentPage > totalPage) {
      return [];
    }
    useTime = searchResult.useTime;
    searchResultCount = searchResult.resultCount;
    currentPage = searchResult.currentPage;
    totalPage = searchResult.totalPages;

    Log.info(searchResult);
    var imageHoldingPreview = await Future.wait([
      widget.bookImageSearchDao.searchByBookList(searchResult.books),
      widget.holdingPreviewDao.getHoldingPreviews(searchResult.books.map((e) => e.bookId).toList()),
    ]);
    var imageResult = imageHoldingPreview[0] as Map<String, BookImage>;
    var holdingPreviewResult = imageHoldingPreview[1] as HoldingPreviews;
    return BookImageHolding.build(
      searchResult.books,
      imageResult,
      holdingPreviewResult.previews,
    );
  }

  List<BookImageHolding> dataList = [];
  bool isLoading = false;

  Future<void> getData() async {
    var firstPage = await get(10, currentPage);
    setState(() {
      dataList = firstPage;
    });
  }

  Future<void> getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      showBasicFlash(
          context,
          Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                width: 15,
              ),
              Text('正在加载更多结果')
            ],
          ),
          duration: const Duration(seconds: 3));
      try {
        var nextPage = await get(10, currentPage + 1);
        if (nextPage.isNotEmpty) {
          setState(() {
            dataList.addAll(nextPage);
            isLoading = false;
          });
        } else {
          showBasicFlash(context, const Text('找不到更多了'));
          isLoading = false;
        }
      } catch (e) {
        showBasicFlash(context, const Text('网络异常，再试一次'));
        isLoading = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Log.info('页面滑动到底部');
        getMore();
      }
    });
  }

  Widget? a;
  @override
  Widget build(BuildContext context) {
    Log.info('初始化列表');
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('总结果数: $searchResultCount  用时: $useTime  已加载: $currentPage/$totalPage'),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Column(children: [
                Container(
                  child: buildListTile(dataList[index]),
                  padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                ),
                const Divider(color: Colors.black),
              ]);
            },
            itemCount: dataList.length,
            controller: _scrollController,
          ),
        ),
      ],
    );
  }
}
