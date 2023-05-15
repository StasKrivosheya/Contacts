import 'package:contacts/src/services/media_picker/i_media_picker.dart';
import 'package:image_picker/image_picker.dart';

class MediaPicker implements IMediaPicker {
  MediaPicker() {
    // TODO: probably inject it
    _imagePicker = ImagePicker();
  }

  late final ImagePicker _imagePicker;

  @override
  Future<String?> pickPhotoFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  @override
  Future<String?> takePhotoWithCamera() async {
    final takenFile = await _imagePicker.pickImage(source: ImageSource.camera);
    return takenFile?.path;
  }
}
