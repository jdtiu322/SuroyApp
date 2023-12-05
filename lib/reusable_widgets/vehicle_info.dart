class VehicleInformation1 {
  final String vehicleType;
  final String vehicleModel;
  final String hostName;
  final String numSeats;
  final String modelYear;
  final String plateNumber;
  final String imageUrl;
  final String hostAge;
  final String hostMobileNumber;
  final String email;

  VehicleInformation1({
    required this.vehicleType,
    required this.vehicleModel,
    required this.hostName,
    required this.numSeats,
    required this.modelYear,
    required this.plateNumber,
    required this.imageUrl,
    required this.hostAge,
    required this.hostMobileNumber,
    required this.email,
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
    required String hostAge,
    required String hostMobileNumber,
    required String email,
  }) : super(
          vehicleType: vehicleType,
          vehicleModel: vehicleModel,
          hostName: hostName,
          numSeats: numSeats,
          modelYear: modelYear,
          plateNumber: plateNumber,
          imageUrl: imageUrl,
          hostAge: hostAge,
          hostMobileNumber: hostMobileNumber,
          email: email,
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
    required String hostAge,
    required String hostMobileNumber,
    required String email,
  }) : super(
            pickUpAddress: pickUpAddress,
            vehicleType: vehicleType,
            vehicleModel: vehicleModel,
            hostName: hostName,
            numSeats: numSeats,
            modelYear: modelYear,
            plateNumber: plateNumber,
            imageUrl: imageUrl,
            hostAge: hostAge,
            hostMobileNumber: hostMobileNumber,
            email: email);
}

class FinalVehicleInfo extends VehicleInformation3 {
  final String rentPrice;
  final bool isAvailable;

  FinalVehicleInfo({
    required this.isAvailable,
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
    required String hostAge,
    required String hostMobileNumber,
    required String email,
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
            hostAge: hostAge,
            hostMobileNumber: hostMobileNumber,
            email: email);
}

class VehicleInformationWithDate extends FinalVehicleInfo {
  final DateTime startDate;
  final DateTime endDate;

  VehicleInformationWithDate({
    required this.startDate,
    required this.endDate,
    required bool isAvailable,
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
    required String hostAge,
    required String hostMobileNumber,
    required String email,
  }) : super(
            isAvailable: isAvailable,
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
            hostAge: hostAge,
            hostMobileNumber: hostMobileNumber,
            email: email);
}

class BookingInfo {
  final DateTime startDate;
  final DateTime endDate;
  final String hostName;
  final String pickUpAddress;
  final String plateNumber;
  final String transactionAmount;
  final String vehicleModel;
  final String vehicleType;
  final String modelYear;
  final String imageUrl;
  final String hostAge;
  final String hostMobileNumber;
  final String email;

  BookingInfo({
    required this.startDate,
    required this.endDate,
    required this.hostName,
    required this.pickUpAddress,
    required this.plateNumber,
    required this.transactionAmount,
    required this.vehicleModel,
    required this.vehicleType,
    required this.modelYear,
    required this.imageUrl,
    required this.hostAge,
    required this.hostMobileNumber,
    required this.email,
  });
}

class RenterStatus extends BookingInfo {
  final String renterID;
  final String currentAddress;

  RenterStatus({
    required this.renterID,
    required this.currentAddress,
    required DateTime startDate,
    required DateTime endDate,
    required String hostName,
    required String pickUpAddress,
    required String plateNumber,
    required String transactionAmount,
    required String vehicleModel,
    required String vehicleType,
    required String modelYear,
    required String imageUrl,
    required String hostAge,
    required String hostMobileNumber,
    required String email,
  }) : super(
    startDate: startDate, 
  endDate: endDate,
  hostName: hostName,
  pickUpAddress: pickUpAddress,
  plateNumber: plateNumber,
  transactionAmount: transactionAmount,
  vehicleModel: vehicleModel,
  vehicleType: vehicleType,
  modelYear: modelYear,
  imageUrl: imageUrl,
  hostAge: hostAge,
  hostMobileNumber:hostMobileNumber, 
  email: email);
}
