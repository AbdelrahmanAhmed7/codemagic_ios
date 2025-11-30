import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/features/network/logic/network_cubit.dart';
import 'package:mediconsult/features/network/logic/network_state.dart';
import 'package:mediconsult/features/network/presentation/widgets/empty_providers_state.dart';
import 'package:mediconsult/features/network/presentation/widgets/provider_card.dart';

/// Network providers list widget with pagination support
class NetworkProvidersList extends StatelessWidget {
  final ScrollController scrollController;
  final bool isLoadingMore;
  final GlobalKey? firstNavigateKey;
  final GlobalKey? firstPhoneKey;

  const NetworkProvidersList({
    super.key,
    required this.scrollController,
    required this.isLoadingMore,
    this.firstNavigateKey,
    this.firstPhoneKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkCubit, NetworkState>(
      buildWhen: (previous, current) =>
          current is ProvidersLoading ||
          current is ProvidersSuccess ||
          current is ProvidersError ||
          current is ProvidersEmpty ||
          current is ProvidersLoadingMore,
      builder: (context, state) {
        final cubit = context.read<NetworkCubit>();
        final providers = cubit.currentProviders;
        final hasNextPage =
            cubit.currentProviderData?.pagination.hasNextPage ?? false;

        // Show loading only when actively searching (first load)
        if (state is ProvidersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show empty state (initial state or no results)
        if (providers.isEmpty) {
          return const EmptyProvidersState();
        }

        // Show list of providers with pagination indicator
        return ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 16.h, bottom: 40.h),
          itemCount: providers.length + (hasNextPage ? 1 : 0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            // Show provider card
            if (index < providers.length) {
              final isLastItem = index == providers.length - 1 && !hasNextPage;
              return Padding(
                padding: EdgeInsets.only(bottom: isLastItem ? 60.h : 0),
                child: ProviderCard(
                  provider: providers[index],
                  navigateKey: index == 0 ? firstNavigateKey : null,
                  phoneKey: index == 0 ? firstPhoneKey : null,
                ),
              );
            }

            // Show loading indicator at the end
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }
}

