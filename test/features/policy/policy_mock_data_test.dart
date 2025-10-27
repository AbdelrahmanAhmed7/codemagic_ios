import 'package:flutter_test/flutter_test.dart';
import 'package:mediconsult/features/policy/data/policy_mock_data.dart';

void main() {
  group('PolicyMockData Tests', () {
    test('getServices should return 9 services', () {
      // Act
      final services = PolicyMockData.getServices();

      // Assert
      expect(services.length, 9);
    });

    test('getServices should have correct service names', () {
      // Act
      final services = PolicyMockData.getServices();

      // Assert
      expect(services[0].name, 'Pharmacy');
      expect(services[1].name, 'Lab');
      expect(services[3].name, 'Hospital');
      expect(services[4].name, 'Doctor');
    });

    test('getPolicyDetailsByService should return Pharmacy details', () {
      // Act
      final details = PolicyMockData.getPolicyDetailsByService('Pharmacy');

      // Assert
      expect(details.serviceName, 'Pharmacy');
      expect(details.coveragePercentage, '10%');
      expect(details.providers.length, 3);
      expect(details.providers[0].name, 'El Ezaby Pharmacy');
    });

    test('getPolicyDetailsByService should return Lab details', () {
      // Act
      final details = PolicyMockData.getPolicyDetailsByService('Lab');

      // Assert
      expect(details.serviceName, 'Lab');
      expect(details.coveragePercentage, '20%');
      expect(details.providers.length, 3);
      expect(details.providers[0].name, 'Al Borg Lab');
    });

    test('getPolicyDetailsByService should return Hospital details', () {
      // Act
      final details = PolicyMockData.getPolicyDetailsByService('Hospital');

      // Assert
      expect(details.serviceName, 'Hospital');
      expect(details.coveragePercentage, '15%');
      expect(details.providers.length, 2);
      expect(details.providers[0].name, 'Dar El Fouad Hospital');
    });

    test('getPolicyDetailsByService should return Doctor details', () {
      // Act
      final details = PolicyMockData.getPolicyDetailsByService('Doctor');

      // Assert
      expect(details.serviceName, 'Doctor');
      expect(details.coveragePercentage, '25%');
      expect(details.providers.length, 2);
    });

    test('getPolicyDetailsByService should handle case insensitive input', () {
      // Act
      final detailsLower = PolicyMockData.getPolicyDetailsByService('pharmacy');
      final detailsUpper = PolicyMockData.getPolicyDetailsByService('PHARMACY');
      final detailsMixed = PolicyMockData.getPolicyDetailsByService('PhArMaCy');

      // Assert
      expect(detailsLower.serviceName, 'Pharmacy');
      expect(detailsUpper.serviceName, 'Pharmacy');
      expect(detailsMixed.serviceName, 'Pharmacy');
    });

    test('getPolicyDetailsByService should return default for unknown service', () {
      // Act
      final details = PolicyMockData.getPolicyDetailsByService('Unknown Service');

      // Assert
      expect(details.serviceName, 'Unknown Service');
      expect(details.coveragePercentage, '10%');
      expect(details.providers.length, 2);
      expect(details.providers[0].name, 'Unknown Service Provider 1');
    });

    test('getPharmacyPolicyDetails should return same as getPolicyDetailsByService', () {
      // Act
      final detailsOld = PolicyMockData.getPharmacyPolicyDetails();
      final detailsNew = PolicyMockData.getPolicyDetailsByService('Pharmacy');

      // Assert
      expect(detailsOld.serviceName, detailsNew.serviceName);
      expect(detailsOld.coveragePercentage, detailsNew.coveragePercentage);
      expect(detailsOld.providers.length, detailsNew.providers.length);
    });
  });
}
