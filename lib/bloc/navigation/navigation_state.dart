import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  final int currentIndex;

  const NavigationState({required this.currentIndex});

  @override
  List<Object?> get props => [currentIndex];
}

class NavigationHome extends NavigationState {
  const NavigationHome() : super(currentIndex: 0);
}

class NavigationArchive extends NavigationState {
  const NavigationArchive() : super(currentIndex: 1);
}

class NavigationArtists extends NavigationState {
  const NavigationArtists() : super(currentIndex: 2);
}

class NavigationProfile extends NavigationState {
  const NavigationProfile() : super(currentIndex: 3);
}

class NavigationDetail extends NavigationState {
  final NavigationType type;
  final String id;
  final int previousIndex;

  const NavigationDetail({
    required this.type,
    required this.id,
    required this.previousIndex,
  }) : super(currentIndex: previousIndex);

  @override
  List<Object?> get props => [currentIndex, type, id, previousIndex];
}

class NavigationSettings extends NavigationState {
  final int previousIndex;

  const NavigationSettings({required this.previousIndex})
      : super(currentIndex: previousIndex);

  @override
  List<Object?> get props => [currentIndex, previousIndex];
}

enum NavigationType {
  video,
  artist,
  playlist,
}
