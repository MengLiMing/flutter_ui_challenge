part of flutter_table_view;

class IndexPath {
  final int row;
  final int section;

  const IndexPath({
    required this.row,
    required this.section,
  });

  @override
  String toString() => '($section, $row)';

  @override
  bool operator ==(covariant IndexPath other) {
    if (identical(this, other)) return true;

    return other.row == row && other.section == section;
  }

  @override
  int get hashCode => row.hashCode ^ section.hashCode;
}
