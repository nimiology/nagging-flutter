import 'package:flutter/material.dart';

import '../models/nag.dart';
import 'circular_progress_indicator.dart';
import 'nag.dart';

class InfiniteScrollScreen extends StatefulWidget {
  final List<Widget> children;
  final Future<List<Nag>> Function() getNags;
  final Map<Symbol, dynamic> functionParams;

  const InfiniteScrollScreen({
    Key? key,
    required this.children,
    required this.getNags,
    this.functionParams = const {},
  }) : super(key: key);

  @override
  State<InfiniteScrollScreen> createState() => _InfiniteScrollScreenState();
}

class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
  final _controller = ScrollController();
  List<Nag> nags = [];
  int _pageSize = 20;
  int offset = 0;
  bool _isLastPage = false;
  bool _isLoading = false;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();

    final int? mapOffset = widget.functionParams[#offset];
    final int? mapLimit = widget.functionParams[#limit];
    offset = mapOffset ?? offset;
    _pageSize = mapLimit ?? _pageSize;

    _fetchData();
    // Setup the listener.
    _controller.addListener(controllerListener);
  }

  void controllerListener() {
    if (!_isLoading) {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - 3000) {
        if (_isLastPage == false && _isLoading == false) {
          _fetchData();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(controllerListener);
    _controller.dispose();
    super.dispose();
  }

  Future _getData() async {
    Map<Symbol, dynamic> functionParams = {
      ...widget.functionParams,
      #offset: offset.toString(),
      #limit: _pageSize.toString(),
    };
    final newItems = await Function.apply(widget.getNags, [], functionParams);
    offset += _pageSize;
    for (Nag nag in newItems) {
      nags.add(nag);
    }
    _isLastPage = newItems.length < _pageSize;
  }

  Future _fetchData() async {
    _isLoading = true;
    if (mounted) {
      setState(() {});
    }
    await _getData();
    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future onRefresh() async {
    _refreshing = true;
    offset = 0;
    nags = [];
    _fetchData();
    _refreshing = false;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Colors.white,
      backgroundColor: Colors.black,
      child: ListView(
        controller: _controller,
        children: [
          ...widget.children,
          // list
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: nags.length,
            itemBuilder: (context, index) => NagWidget(nag: nags[index]),
          ),
          if (!_isLastPage)
            const SizedBox(
              width: 80,
              height: 40,
            ),
          if (!_isLastPage && !_refreshing)
            Container(
                alignment: Alignment.center,
                width: 80,
                height: 80,
                child: const Center(child: CustomCircularProgressIndicator())),
        ],
      ),
    );
  }
}
