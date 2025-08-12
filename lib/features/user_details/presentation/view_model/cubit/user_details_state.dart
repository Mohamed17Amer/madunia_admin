part of 'user_details_cubit.dart';

 class UserDetailsState {}

// initial
final class UserDetailsInitial extends UserDetailsState {}

final class CopyTotalToClipboardSuccess extends UserDetailsState {
  final String total;
  CopyTotalToClipboardSuccess(this.total) {
    log("user_details_cubit   total = $total ");
  }
}


final class CopyTotalToClipboardFailure extends UserDetailsState {
  final  String errorMesg;
  CopyTotalToClipboardFailure(this.errorMesg)
     {
      log ("user_details_cubit   errorMesg = $errorMesg ");
    }

    

}



final class GetTotalMoneySuccess extends UserDetailsState{
final List<double> total;
GetTotalMoneySuccess({required this.total});


}
