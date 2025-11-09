import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PolicyServiceHelper {
  static IconData getServiceIcon(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'lab':
        return Icons.biotech;
      case 'hospital':
        return Icons.local_hospital;
      case 'doctor':
        return Icons.medical_services;
      case 'scan lab':
        return Icons.scanner;
      default:
        return Icons.business;
    }
  }

  static String getProvidersPluralLabel(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('pharmacy')) return 'policy_screen.pharmacies';
    if (name.contains('lab')) return 'policy_screen.labs';
    if (name.contains('hospital')) return 'policy_screen.hospitals';
    if (name.contains('doctor')) return 'policy_screen.doctors';
    if (name.contains('scan')) return 'policy_screen.scan_labs';
    if (name.contains('specialized')) return 'policy_screen.specialized_centers';
    if (name.contains('physio')) return 'policy_screen.physiotherapy';
    if (name.contains('optical')) return 'policy_screen.optical_centers';
    return 'policy_screen.providers';
  }

  static String getLocalizedServiceName(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('pharmacy')) return 'policy_screen.pharmacy'.tr();
    if (name.contains('lab')) return 'policy_screen.lab'.tr();
    if (name.contains('hospital')) return 'policy_screen.hospital'.tr();
    if (name.contains('doctor')) return 'policy_screen.doctor'.tr();
    if (name.contains('scan')) return 'policy_screen.scan_lab'.tr();
    if (name.contains('specialized')) return 'policy_screen.specialized_center'.tr();
    if (name.contains('physio')) return 'policy_screen.physiotherapy'.tr();
    if (name.contains('optical')) return 'policy_screen.optical_center'.tr();
    return serviceName;
  }
}
