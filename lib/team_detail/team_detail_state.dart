import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class TeamDetailState extends Equatable {
  final bool isPubgNameValid;
  final bool isTeamNameValid;
  final bool isPhoneNumberValid;
  final bool isTeamMembersValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  const TeamDetailState({
    @required this.isPubgNameValid,
    @required this.isPhoneNumberValid,
    @required this.isTeamNameValid,
    @required this.isTeamMembersValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  @override
  List<Object> get props =>
      [isTeamMembersValid, isTeamNameValid, isPhoneNumberValid, isPubgNameValid, isSubmitting, isFailure, isSuccess];

  factory TeamDetailState.empty() {
    return TeamDetailState(
        isPubgNameValid: true,
        isTeamNameValid: true,
        isPhoneNumberValid: true,
        isTeamMembersValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  factory TeamDetailState.loading() {
    return TeamDetailState(
        isPubgNameValid: true,
        isTeamNameValid: true,
        isPhoneNumberValid: true,
        isTeamMembersValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }

  factory TeamDetailState.success() {
    return TeamDetailState(
        isPubgNameValid: true,
        isTeamNameValid: true,
        isPhoneNumberValid: true,
        isTeamMembersValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }

  factory TeamDetailState.failure() {
    return TeamDetailState(
        isPubgNameValid: true,
        isTeamNameValid: true,
        isPhoneNumberValid: true,
        isTeamMembersValid: true,        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }

  TeamDetailState update({
    bool isPubgNameValid,
    bool isTeamNameValid,
    bool isPhoneNumberValid,
    bool isTeamMembersValid,
  }) {
    return copyWith(
      isPubgNameValid: true,
      isTeamNameValid: true,
      isPhoneNumberValid: true,
      isTeamMembersValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  TeamDetailState copyWith({
    bool isPubgNameValid,
    bool isTeamNameValid,
    bool isPhoneNumberValid,
    bool isTeamMembersValid,
    isSubmitting: false,
    isSuccess: false,
    isFailure: true
  }) {
    return TeamDetailState(
      isPubgNameValid: isPubgNameValid ?? this.isPubgNameValid,
      isTeamNameValid: isTeamNameValid ?? this.isTeamNameValid,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      isTeamMembersValid: isTeamMembersValid ?? this.isTeamMembersValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
       isPubgNameValid: $isPubgNameValid,
      isTeamNameValid: $isTeamNameValid,
      isPhoneNumberValid: $isPhoneNumberValid,
      isTeamMembersValid: $isTeamMembersValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
