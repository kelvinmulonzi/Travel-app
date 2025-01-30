class PaymentResponse {
  final bool success;
  final String message;
  final String? merchantRequestId;
  final String? checkoutRequestId;
  final String? responseCode;
  final String? responseDescription;
  final String? customerMessage;

  PaymentResponse({
    required this.success,
    required this.message,
    this.merchantRequestId,
    this.checkoutRequestId,
    this.responseCode,
    this.responseDescription,
    this.customerMessage,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown response',
      merchantRequestId: json['MerchantRequestID'],
      checkoutRequestId: json['CheckoutRequestID'],
      responseCode: json['ResponseCode'],
      responseDescription: json['ResponseDescription'],
      customerMessage: json['CustomerMessage'],
    );
  }
}