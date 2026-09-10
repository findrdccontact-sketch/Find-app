class FilterCriteria {
  final String? city;
  final String? commune;
  final String? quartier;
  final double? minPrice;
  final double? maxPrice;
  final String? propertyType;
  final int? minBedrooms;
  final bool availableOnly;

  FilterCriteria({
    this.city,
    this.commune,
    this.quartier,
    this.minPrice,
    this.maxPrice,
    this.propertyType,
    this.minBedrooms,
    this.availableOnly = true,
  });

  bool get isEmpty {
    return (city == null || city!.isEmpty) &&
        (commune == null || commune!.isEmpty) &&
        (quartier == null || quartier!.isEmpty) &&
        minPrice == null &&
        maxPrice == null &&
        (propertyType == null || propertyType!.isEmpty) &&
        minBedrooms == null &&
        availableOnly == true;
  }

  FilterCriteria copyWith({
    String? city,
    String? commune,
    String? quartier,
    double? minPrice,
    double? maxPrice,
    String? propertyType,
    int? minBedrooms,
    bool? availableOnly,
  }) {
    return FilterCriteria(
      city: city ?? this.city,
      commune: commune ?? this.commune,
      quartier: quartier ?? this.quartier,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      propertyType: propertyType ?? this.propertyType,
      minBedrooms: minBedrooms ?? this.minBedrooms,
      availableOnly: availableOnly ?? this.availableOnly,
    );
  }

  FilterCriteria clear() {
    return FilterCriteria();
  }
}
