enum PolicyItemType { service, provider }

class PolicyItem {
  final String id;
  final String name;
  final PolicyItemType type;
  final String? icon;
  final String? color;
  final String? route;
  final String? description;
  final String? additionalInfo;

  PolicyItem({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    this.route,
    this.description,
    this.additionalInfo,
  });

  factory PolicyItem.fromService(PolicyService service) {
    return PolicyItem(
      id: service.id,
      name: service.name,
      type: PolicyItemType.service,
      icon: service.icon,
      color: service.color,
      route: service.route,
    );
  }

  factory PolicyItem.fromProvider(PolicyProvider provider) {
    return PolicyItem(
      id: provider.id,
      name: provider.name,
      type: PolicyItemType.provider,
      icon: provider.logo,
      description: provider.copaymentType,
      additionalInfo: provider.copaymentPercentage,
    );
  }
}

// Legacy models kept for backward compatibility
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
