import 'package:flutter/material.dart';
import 'package:flutter_app/Themes/theme.dart';

class Dashboard extends StatefulWidget {
    const Dashboard({super.key});

    @override
    State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

    List<Object> fetchLatestLogs(int user) {

        return [
            {
                'type': 'workout', 
                'details': 'Chest & Back'
            }, 
            {
                'type': 'workout', 
                'details': 'Shoulders & Arms'
            }, 
            {
                'type': 'water', 
                'details': '2 litres'
            }, 
            {
                'type': 'workout', 
                'details': 'Legs'
            },
            {
                'type': 'water', 
                'details': '500 ml'
            }
        ];
    }

    @override
    Widget build(BuildContext context) {

        // get water goal from database
        double waterGoal = 3.5;

        // get water consumed for day from database
        double waterConsumed = 1.2;

        // get latest 5 logs for user
        List<Object> latestLogs = fetchLatestLogs(1);
    
        return Container(
            margin: const EdgeInsets.all(16.0),
            child: Expanded(
                child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // align text
                    children: [
                        Text(
                            waterGoal > 0 ? 'Your water goal is $waterGoal litres a day, keep it up!' : 'Set a water goal to view progress!',
                            style: const TextStyle(color: Colors.white),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                LinearProgressIndicator(
                                    value: waterGoal > 0 ? waterConsumed / waterGoal : 0,
                                    backgroundColor: Colors.white,
                                    minHeight: 10,
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    valueColor: const AlwaysStoppedAnimation<Color>(secondaryThemeColour),
                                ),
                                if (waterGoal > 0) 
                                    Text(
                                        '$waterConsumed / $waterGoal litres consumed',
                                        style: const TextStyle(color: Colors.white),
                                    ),
                            ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                            'Recent Logs',
                            style: TextStyle(color: Colors.white),
                            ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: tertiaryThemeColour,
                                    width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: SizedBox(
                                height: 200,
                                child: ListView.builder(
                                    itemCount: latestLogs.length,
                                    itemBuilder: (BuildContext context, int index) {
                                        var log = latestLogs[index] as Map<String, dynamic>;
                                        return Container(
                                            margin: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: ListTile(
                                                leading: Icon(log['type'] == 'workout' ? Icons.fitness_center : Icons.local_drink),
                                                title: Text(log['type'] == 'workout' ? 'Workout' : 'Water Intake'),
                                                subtitle: Text(log['details']),
                                                trailing: const Icon(Icons.arrow_forward_ios),
                                            ),
                                        );
                                    },
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        )
        );
    }
}