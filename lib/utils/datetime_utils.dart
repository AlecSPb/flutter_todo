import 'package:intl/intl.dart';

class DateTimeUtils {
  
  static String get currentDay {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  static String get currentMonth {
    DateTime now = DateTime.now();
    print(now);
    return DateFormat('EEEE').format(now);
  }

  static String get currentDate {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  static String get currentWeek {
    DateTime now = DateTime.now();
    String weekstr = DateFormat("EEEE").format(now);
    var listweek = {"Monday":"星期一","Tuesday":"星期二","Wednesday":"星期三","Thursday":"星期四","Friday":"星期五","Saturday":"星期六","Sunday":"星期日"};
    print(listweek[weekstr]);
    return listweek[weekstr];
  }

}
