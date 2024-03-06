import 'package:flutter/material.dart';
import 'package:logisticapp/providers/supabase_manager.dart';

class AvailableVehicles extends StatefulWidget {
  const AvailableVehicles({super.key});

  @override
  State<AvailableVehicles> createState() => _AvailableVehiclesState();
}

class _AvailableVehiclesState extends State<AvailableVehicles> {
  final vehicleData = SupabaseManager();
  late dynamic vehicle;

  @override
  void initState() {
    readData();
    super.initState();
  }

  readData() async {
    vehicle = await vehicleData.readData();
    print(vehicle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: vehicle.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${vehicle[index]['vehicle_name']}"),
            leading: Text("Capacity : ${vehicle[index]['capacity']} KG"),
            trailing: Text("${vehicle[index]['wheels']} wheeler"),
          );
        },
      ),
    );
  }
}
