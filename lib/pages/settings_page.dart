import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../provider/earthquake_provider.dart';
import '../utils/helper_functions.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final queryParams = ref.watch(queryParamsProvider);
    final city = ref.watch(cityProvider);
    final shouldUseLocation = ref.watch(shouldShowLoadingProvider);
    ref.listen(shouldShowLoadingProvider, (previous, next) {
      if(next) {
        EasyLoading.show(status: "Fetching location ...");
      }else{
        EasyLoading.dismiss();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            "Time Settings",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text("Start Time"),
                  subtitle: Text(queryParams.starttime),
                  trailing: IconButton(
                    onPressed: () async {
                      final date = await _selectDate();
                      if (date != null) {
                        ref.read(queryParamsProvider.notifier).setStartTime(date);
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                ),
                ListTile(
                  title: Text("End Time"),
                  subtitle: Text(queryParams.endtime),
                  trailing: IconButton(
                    onPressed: () async {
                      final date = await _selectDate();
                      if (date != null) {
                        ref.read(queryParamsProvider.notifier).setEndTime(date);
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                ),

              /*  ElevatedButton(
                  onPressed: () {
                    provider.getEarthquakeData();
                    showMsg(context, "Times are updated");
                  },
                  child: Text("Update Time Changes"),
                ), */
              ],
            ),
          ),
          Text(
            "Location Settings",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Card(
            child: SwitchListTile(
              title: Text(city ?? "Your city unknown"),
              subtitle: (city == null) ? null : Text("Earthquake data will be shown within ${queryParams.maxradiuskm} KM radios $city"),
              value: shouldUseLocation,
              onChanged: (value) async {
               ref.read(queryParamsProvider.notifier).setLocation(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _selectDate() async {
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (dt != null) {
      return getFormattedDateTime(dt.millisecondsSinceEpoch);
    }
    return null;
  }
}
