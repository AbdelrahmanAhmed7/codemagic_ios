class PolicyService {
  final String id;
  final String name;
  final String icon;
  final String color;
  final String route;

  PolicyService({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class PolicyDetails {
  final String serviceName;
  final String coveragePercentage;
  final String coverageType;
  final List<PolicyProvider> providers;

  PolicyDetails({
    required this.serviceName,
    required this.coveragePercentage,
    required this.coverageType,
    required this.providers,
  });
}

class PolicyProvider {
  final String id;
  final String name;
  final String logo;
  final String copaymentPercentage;
  final String copaymentType;

  PolicyProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.copaymentPercentage,
    required this.copaymentType,
  });
}
