import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Models/User.dart';
import 'package:gym_journal_app/Models/WaterConsumed.dart';
import 'package:gym_journal_app/Models/WorkoutLog.dart';
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
  
  Future<Result> GetTotalWaterLogged() async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      var firestoreCollection = _firestore.collection('entries').doc('all-entries').collection('water');

      var data = await firestoreCollection.where('userId', isEqualTo: userId).get();

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

  Future<Result> getWaterConsumed({ required bool getTotalWater }) async {
        try {
            Result entries = !getTotalWater ? await GetWaterLoggedToday() : await GetTotalWaterLogged();
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

                    print('total water drank $waterDrank');
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

    Future<Result> getAllExercises() async {
        try {
            var firestoreCollection = _firestore.collection('exercises');

            QuerySnapshot querySnapshot = await firestoreCollection.get();

            // Get data from docs and convert map to List
            final data = querySnapshot.docs.map((doc) => doc.data()).toList();

            Map<String, List> groupedData = {};

            for (var exercise in data) {
                String target = (exercise as Map<String, dynamic>)['target'] ?? 'Unknown';

                if (!groupedData.containsKey(target)) {
                    groupedData[target] = [];
                }
                groupedData[target]!.add(exercise);
            }

            return Result(success: true, message: 'Data retrieved and grouped successfully', data: groupedData);
        } catch (e) {
            return Result(success: false, message: e.toString());
        }
    }

    Future<Result> logNewWorkout(WorkoutLog workout) async {
        try {
            var firestoreCollection = _firestore.collection('entries').doc('all-entries').collection('workouts');

            var workoutData = workout.ToJSON();
            
            var newWorkout = await firestoreCollection.add(workoutData);

            for (int exerciseCounter = 0; exerciseCounter < workout.exercises.length; exerciseCounter++) {
                var exercise = workout.exercises[exerciseCounter];
                exercise.workoutId = newWorkout.id;
                exercise.exerciseOrder = exerciseCounter;
                var exerciseData = exercise.ToJSON();

                var exerciseCollection = _firestore.collection('entries').doc('all-entries').collection('exercises');
                var newExercise = await exerciseCollection.add(exerciseData);

                for (int setCounter = 0; setCounter < (exercise.sets?.length ?? 0); setCounter++) {
                    var set = exercise.sets![setCounter];
                    set.exerciseId = newExercise.id;
                    set.setOrder = setCounter;
                    set.weight = int.parse(set.weightController.text);
                    set.reps = int.parse(set.repsController.text);

                    var setCollection = _firestore.collection('entries').doc('all-entries').collection('sets');

                    await setCollection.add(set.ToJSON());
                }
            }

            return Result(success: true, message: 'Workout logged successfully');
        } catch (e) {
            return Result(success: false, message: e.toString());
        }
    }

    Future<Result> getWorkoutData(String workoutId) async {
        try {
            var firestoreCollection = _firestore.collection('entries').doc('all-entries').collection('exercises');

            var querySnapshot = await firestoreCollection.where('workoutId', isEqualTo: workoutId).get();

            var exercises = querySnapshot.docs.map((doc) {
                var data = doc.data();
                data['id'] = doc.id; // Retain the document ID
                return data;
            }).toList();

            exercises.sort((a, b) => (a['exerciseOrder'] as int).compareTo(b['exerciseOrder'] as int));

            for (int i = 0; i < exercises.length; i++) {
                var exercise = exercises[i];
                var exerciseId = exercise['id'];
                var sets = await _firestore.collection('entries').doc('all-entries').collection('sets').where('exerciseId', isEqualTo: exerciseId).get();

                var setList = sets.docs.map((doc) {
                    var data = doc.data();
                    data['id'] = doc.id;
                    return data;
                }).toList();

                setList.sort((a, b) => (a['setOrder'] as int).compareTo(b['setOrder'] as int));

                exercises[i]['sets'] = setList;
            }

            return Result(success: true, message: 'Workout data retrieved and sorted successfully', data: exercises);
        } catch (e) {
            return Result(success: false, message: e.toString());
        }
    }
}