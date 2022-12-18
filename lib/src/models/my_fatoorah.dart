// To parse this JSON data, do
//
//     final myFatoorah = myFatoorahFromJson(jsondynamic);

import 'dart:convert';

MyFatoorah myFatoorahFromJson(dynamic str) => MyFatoorah.fromJson(json.decode(str));

dynamic myFatoorahToJson(MyFatoorah data) => json.encode(data.toJson());

class MyFatoorah {
  MyFatoorah({
    this.invoiceId,
    this.invoiceStatus,
    this.invoiceReference,
    this.customerReference,
    this.createdDate,
    this.expiryDate,
    this.invoiceValue,
    this.comments,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.userDefinedField,
    this.invoiceDisplayValue,
    this.invoiceItems,
    this.invoiceTransactions,
  });

  dynamic invoiceId;
  dynamic invoiceStatus;
  dynamic invoiceReference;
  dynamic customerReference;
  dynamic createdDate;
  dynamic expiryDate;
  dynamic invoiceValue;
  dynamic comments;
  dynamic customerName;
  dynamic customerMobile;
  dynamic customerEmail;
  dynamic userDefinedField;
  dynamic invoiceDisplayValue;
  List<dynamic> invoiceItems;
  List<InvoiceTransaction> invoiceTransactions;

  factory MyFatoorah.fromJson(Map<dynamic, dynamic> json) => MyFatoorah(
    invoiceId: json["InvoiceId"] == null ? null : json["InvoiceId"],
    invoiceStatus: json["InvoiceStatus"] == null ? null : json["InvoiceStatus"],
    invoiceReference: json["InvoiceReference"] == null ? null : json["InvoiceReference"],
    customerReference: json["CustomerReference"],
    createdDate: json["CreatedDate"] == null ? null : DateTime.parse(json["CreatedDate"]),
    expiryDate: json["ExpiryDate"] == null ? null : json["ExpiryDate"],
    invoiceValue: json["InvoiceValue"] == null ? null : json["InvoiceValue"],
    comments: json["Comments"],
    customerName: json["CustomerName"] == null ? null : json["CustomerName"],
    customerMobile: json["CustomerMobile"] == null ? null : json["CustomerMobile"],
    customerEmail: json["CustomerEmail"],
    userDefinedField: json["UserDefinedField"],
    invoiceDisplayValue: json["InvoiceDisplayValue"] == null ? null : json["InvoiceDisplayValue"],
    invoiceItems: json["InvoiceItems"] == null ? null : List<dynamic>.from(json["InvoiceItems"].map((x) => x)),
    invoiceTransactions: json["InvoiceTransactions"] == null ? null : List<InvoiceTransaction>.from(json["InvoiceTransactions"].map((x) => InvoiceTransaction.fromJson(x))),
  );

  Map<dynamic, dynamic> toJson() => {
    "InvoiceId": invoiceId == null ? null : invoiceId,
    "InvoiceStatus": invoiceStatus == null ? null : invoiceStatus,
    "InvoiceReference": invoiceReference == null ? null : invoiceReference,
    "CustomerReference": customerReference,
    "CreatedDate": createdDate == null ? null : createdDate.toIso8601dynamic(),
    "ExpiryDate": expiryDate == null ? null : expiryDate,
    "InvoiceValue": invoiceValue == null ? null : invoiceValue,
    "Comments": comments,
    "CustomerName": customerName == null ? null : customerName,
    "CustomerMobile": customerMobile == null ? null : customerMobile,
    "CustomerEmail": customerEmail,
    "UserDefinedField": userDefinedField,
    "InvoiceDisplayValue": invoiceDisplayValue == null ? null : invoiceDisplayValue,
    "InvoiceItems": invoiceItems == null ? null : List<dynamic>.from(invoiceItems.map((x) => x)),
    "InvoiceTransactions": invoiceTransactions == null ? null : List<dynamic>.from(invoiceTransactions.map((x) => x.toJson())),
  };
}

class InvoiceTransaction {
  InvoiceTransaction({
    this.transactionDate,
    this.paymentGateway,
    this.referenceId,
    this.trackId,
    this.transactionId,
    this.paymentId,
    this.authorizationId,
    this.transactionStatus,
    this.transationValue,
    this.customerServiceCharge,
    this.dueValue,
    this.paidCurrency,
    this.paidCurrencyValue,
    this.currency,
    this.error,
    this.cardNumber,
  });

  dynamic transactionDate;
  dynamic paymentGateway;
  dynamic referenceId;
  dynamic trackId;
  dynamic transactionId;
  dynamic paymentId;
  dynamic authorizationId;
  dynamic transactionStatus;
  dynamic transationValue;
  dynamic customerServiceCharge;
  dynamic dueValue;
  dynamic paidCurrency;
  dynamic paidCurrencyValue;
  dynamic currency;
  dynamic error;
  dynamic cardNumber;

  factory InvoiceTransaction.fromJson(Map<dynamic, dynamic> json) => InvoiceTransaction(
    transactionDate: json["TransactionDate"] == null ? null : DateTime.parse(json["TransactionDate"]),
    paymentGateway: json["PaymentGateway"] == null ? null : json["PaymentGateway"],
    referenceId: json["ReferenceId"] == null ? null : json["ReferenceId"],
    trackId: json["TrackId"] == null ? null : json["TrackId"],
    transactionId: json["TransactionId"] == null ? null : json["TransactionId"],
    paymentId: json["PaymentId"] == null ? null : json["PaymentId"],
    authorizationId: json["AuthorizationId"] == null ? null : json["AuthorizationId"],
    transactionStatus: json["TransactionStatus"] == null ? null : json["TransactionStatus"],
    transationValue: json["TransationValue"] == null ? null : json["TransationValue"],
    customerServiceCharge: json["CustomerServiceCharge"] == null ? null : json["CustomerServiceCharge"],
    dueValue: json["DueValue"] == null ? null : json["DueValue"],
    paidCurrency: json["PaidCurrency"] == null ? null : json["PaidCurrency"],
    paidCurrencyValue: json["PaidCurrencyValue"] == null ? null : json["PaidCurrencyValue"],
    currency: json["Currency"] == null ? null : json["Currency"],
    error: json["Error"] == null ? null : json["Error"],
    cardNumber: json["CardNumber"],
  );

  Map<dynamic, dynamic> toJson() => {
    "TransactionDate": transactionDate == null ? null : transactionDate.toIso8601dynamic(),
    "PaymentGateway": paymentGateway == null ? null : paymentGateway,
    "ReferenceId": referenceId == null ? null : referenceId,
    "TrackId": trackId == null ? null : trackId,
    "TransactionId": transactionId == null ? null : transactionId,
    "PaymentId": paymentId == null ? null : paymentId,
    "AuthorizationId": authorizationId == null ? null : authorizationId,
    "TransactionStatus": transactionStatus == null ? null : transactionStatus,
    "TransationValue": transationValue == null ? null : transationValue,
    "CustomerServiceCharge": customerServiceCharge == null ? null : customerServiceCharge,
    "DueValue": dueValue == null ? null : dueValue,
    "PaidCurrency": paidCurrency == null ? null : paidCurrency,
    "PaidCurrencyValue": paidCurrencyValue == null ? null : paidCurrencyValue,
    "Currency": currency == null ? null : currency,
    "Error": error == null ? null : error,
    "CardNumber": cardNumber,
  };
}