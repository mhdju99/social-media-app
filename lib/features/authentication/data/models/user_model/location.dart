class Location {
	String? country;
	String? city;

	Location({this.country, this.city});

	factory Location.fromJson(Map<String, dynamic> json) => Location(
				country: json['country'] as String?,
				city: json['city'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'country': country,
				'city': city,
			};
}
