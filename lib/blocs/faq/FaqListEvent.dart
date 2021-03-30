import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FaqListEvent extends Equatable {
  const FaqListEvent([List props = const <dynamic>[]]);
}

@immutable
class FaqListLoad extends FaqListEvent {
  final String faqCollection;
  final String category;

  FaqListLoad({this.faqCollection, this.category});

  @override
  List<Object> get props => [faqCollection, category];
}

@immutable
class FaqListUpdate extends FaqListEvent {
  final List<DocumentSnapshot> faqList;

  FaqListUpdate(this.faqList);

  @override
  List<Object> get props => [faqList];
}