import 'package:date_utilities/date_utilities.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class DatePickerViewModel extends BaseViewModel {
  final BehaviorSubject<List<int>> daysSubject = BehaviorSubject<List<int>>();

  Stream<List<int>> get daysStream => daysSubject.stream;

  Sink<List<int>> get daysSink => daysSubject.sink;

  FixedExtentScrollController? dayController;

  int day = 0;
  int month = 0;
  int year = 0;
  final List<int> days = <int>[];
  final List<int> months = <int>[];
  final List<int> years = <int>[];

  void initData({required int day, required int month, required int year}) {
    this.day = day == 0 ? DateTime.now().day : day;
    this.month = month == 0 ? DateTime.now().month : month;
    this.year = year == 0 ? DateTime.now().year : year;

    print("year $year");
    this.addDays();
    this.addMonth();
    this.addYear();

    dayController = new FixedExtentScrollController(initialItem: day - 1);
  }

  void addDays() {
    var dateUtility = DateUtilities();
    int daysInMonth = dateUtility.daysInMonth(month, year) ?? 1;
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }
    daysSink.add(days);
  }

  void addMonth() {
    for (int i = 1; i <= 12; i++) {
      months.add(i);
    }
  }

  void addYear() {
    for (int i = 0; i <= 100; i++) {
      years.add(DateTime.now().year - i);
    }
  }

  void setDay(int day) {
    this.day = day;
  }

  void setMonth(int month) {
    this.month = month;
    print("set month $month");
  }

  void setYear(int year) {
    this.year = year;
  }

  void changeMonths() {
    var dateUtility = DateUtilities();
    int daysInMonth = dateUtility.daysInMonth(month, year) ?? 1;

    //Kiểm tra nếu số ngày tháng trước đó lớn hơn số ngày tháng được chọn
    //thì reset lại về ngày 1
    if (days.length > daysInMonth) {
      if (day > daysInMonth) {
        day = 1;
        dayController?.animateToItem(day - 1,
            duration: Duration(microseconds: 20), curve: Curves.bounceIn);
        print("refresh");
      }
    }
    days.clear();
    daysSink.add(days);
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }

    daysSink.add(days);
  }

  @override
  void dispose() {
    daysSubject.drain();
    daysSubject.close();

    super.dispose();
  }
}
