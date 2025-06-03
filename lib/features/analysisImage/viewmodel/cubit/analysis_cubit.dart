import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/analysisImage/viewmodel/repositories/analysis_repository.dart';

part 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final AnalysisRepository repository;
  bool _isClosed = false; 

  AnalysisCubit(this.repository) : super(AnalysisInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  Future<void> analyzeImage({
    required File imageFile,
    required String portionSize,
    required String healthConditions,
  }) async {
    if (_isClosed) return; 
    
    emit(AnalysisLoading());
    try {
      final response = await repository.analyzeImage(
        imageFile: imageFile,
        portionSize: portionSize,
        healthConditions: healthConditions,
      );
      
      if (!_isClosed) { 
        emit(AnalysisSuccess(response));
      }
    } catch (e) {
      if (!_isClosed ) { 
        emit(AnalysisError(e.toString()));
      }
    }
   }
}