part of 'widgets.dart';

ClipOval buildCircleImage(
        {double height, double width, String imagePath, File imageFile}) =>
    ClipOval(
      child: Image(
        height: height,
        width: width,
        fit: BoxFit.cover,
        image: (imagePath != "" && imagePath != null)
            ? NetworkImage(imagePath)
            : (imageFile != null)
                ? FileImage(imageFile)
                : AssetImage('assets/images/img_icon.jpg'),
      ),
    );
