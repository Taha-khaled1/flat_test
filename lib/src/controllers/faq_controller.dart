import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/faq_category.dart';
import '../repository/faq_repository.dart';

class FaqController extends ControllerMVC {
  List<FaqCategory> faqs = <FaqCategory>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  FaqController() {
    scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFaqs(context);
  }

  void listenForFaqs(BuildContext context, {String message}) async {
    final Stream<FaqCategory> stream = await getFaqCategories();
    stream.listen((FaqCategory _faq) {
      setState(() {
        faqs.add(_faq);
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshFaqs() async {
    faqs.clear();
    listenForFaqs(context, message: S.of(context).faqsRefreshedSuccessfuly);
  }
}
