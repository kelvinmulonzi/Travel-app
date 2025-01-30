import 'package:get/get.dart';

class BookingController extends GetxController {
  var bookingId = 0.obs;

  void setBookingId(int id) {
    bookingId.value = id;
  }
}