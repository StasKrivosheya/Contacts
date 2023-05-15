abstract class IMediaPicker {
  Future<String?> pickPhotoFromGallery();

  Future<String?> takePhotoWithCamera();
}
