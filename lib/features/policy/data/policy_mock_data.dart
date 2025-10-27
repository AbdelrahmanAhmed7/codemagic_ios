import 'package:mediconsult/features/policy/data/policy_models.dart';

class PolicyMockData {
  static List<PolicyService> getServices() {
    return [
      PolicyService(
        id: '1',
        name: 'Pharmacy',
        icon: '💊',
        color: 'FFE5D3',
        route: '/pharmacy-policy',
      ),
      PolicyService(
        id: '2',
        name: 'Lab',
        icon: '🔬',
        color: 'D3F5E5',
        route: '/lab-policy',
      ),
      PolicyService(
        id: '3',
        name: 'Pharmacy',
        icon: '💊',
        color: 'FFD3E5',
        route: '/pharmacy-policy',
      ),
      PolicyService(
        id: '4',
        name: 'Hospital',
        icon: '🏥',
        color: 'D3E5FF',
        route: '/hospital-policy',
      ),
      PolicyService(
        id: '5',
        name: 'Doctor',
        icon: '👨‍⚕️',
        color: 'E5E5E5',
        route: '/doctor-policy',
      ),
      PolicyService(
        id: '6',
        name: 'Scan Lab',
        icon: '🔍',
        color: 'FFF5D3',
        route: '/scan-lab-policy',
      ),
      PolicyService(
        id: '7',
        name: 'Specialized Center',
        icon: '💗',
        color: 'FFD3F5',
        route: '/specialized-center-policy',
      ),
      PolicyService(
        id: '8',
        name: 'Physiotherapy',
        icon: '🦴',
        color: 'D3E5F5',
        route: '/physiotherapy-policy',
      ),
      PolicyService(
        id: '9',
        name: 'Optical Center',
        icon: '👓',
        color: 'D3F5F5',
        route: '/optical-center-policy',
      ),
    ];
  }

  static PolicyDetails getPolicyDetailsByService(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'pharmacy':
        return PolicyDetails(
          serviceName: 'Pharmacy',
          coveragePercentage: '10%',
          coverageType: 'Standard Co-payment',
          providers: [
            PolicyProvider(
              id: '1',
              name: 'El Ezaby Pharmacy',
              logo: '🏪',
              copaymentPercentage: '15%',
              copaymentType: 'Higher Co-payment',
            ),
            PolicyProvider(
              id: '2',
              name: 'Misr Pharmacy',
              logo: '🏪',
              copaymentPercentage: '20%',
              copaymentType: 'Highest Co-payment',
            ),
            PolicyProvider(
              id: '3',
              name: 'SEIF Pharmacy',
              logo: '🏪',
              copaymentPercentage: '10%',
              copaymentType: 'Standard Co-payment',
            ),
          ],
        );
      case 'lab':
        return PolicyDetails(
          serviceName: 'Lab',
          coveragePercentage: '20%',
          coverageType: 'Standard Co-payment',
          providers: [
            PolicyProvider(
              id: '1',
              name: 'Al Borg Lab',
              logo: '🔬',
              copaymentPercentage: '20%',
              copaymentType: 'Standard Co-payment',
            ),
            PolicyProvider(
              id: '2',
              name: 'Al Mokhtabar Lab',
              logo: '🔬',
              copaymentPercentage: '25%',
              copaymentType: 'Higher Co-payment',
            ),
            PolicyProvider(
              id: '3',
              name: 'Biolab',
              logo: '🔬',
              copaymentPercentage: '20%',
              copaymentType: 'Standard Co-payment',
            ),
          ],
        );
      case 'hospital':
        return PolicyDetails(
          serviceName: 'Hospital',
          coveragePercentage: '15%',
          coverageType: 'Standard Co-payment',
          providers: [
            PolicyProvider(
              id: '1',
              name: 'Dar El Fouad Hospital',
              logo: '🏥',
              copaymentPercentage: '15%',
              copaymentType: 'Standard Co-payment',
            ),
            PolicyProvider(
              id: '2',
              name: 'Saudi German Hospital',
              logo: '🏥',
              copaymentPercentage: '20%',
              copaymentType: 'Higher Co-payment',
            ),
          ],
        );
      case 'doctor':
        return PolicyDetails(
          serviceName: 'Doctor',
          coveragePercentage: '25%',
          coverageType: 'Standard Co-payment',
          providers: [
            PolicyProvider(
              id: '1',
              name: 'Dr. Ahmed Mohamed',
              logo: '👨‍⚕️',
              copaymentPercentage: '25%',
              copaymentType: 'Standard Co-payment',
            ),
            PolicyProvider(
              id: '2',
              name: 'Dr. Sara Hassan',
              logo: '👨‍⚕️',
              copaymentPercentage: '30%',
              copaymentType: 'Higher Co-payment',
            ),
          ],
        );
      default:
        return PolicyDetails(
          serviceName: serviceName,
          coveragePercentage: '10%',
          coverageType: 'Standard Co-payment',
          providers: [
            PolicyProvider(
              id: '1',
              name: '$serviceName Provider 1',
              logo: '🏢',
              copaymentPercentage: '10%',
              copaymentType: 'Standard Co-payment',
            ),
            PolicyProvider(
              id: '2',
              name: '$serviceName Provider 2',
              logo: '🏢',
              copaymentPercentage: '15%',
              copaymentType: 'Higher Co-payment',
            ),
          ],
        );
    }
  }
  
  // Keep old method for backward compatibility
  static PolicyDetails getPharmacyPolicyDetails() {
    return getPolicyDetailsByService('Pharmacy');
  }
}
