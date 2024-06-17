import 'package:image_picker/image_picker.dart';

sealed class Event {}

class InitialState extends Event {}

class OnlyPhotoState extends Event {
  final XFile image;

  OnlyPhotoState(this.image);
}

class LoadingState extends Event {}

class SuccessState extends Event {
  final String result;

  SuccessState(this.result);
}

class ErrorState extends Event {
  final String error;

  ErrorState(this.error);
}
