import 'package:equatable/equatable.dart';

import '../../data/models/food_model.dart';

abstract class FoodState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<FoodModel> foods;
  FoodLoaded(this.foods);

  @override
  List<Object?> get props => [foods];
}

class FoodError extends FoodState {
  final String message;
  FoodError(this.message);

  @override
  List<Object?> get props => [message];
}