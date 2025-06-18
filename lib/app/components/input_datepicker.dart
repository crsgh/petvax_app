import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatefulWidget {
  final Function(String)? onDateTimeSelected;
  final String? initialValue;
  final String label;
  final String hint;

  const CustomDateTimePicker({
    super.key,
    this.onDateTimeSelected,
    this.initialValue,
    this.label = 'Select Date & Time',
    this.hint = 'MM/DD/YYYY HH:MM AM/PM',
  });

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  DateTime? selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController textController = TextEditingController();
  PageController pageController = PageController();
  DateTime currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      // Parse initial value if provided
      try {
        selectedDate = DateTime.parse(widget.initialValue!);
        selectedTime = TimeOfDay.fromDateTime(selectedDate!);
        _updateTextField();
      } catch (e) {
        // Handle parse error
      }
    }
  }

  @override
  void dispose() {
    textController.dispose();
    pageController.dispose();
    super.dispose();
  }

  String _formatForDisplay() {
    if (selectedDate == null) return '';
    final date = DateFormat('MM/dd/yyyy').format(selectedDate!);
    final time = selectedTime.format(context);
    return '$date $time';
  }

  String _formatForPhp() {
    if (selectedDate == null) return '';
    final dateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  void _updateTextField() {
    textController.text = _formatForDisplay();
  }

  // ignore: unused_element
  void _selectDate(int day) {
    setState(() {
      selectedDate = DateTime(currentMonth.year, currentMonth.month, day);
      _updateTextField();
    });
  }

  // ignore: unused_element
  void _changeMonth(bool isNext) {
    setState(() {
      if (isNext) {
        currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      } else {
        currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      }
    });
  }

  // ignore: unused_element
  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _updateTextField();
      });
    }
  }

  // ignore: unused_element
  void _setNow() {
    final now = DateTime.now();
    setState(() {
      selectedDate = now;
      selectedTime = TimeOfDay.fromDateTime(now);
      currentMonth = now;
      _updateTextField();
    });
  }

  void _save() {
    if (selectedDate != null && widget.onDateTimeSelected != null) {
      widget.onDateTimeSelected!(_formatForPhp());
      Navigator.of(context).pop(); // Close the dialog

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Date & Time saved: ${_formatForDisplay()}'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDateTimePicker() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Select Date & Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.close, color: Colors.white),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildCalendarForDialog(setDialogState),
                            _buildTimePickerForDialog(setDialogState),

                            // Action Buttons
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      final now = DateTime.now();
                                      setDialogState(() {
                                        selectedDate = now;
                                        selectedTime = TimeOfDay.fromDateTime(
                                          now,
                                        );
                                        currentMonth = now;
                                      });
                                      setState(() {
                                        _updateTextField();
                                      });
                                    },
                                    child: Text(
                                      'Now',
                                      style: TextStyle(color: Colors.blue[600]),
                                    ),
                                  ),

                                  Spacer(),

                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),

                                  SizedBox(width: 8),

                                  ElevatedButton(
                                    onPressed:
                                        selectedDate != null
                                            ? () {
                                              setState(() {
                                                _updateTextField();
                                              });
                                              _save();
                                            }
                                            : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCalendarForDialog(StateSetter setDialogState) {
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month, 1).weekday % 7;

    return Column(
      children: [
        // Month/Year Header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setDialogState(() {
                    if (currentMonth.month == 1) {
                      currentMonth = DateTime(currentMonth.year - 1, 12);
                    } else {
                      currentMonth = DateTime(
                        currentMonth.year,
                        currentMonth.month - 1,
                      );
                    }
                  });
                },
                icon: Icon(Icons.chevron_left, color: Colors.grey[600]),
              ),
              Text(
                DateFormat('MMMM yyyy').format(currentMonth),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () {
                  setDialogState(() {
                    if (currentMonth.month == 12) {
                      currentMonth = DateTime(currentMonth.year + 1, 1);
                    } else {
                      currentMonth = DateTime(
                        currentMonth.year,
                        currentMonth.month + 1,
                      );
                    }
                  });
                },
                icon: Icon(Icons.chevron_right, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Day Headers
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children:
                ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),

        SizedBox(height: 8),

        // Calendar Grid
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 42, // 6 weeks * 7 days
            itemBuilder: (context, index) {
              final dayNumber = index - firstDayOfMonth + 1;

              if (index < firstDayOfMonth || dayNumber > daysInMonth) {
                return Container(); // Empty cell
              }

              final isToday =
                  DateTime.now().day == dayNumber &&
                  DateTime.now().month == currentMonth.month &&
                  DateTime.now().year == currentMonth.year;

              final isSelected =
                  selectedDate?.day == dayNumber &&
                  selectedDate?.month == currentMonth.month &&
                  selectedDate?.year == currentMonth.year;

              return GestureDetector(
                onTap: () {
                  setDialogState(() {
                    selectedDate = DateTime(
                      currentMonth.year,
                      currentMonth.month,
                      dayNumber,
                    );
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.blue
                            : isToday
                            ? Colors.blue.withOpacity(0.1)
                            : null,
                    borderRadius: BorderRadius.circular(8),
                    border:
                        isToday
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                  ),
                  child: Center(
                    child: Text(
                      dayNumber.toString(),
                      style: TextStyle(
                        color:
                            isSelected
                                ? Colors.white
                                : isToday
                                ? Colors.blue
                                : Colors.black87,
                        fontWeight:
                            isSelected || isToday
                                ? FontWeight.w600
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerForDialog(StateSetter setDialogState) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Time',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (picked != null) {
                      setDialogState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 8),
                        Text(
                          selectedTime.format(context),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Time Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Time: ${selectedTime.format(context)}',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),

        // Input Field
        GestureDetector(
          onTap: _showDateTimePicker,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    textController.text.isEmpty
                        ? widget.hint
                        : textController.text,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          textController.text.isEmpty
                              ? Colors.grey[500]
                              : Colors.black87,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (textController.text.isNotEmpty)
                      GestureDetector(
                        // onTap: (event) {
                        //   event?.stopPropagation();
                        //   _clear();
                        // },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.clear,
                            size: 20,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Selected Date Time Display
        if (selectedDate != null)
          Container(
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected: ${DateFormat('EEEE, MMMM d, y').format(selectedDate!)} at ${selectedTime.format(context)}',
                  style: TextStyle(color: Colors.blue[700], fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'PHP Format: ${_formatForPhp()}',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Example usage widget
class DateTimePickerExample extends StatefulWidget {
  const DateTimePickerExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DateTimePickerExampleState createState() => _DateTimePickerExampleState();
}

class _DateTimePickerExampleState extends State<DateTimePickerExample> {
  String selectedDateTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Date Time Picker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomDateTimePicker(
              label: 'Select Date & Time',
              hint: 'Choose date and time',
              onDateTimeSelected: (dateTime) {
                setState(() {
                  selectedDateTime = dateTime;
                });
                print('Selected DateTime for PHP: $dateTime');
              },
            ),

            SizedBox(height: 24),

            if (selectedDateTime.isNotEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved DateTime:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        selectedDateTime,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
