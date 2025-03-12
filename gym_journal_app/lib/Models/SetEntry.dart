import 'package:flutter/material.dart';

class SetEntry {
    dynamic weight;
    dynamic reps;
    bool isComplete;
    late TextEditingController weightController;
    late TextEditingController repsController;
    int? setOrder;
    String? exerciseId;    // document id of exercise in firestore. exercise is related to the workout

    SetEntry({this.weight = 0, this.reps = 0, this.isComplete = false}) {
        weightController = TextEditingController(text: weight.toString());
        repsController = TextEditingController(text: reps.toString());
    }

    void dispose() {
        weightController.dispose();
        repsController.dispose();
    }

    ToJSON() {
        return {
            'weight': weight,
            'reps': reps,
            'isComplete': isComplete,
            'setOrder': setOrder,
            'exerciseId': exerciseId,
        };
    }
}