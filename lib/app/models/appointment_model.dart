class Appointment {
  final int id;
  final String date;
  final String clinicName;
  final String serviceName;
  final String petName;
  final String amount;
  final String status;
  final int rating;
  final int clinicId;

  Appointment({
    required this.id,
    required this.date,
    required this.clinicName,
    required this.serviceName,
    required this.petName,
    required this.amount,
    required this.status,
    required this.clinicId,
    this.rating = 0,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      date: json['appointment_datetime'],
      clinicName: json['clinic']['name'],
      clinicId: json['clinic']['id'],
      serviceName: json['service']['name'],
      petName: json['pet']['name'],
      amount: json['total_amount'].toString(),
      status: json['status'],
      rating: json['stars'] ?? 0,
    );
  }
}
