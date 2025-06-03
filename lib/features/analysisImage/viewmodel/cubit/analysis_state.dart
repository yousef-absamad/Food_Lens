// lib/cubits/analysis_state.dart
part of 'analysis_cubit.dart';

abstract class AnalysisState {
  const AnalysisState();
}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisSuccess extends AnalysisState {
  final String responseData;
  const AnalysisSuccess(this.responseData);
}

class AnalysisError extends AnalysisState {
  final String message;
  const AnalysisError(this.message);
}