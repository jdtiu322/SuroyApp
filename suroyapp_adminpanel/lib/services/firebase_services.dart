import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference bookings = FirebaseFirestore.instance.collection('bookings');
  CollectionReference vehicleListings = FirebaseFirestore.instance.collection('vehicleListings');

  Future<int> getNumberOfUsers() async {
    try {
      QuerySnapshot querySnapshot = await users.get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting users: $e');
      return 0;
    }
  }

  Future<int> getNumberOfBookings() async {
    try {
      QuerySnapshot querySnapshot = await bookings.get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting bookings: $e');
      return 0;
    }
  }

  Future<int> getNumberOfVehicleListings() async {
    try {
      QuerySnapshot querySnapshot = await vehicleListings.get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting vehicle listings: $e');
      return 0;
    }
  }

  Future<List<DocumentSnapshot>> getRecentUsers({int limit = 5}) async {
    try {
      QuerySnapshot querySnapshot = await users
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching recent users: $e');
      return [];
    }
  }

}
