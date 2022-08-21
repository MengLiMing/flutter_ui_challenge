// ignore_for_file: public_member_api_docs, sort_constructors_first
part of flutter_table_view;

typedef TableViewItemBuilder = Widget Function(
    BuildContext context, IndexPath indexPath);

typedef TableViewHeaderBuilder = Widget Function(
    BuildContext context, int sectionIndex);
typedef TableViewHeaderHeight = double Function(
    BuildContext context, int sectioIndex);

typedef TableViewFooterBuilder = TableViewHeaderBuilder;
typedef TableViewFooterHeight = TableViewHeaderHeight;

enum FlutterTableViewStyle {
  plain,
  grouped,
}

class FlutterTableView extends StatefulWidget {
  final int Function() sectionCount;
  final int Function(int) rowCount;
  final FlutterTableViewController controller;

  final FlutterTableViewStyle style;

  final TableViewItemBuilder itemBuilder;

  final TableViewHeaderBuilder? headerBuilder;
  final TableViewHeaderHeight? headerHeight;
  final TableViewFooterBuilder? footerBuilder;
  final TableViewFooterHeight? footerHeight;

  const FlutterTableView({
    Key? key,
    required this.sectionCount,
    required this.rowCount,
    required this.controller,
    required this.itemBuilder,
    this.style = FlutterTableViewStyle.plain,
    this.headerBuilder,
    this.headerHeight,
    this.footerBuilder,
    this.footerHeight,
  })  : assert(headerBuilder == null || headerHeight != null),
        assert(footerBuilder == null || footerHeight != null),
        super(key: key);

  @override
  State<FlutterTableView> createState() => _FlutterTableViewState();
}

class _FlutterTableViewState extends State<FlutterTableView> {
  final ItemScrollController itemScrollController = ItemScrollController();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late final _TableViewCountManager countManger;

  late final _TableViewDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = _TableViewDataSource();
    countManger = _TableViewCountManager(dataSource: dataSource);

    configDataSource();

    countManger.initLoad();

    itemPositionsListener.itemPositions.addListener(() {
      final value = itemPositionsListener.itemPositions.value
          .map((e) => '${e.itemLeadingEdge} - ${e.itemTrailingEdge}');
      // print(value);
    });
  }

  void configDataSource() {
    dataSource.sectionCount = widget.sectionCount;
    dataSource.rowCount = widget.rowCount;
    widget.controller
      .._countManger = countManger
      .._itemPositionsListener = itemPositionsListener
      .._itemScrollController = itemScrollController;
  }

  @override
  void didUpdateWidget(covariant FlutterTableView oldWidget) {
    configDataSource();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    countManger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: countManger,
      builder: (context, count, child) {
        return ScrollablePositionedList.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: count,
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemBuilder: (context, index) {
            final indexPath = countManger.indexPathBy(index);
            if (indexPath == null) {
              return Container();
            } else {
              countManger.loadNextSection(indexPath.section);
              if (indexPath.section < dataSource.sectionCount() &&
                  indexPath.row < dataSource.rowCount(indexPath.section)) {
                return widget.itemBuilder(context, indexPath);
              }
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
