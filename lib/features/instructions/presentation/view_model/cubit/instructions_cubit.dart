import 'package:bloc/bloc.dart';

part 'instructions_state.dart';

class InstructionsCubit extends Cubit<InstructionsState> {
  InstructionsCubit() : super(InstructionsInitial());
}
