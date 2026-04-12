import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

Future<void> requestPermissionIfNeeded(String subtitleFilePath, BuildContext context) async {
  if (subtitleFilePath.isNotEmpty) {
    // Only request permission if a subtitle file is chosen
    PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      // If permission is not granted, request it
      status = await Permission.storage.request();
      if (status.isDenied) {
        // If permission is denied, show an alert dialog
        _showPermissionDeniedDialog(context);
        return; // Exit as we cannot proceed without permission
      } else if (status.isPermanentlyDenied) {
        // If the permission is permanently denied, guide the user to settings
        _showPermissionDeniedDialog(context, permanentlyDenied: true);
        return;
      }
    }
  }
}

void _showPermissionDeniedDialog(BuildContext context, {bool permanentlyDenied = false}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent tapping outside to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Permission Denied'),
        content: Text(
          permanentlyDenied
              ? 'The permission to access external storage has been permanently denied. Please go to the app settings to enable it.'
              : 'You have denied the permission to access external storage. Please allow it to proceed.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (permanentlyDenied) {
                // Optionally, open app settings if permission is permanently denied
                openAppSettings();
              }
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
