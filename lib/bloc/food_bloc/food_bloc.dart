import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../data/models/food_model.dart';
import 'food_event.dart';
import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodInitial()) {
    on<FetchFoodsEvent>(fetchFoodsEvent);
  }

  Future<void> fetchFoodsEvent(
    FetchFoodsEvent event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:2000/api/foods'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<FoodModel> foods = jsonList
            .map((json) => FoodModel.fromJson(json))
            .toList();

        emit(FoodLoaded(foods));
      } else {
        emit(FoodError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(FoodError('No internet or server unreachable: ${e.toString()}'));
    }
  }
}
