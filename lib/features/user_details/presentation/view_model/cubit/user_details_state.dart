part of 'user_details_cubit.dart';


abstract class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object?> get props => [];
}

// initial
final class UserDetailsInitial extends UserDetailsState {
  const UserDetailsInitial();
}

final class CopyTotalToClipboardSuccess extends UserDetailsState {
  final String total;
   CopyTotalToClipboardSuccess(this.total) {
    log("user_details_cubit   total = $total ");
  }

  @override
  List<Object?> get props => [total];
}

final class CopyTotalToClipboardFailure extends UserDetailsState {
  final String errorMesg;
   CopyTotalToClipboardFailure(this.errorMesg) {
    log("user_details_cubit   errorMesg = $errorMesg ");
  }

  @override
  List<Object?> get props => [errorMesg];
}

final class GetTotalMoneySuccess extends UserDetailsState {
  final List<double> total;
  const GetTotalMoneySuccess({required this.total});

  @override
  List<Object?> get props => [total];
}
