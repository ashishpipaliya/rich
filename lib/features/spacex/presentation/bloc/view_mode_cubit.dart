import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

enum SpaceXViewMode { list, grid }

@injectable
class ViewModeCubit extends Cubit<SpaceXViewMode> {
  ViewModeCubit() : super(SpaceXViewMode.list);

  void toggle() {
    emit(state == SpaceXViewMode.list ? SpaceXViewMode.grid : SpaceXViewMode.list);
  }
}
