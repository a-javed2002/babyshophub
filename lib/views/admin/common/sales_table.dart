
import 'package:flutter/material.dart';

class SalesTable extends StatefulWidget {
  final List<String> columnNames;
  final List<Map<String, dynamic>> values;
  final bool showActionsColumn;

  const SalesTable({
    Key? key,
    required this.columnNames,
    required this.values,
    this.showActionsColumn = false,
  }) : super(key: key);

  @override
  _SalesTableState createState() => _SalesTableState();
}

class _SalesTableState extends State<SalesTable> {
  int _rowsPerPage = 5;
  int _currentSortColumn = 0;
  bool _sortAscending = true;

  void updateFunction() {
    // Implement the logic to refresh the specific part of the widget
    setState(() {
      // Your refresh logic goes here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        child: PaginatedDataTable(
          header: Text('Sales Data'),
          columns: [
            ...widget.columnNames
                .asMap()
                .map((index, name) => MapEntry(
                      index,
                      DataColumn(
                        label: Text(name),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _currentSortColumn = columnIndex;
                            _sortAscending = ascending;
                            widget.values.sort((a, b) =>
                                a[name].compareTo(b[name]) *
                                (ascending ? 1 : -1));
                          });
                        },
                      ),
                    ))
                .values
                .toList(),
            if (widget.showActionsColumn)
              DataColumn(
                label: Text('Actions'),
              ),
          ],
          sortColumnIndex: _currentSortColumn,
          sortAscending: _sortAscending,
          source: SalesDataSource(widget.values,
              showActionsColumn: widget.showActionsColumn),
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: [5, 10, 20],
          onRowsPerPageChanged: (value) {
            setState(() {
              _rowsPerPage = value!;
            });
          },
          showCheckboxColumn: false,
        ),
      ),
    );
  }
}

class SalesDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final bool showActionsColumn;

  SalesDataSource(this.data, {this.showActionsColumn = false});

  @override
  DataRow? getRow(int index) {
    final item = data[index];
    return DataRow(
      cells: [
        ...item.values.map((e) => DataCell(Text(e.toString(),style: TextStyle(color: Colors.black),))).toList(),
        if (showActionsColumn)
          DataCell(
            Row(
              children: [
                _CustomCheckbox(
                  borderColor: Colors.green,
                  checkedIcon: Icons.check,
                  checkedColor: Colors.green,
                ),
                SizedBox(width: 8), // Add some spacing between the checkboxes
                _CustomCheckbox(
                  borderColor: Colors.red,
                  checkedIcon: Icons.close,
                  checkedColor: Colors.red,
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class _CustomCheckbox extends StatefulWidget {
  final Color borderColor;
  final IconData checkedIcon;
  final Color checkedColor;

  _CustomCheckbox({
    required this.borderColor,
    required this.checkedIcon,
    required this.checkedColor,
  });

  @override
  State<_CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<_CustomCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: _isChecked
            ? Icon(
                widget.checkedIcon,
                color: widget.checkedColor,
              )
            : null,
      ),
    );
  }
}
