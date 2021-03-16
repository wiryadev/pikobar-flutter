part of 'SelfReportReminderBloc.dart';

abstract class SelfReportReminderEvent extends Equatable {
  const SelfReportReminderEvent([List props = const <dynamic>[]]);
}

class SelfReportReminderListLoad extends SelfReportReminderEvent {
  @override
  List<Object> get props => [];
}

class SelfReportListUpdateReminder extends SelfReportReminderEvent {
  final bool isReminder;
  SelfReportListUpdateReminder(this.isReminder);
  @override
  List<Object> get props => [isReminder];
}

class SelfReportUpdateRecurrenceReport extends SelfReportReminderEvent {
  final String recurrenceReport;
  SelfReportUpdateRecurrenceReport(this.recurrenceReport);
  @override
  List<Object> get props => [recurrenceReport];
}

class SelfReportReminderUpdated extends SelfReportReminderEvent {
  final DocumentSnapshot selfReportReminderList;

  const SelfReportReminderUpdated(this.selfReportReminderList);

  @override
  List<Object> get props => [selfReportReminderList];
}
