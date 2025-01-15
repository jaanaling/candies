enum IconProvider {
  splash(imageName: 'splash.png'),
  logo(imageName: 'logo.png'),
  
  // Add your lowercase image names here
  arrow(imageName: 'arrow.png'),
  back(imageName: 'back.png'),
  background(imageName: 'background.png'),
  bomb(imageName: 'bombr.png'),
  bombres(imageName: 'bombres.png'),
  common(imageName: 'common.png'),
  filtr(imageName: 'filtr.png'),
  heart(imageName: 'heart.png'),
  lock(imageName: 'lock.png'),
  share(imageName: 'share.png'),
  remove(imageName: 'remove.png'),
  shop(imageName: 'shop.png'),
  time(imageName: 'time.png'),

  unknown(imageName: '');

  const IconProvider({
    required this.imageName,
  });

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name';
}
