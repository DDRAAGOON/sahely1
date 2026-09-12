import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/usecases/get_properties_usecase.dart';
import '../../domain/usecases/get_property_details_usecase.dart';
import '../../domain/usecases/get_trending_properties_usecase.dart';
import '../../domain/usecases/get_offers_usecase.dart';
import '../../domain/usecases/search_properties_usecase.dart';

// Events
abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class LoadPropertiesEvent extends PropertyEvent {
  final PropertySearchFilters? filters;
  final int page;
  final int limit;

  const LoadPropertiesEvent({
    this.filters,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [filters, page, limit];
}

class LoadPropertyDetailsEvent extends PropertyEvent {
  final String propertyId;

  const LoadPropertyDetailsEvent(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class LoadTrendingPropertiesEvent extends PropertyEvent {
  final int limit;

  const LoadTrendingPropertiesEvent({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

class LoadOffersEvent extends PropertyEvent {
  final int limit;

  const LoadOffersEvent({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

class SearchPropertiesEvent extends PropertyEvent {
  final String query;
  final PropertySearchFilters? filters;
  final int page;
  final int limit;

  const SearchPropertiesEvent({
    required this.query,
    this.filters,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [query, filters, page, limit];
}

// States
abstract class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object?> get props => [];
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertiesLoaded extends PropertyState {
  final List<PropertyEntity> properties;
  final bool hasMore;

  const PropertiesLoaded(this.properties, {this.hasMore = true});

  @override
  List<Object?> get props => [properties, hasMore];
}

class PropertyDetailsLoaded extends PropertyState {
  final PropertyEntity property;

  const PropertyDetailsLoaded(this.property);

  @override
  List<Object?> get props => [property];
}

class TrendingPropertiesLoaded extends PropertyState {
  final List<PropertyEntity> properties;

  const TrendingPropertiesLoaded(this.properties);

  @override
  List<Object?> get props => [properties];
}

class OffersLoaded extends PropertyState {
  final List<PropertyEntity> properties;

  const OffersLoaded(this.properties);

  @override
  List<Object?> get props => [properties];
}

class PropertyError extends PropertyState {
  final String message;

  const PropertyError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final GetPropertiesUseCase getPropertiesUseCase;
  final GetPropertyDetailsUseCase getPropertyDetailsUseCase;
  final GetTrendingPropertiesUseCase getTrendingPropertiesUseCase;
  final GetOffersUseCase getOffersUseCase;
  final SearchPropertiesUseCase searchPropertiesUseCase;

  PropertyBloc({
    required this.getPropertiesUseCase,
    required this.getPropertyDetailsUseCase,
    required this.getTrendingPropertiesUseCase,
    required this.getOffersUseCase,
    required this.searchPropertiesUseCase,
  }) : super(PropertyInitial()) {
    on<LoadPropertiesEvent>(_onLoadProperties);
    on<LoadPropertyDetailsEvent>(_onLoadPropertyDetails);
    on<LoadTrendingPropertiesEvent>(_onLoadTrendingProperties);
    on<LoadOffersEvent>(_onLoadOffers);
    on<SearchPropertiesEvent>(_onSearchProperties);
  }

  Future<void> _onLoadProperties(
    LoadPropertiesEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    final result = await getPropertiesUseCase(
      filters: event.filters,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(PropertyError(failure.message)),
      (properties) => emit(PropertiesLoaded(
        properties,
        hasMore: properties.length >= event.limit,
      )),
    );
  }

  Future<void> _onLoadPropertyDetails(
    LoadPropertyDetailsEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    final result = await getPropertyDetailsUseCase(event.propertyId);

    result.fold(
      (failure) => emit(PropertyError(failure.message)),
      (property) => emit(PropertyDetailsLoaded(property)),
    );
  }

  Future<void> _onLoadTrendingProperties(
    LoadTrendingPropertiesEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    final result = await getTrendingPropertiesUseCase(limit: event.limit);

    result.fold(
      (failure) => emit(PropertyError(failure.message)),
      (properties) => emit(TrendingPropertiesLoaded(properties)),
    );
  }

  Future<void> _onLoadOffers(
    LoadOffersEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    final result = await getOffersUseCase(limit: event.limit);

    result.fold(
      (failure) => emit(PropertyError(failure.message)),
      (properties) => emit(OffersLoaded(properties)),
    );
  }

  Future<void> _onSearchProperties(
    SearchPropertiesEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    final result = await searchPropertiesUseCase(
      query: event.query,
      filters: event.filters,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(PropertyError(failure.message)),
      (properties) => emit(PropertiesLoaded(
        properties,
        hasMore: properties.length >= event.limit,
      )),
    );
  }
}
