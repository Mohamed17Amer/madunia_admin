import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial());


void copyTotalToClipboard(String? total){
  final String total = "total";
  copyToClipboard(text: total);
  emit(CopyTotalToClipboardSuccess(total));
}
 
}
