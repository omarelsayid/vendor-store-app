import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vendor.dart';

// state notifre is class provided by Riverpod package thathelps in
// managing the state , it is designed to notify listeners about the state changes
class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
      : super(Vendor(
            id: '',
            fullName: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            role: '',
            password: ''));

  // getter method to extarct value from an object

  Vendor? get vendor => state;

  // Method to set vendor user statte from json
  // purpose: updates the user state base on json String represention of the vendor object to Dart object
  // so we can use it within the application

  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

// method to clear the vendor user state

  void signOut() {
    state = null;
  }
}

/// make the data accisible wthin the application

final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>(
  (ref) => VendorProvider(),
);
