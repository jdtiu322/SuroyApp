class VehicleInformation1 {
  final String vehicleType;
  final String vehicleModel;
  final String hostName;
  final String numSeats;
  final String modelYear;
  final String plateNumber;
  final String imageUrl;

  VehicleInformation1({
    required this.vehicleType,
    required this.vehicleModel,
    required this.hostName,
    required this.numSeats,
    required this.modelYear,
    required this.plateNumber,
    required this.imageUrl,
  });
}

class VehicleInformation2 extends VehicleInformation1 {
  final String pickUpAddress;

  VehicleInformation2({
    required this.pickUpAddress,
    required String vehicleType,
    required String vehicleModel,
    required String hostName,
    required String numSeats,
    required String modelYear,
    required String plateNumber,
    required String imageUrl,
  }) : super(
          vehicleType: vehicleType,
          vehicleModel: vehicleModel,
          hostName: hostName,
          numSeats: numSeats,
          modelYear: modelYear,
          plateNumber: plateNumber,
          imageUrl: imageUrl,
        );
}

class VehicleInformation3 extends VehicleInformation2 {
  final String vehicleDescription;

  VehicleInformation3({
    required this.vehicleDescription,
    required String pickUpAddress,
    required String vehicleType,
    required String vehicleModel,
    required String hostName,
    required String numSeats,
    required String modelYear,
    required String plateNumber,
    required String imageUrl,
  }) : super(
          pickUpAddress: pickUpAddress,
          vehicleType: vehicleType,
          vehicleModel: vehicleModel,
          hostName: hostName,
          numSeats: numSeats,
          modelYear: modelYear,
          plateNumber: plateNumber,
          imageUrl: imageUrl,
        );
}

class FinalVehicleInfo extends VehicleInformation3 {
  final String rentPrice;

  FinalVehicleInfo({
    required this.rentPrice,
  required String vehicleDescription,
    required String pickUpAddress,
    required String vehicleType,
    required String vehicleModel,
    required String hostName,
    required String numSeats,
    required String modelYear,
    required String plateNumber,
    required String imageUrl,
  }) : super(
          vehicleDescription: vehicleDescription,
          pickUpAddress: pickUpAddress,
          vehicleType: vehicleType,
          vehicleModel: vehicleModel,
          hostName: hostName,
          numSeats: numSeats,
          modelYear: modelYear,
          plateNumber: plateNumber,
          imageUrl: imageUrl,
        );
}

class VehicleInformationWithDate extends FinalVehicleInfo {
  final DateTime startDate;
  final DateTime endDate;

  VehicleInformationWithDate({
    required this.startDate,
    required this.endDate,
    required String rentPrice,
    required String vehicleDescrition,
    required String pickUpAddress,
    required String vehicleType,
    required String vehicleModel,
    required String hostName,
    required String numSeats,
    required String modelYear,
    required String plateNumber,
    required String imageUrl,
  

  }) : super(
          rentPrice: rentPrice,
          vehicleDescription: vehicleDescrition,
          pickUpAddress: pickUpAddress,
          vehicleType: vehicleType,
          vehicleModel: vehicleModel,
          hostName: hostName,
          numSeats: numSeats,
          modelYear: modelYear,
          plateNumber: plateNumber,
          imageUrl: imageUrl,
        );
}
