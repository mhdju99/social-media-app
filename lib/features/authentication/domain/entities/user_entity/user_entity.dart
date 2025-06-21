import 'package:equatable/equatable.dart';

import 'location.dart';

class UserEntity extends Equatable {
	final Location? location;
	final String? id;
	final List<dynamic>? followers;
	final List<dynamic>? following;
	final bool? certifiedDoctor;
	final String? firstName;
	final String? lastName;
	final DateTime? birthDate;
	final String? email;
	final List<dynamic>? preferredTopics;


	const UserEntity({
		this.location, 
		this.id, 
		this.followers, 
		this.following, 
		this.certifiedDoctor, 
		this.firstName, 
		this.lastName, 
		this.birthDate, 
		this.email, 
		this.preferredTopics, 
	
	});

	
	@override
	List<Object?> get props {
		return [
				location,
				id,
				followers,
				following,
				certifiedDoctor,
				firstName,
				lastName,
				birthDate,
				email,
				preferredTopics,
		
		];
	}
}
