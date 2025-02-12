import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Models/User.dart';
import 'package:gym_journal_app/Models/WaterConsumed.dart';
import 'package:gym_journal_app/Utilities/common_tools.dart';

class DatabaseController {
  final _firestore = FirebaseFirestore.instance;
  final _commonTools = CommonTools();

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<Result> RegisterNewUser(UserModel data) async{
    try {
        var firestoreCollection = _firestore.collection('users');
      
        await firestoreCollection.doc(data.userId).set(data.ToJSON());
        return Result(success: true, message: 'User registered successfully');
       
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  Future<Result> DeleteUser(String userId) async {
    try {
      var firestoreCollection = _firestore.collection('users');

      await firestoreCollection.doc(userId).delete();
      var user = FirebaseAuth.instance.currentUser;
      await user!.delete();

      return Result(success: true, message: 'User deleted successfully');
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  // Specfiying third parameter will log data to a subcollection
  Future<Result> AddToCollection(String collection, dynamic data, String? subCollection) async {
    try {
      if (subCollection == null) {
        var firestoreCollection = _firestore.collection(collection);
      
        await firestoreCollection.add(data.ToJSON());

        return Result(success: true, message: 'Data added successfully');
      } else if (subCollection.isNotEmpty) {
        var firestoreCollection = _firestore.collection(collection).doc('all-entries').collection(subCollection);

        await firestoreCollection.add(data.ToJSON());

        return Result(success: true, message: 'Exercise logged successfully');
      } else {
        return Result(success: false, message: 'Error adding data to collection');
      }
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  Future<Result> RetrieveCollection(String collection, String? subCollection) async {
    try {
        var userId = FirebaseAuth.instance.currentUser!.uid;
      if (subCollection == null) {
        var firestoreCollection = _firestore.collection(collection);

        var data = await firestoreCollection.where('userId', isEqualTo: userId).get();

        return Result(success: true, message: 'Data retrieved successfully', data: data);
      } else {
        var firestoreCollection = _firestore.collection(collection).doc('all-entries').collection(subCollection);

        var data = await firestoreCollection.where('userId', isEqualTo: userId).get();

        return Result(success: true, message: 'Data retrieved successfully', data: data);
      }
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  Future<Result> GetWaterLoggedToday() async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      var firestoreCollection = _firestore.collection('entries').doc('all-entries').collection('water');

      var data = await firestoreCollection.where('userId', isEqualTo: userId).where('drinkDate', isEqualTo: _commonTools.getFormattedDate()).get();

      return Result(success: true, message: 'Data retrieved successfully', data: data);
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  Future<Result> UpdateDocument(String collection, String documentID, dynamic data) async {
    try {
      var firestoreCollection = _firestore.collection(collection);

      await firestoreCollection.doc(documentID).update(data);

      return Result(success: true, message: 'Document updated successfully');
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  Future<Result> RetrieveUserDetails() async {
    try {
      // retrieve currently logged in user
      User? user = FirebaseAuth.instance.currentUser;
      String? email;
      if (user != null) {
        email = user.email;
      }

      // retrieve user details from custom user collection
      var firestoreCollection = _firestore.collection('users');

      var details = await firestoreCollection
      .where('email', isEqualTo: email)
      .get();

      //var readableDetails = details.docs[0].data();
      //print('get user details $readableDetails');

      return Result(success: true, message: 'User details retrieved successfully', data: details);
    } catch(e) {
      return Result(success: false, message: e.toString());
    }
  }

  Future<Result> UpdateAccount(String userId, dynamic data) async {
    try {
        var firestoreCollection = _firestore.collection('users');

        await firestoreCollection.doc(userId).update(data);
        return Result(success: true, message: 'Account updated successfully');
    } catch(e) {
      return Result(success: false, message: e.toString());
    }
  }

  Future<Result> getWaterConsumed() async {
        try {
            Result entries = await GetWaterLoggedToday();
            Result userDetailsFromDb = await RetrieveUserDetails();
            if (entries.success && userDetailsFromDb.success) {
                // get user water goals and convert to ml before checking progress
                var userDetails = userDetailsFromDb.data;
                var details = userDetails.docs[0].data();
                double goalInMl = _commonTools.convertToMl(details['waterGoal'], details['waterUnit']);  // convert goal to ml for minimum precision loss
                double waterDrank = 0.0;  // convert all water entries to ml - most precise measurement meaning precision loss is minimal
                
                var snapshot = entries.data;
                var waterEntries = snapshot.docs.map((doc) => doc.data()).toList();
                waterEntries.forEach((entry) {
                    // Accessing values
                    String waterUnits = entry["waterUnits"];
                    double waterAmount = entry["waterAmount"].toDouble(); // Ensuring it's a double

                    double convertedAmount = _commonTools.convertToMl(waterAmount, waterUnits);
                    waterDrank = waterDrank + convertedAmount;
                });

                WaterConsumed waterDrankToday = WaterConsumed(
                    waterConsumed: waterDrank,
                    waterGoal: goalInMl,
                    progress: (waterDrank / goalInMl) * 100,
                    consumedInPreferredUnit: _commonTools.convertToPreferredUnit(waterDrank, details['waterUnit']),
                );

                return Result(success: true, message: 'Water entries retrieved successfully', data: waterDrankToday);
            } else {
                return Result(success: false, message: 'Error retrieving water entries');
            }
        } catch(e) {
            return Result(success: false, message: e.toString());
        }
    }
}