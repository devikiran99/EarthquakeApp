import 'package:earthquake/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../provider/earthquake_provider.dart';
import '../utils/helper_functions.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final weather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("EarthQuake App"),
        actions: [
          IconButton(
            onPressed: () {
              _showSortDialog();
            },
            icon: Icon(Icons.sort),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: weather.when(
          data: (model) => ListView.builder(
            itemCount: model.features!.length,
            itemBuilder: (context, index) {
              final data = model.features![index].properties!;
              return ListTile(
                title: Text(data.place ?? data.title ?? "Unknow"),
                subtitle: Text(
                  getFormattedDateTime(
                    data.time!,
                    "EEE MMM dd yyyy hh:mm a",
                  ),
                ),
                trailing: Chip(
                  avatar: data.alert == null
                      ? null
                      : CircleAvatar(
                    backgroundColor: getAlertColor(
                      data.alert!,
                    ),
                  ),
                  label: Text("${data.mag}"),
                ),
              );
            },
          ),
          error:(error, stackTrace) => Center(child: Text("Error: ${error.toString()}")),
          loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final groupValue = orderFilterValues[ref.read(orderFilterProvider)]!;
        return AlertDialog(
          title: Text("Sort by"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadiGroup(
                groupValue: groupValue,
                value: "magnitude-asc",
                label: "Magnitude-Asc",
                onChange: (value) {
                  Navigator.pop(context);
                  ref.read(orderFilterProvider.notifier).update((state) => state = OrderFilter.magnitudeAsc);
                },
              ),

              RadiGroup(
                groupValue: groupValue,
                value: "magnitude",
                label: "Magnitude-Desc",
                onChange: (value) {
                  Navigator.pop(context);
                  ref.read(orderFilterProvider.notifier).update((state) => state = OrderFilter.magnitude);
                },
              ),

              RadiGroup(
                groupValue: groupValue,
                value: "time",
                label: "Time-Desc",
                onChange: (value) {
                  Navigator.pop(context);
                  ref.read(orderFilterProvider.notifier).update((state) => state = OrderFilter.time);
                },
              ),
              RadiGroup(
                groupValue: groupValue,
                value: "time-asc",
                label: "Time-Asc",
                onChange: (value) {
                  Navigator.pop(context);
                  ref.read(orderFilterProvider.notifier).update((state) => state = OrderFilter.timeAsc);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

class RadiGroup extends StatelessWidget {
  final String groupValue;
  final String value;
  final String label;
  final Function(String?) onChange;

  const RadiGroup({
    super.key,
    required this.groupValue,
    required this.value,
    required this.label,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        Text(label),
      ],
    );
  }
}
