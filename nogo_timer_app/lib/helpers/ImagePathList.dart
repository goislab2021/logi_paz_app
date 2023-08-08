import 'dart:math' as math;

class ImagePathList {
  final int _numOfImage = imagePathMap.length;
  static final Map<int,String> imagePathMap = {
    0:"assets/images/stamps/1_stamp_aka.png",
    1:"assets/images/stamps/1_hana_01.png",
    2:"assets/images/stamps/1_hana_02.png",
    3:"assets/images/stamps/1_hana_03.png",
    4:"assets/images/stamps/1_sun.png",
    5:"assets/images/stamps/1_moon.png",
    6:"assets/images/stamps/1_hana_11.png",
    7:"assets/images/stamps/1_hana_12.png",
    8:"assets/images/stamps/1_hana_13.png",
    9:"assets/images/stamps/1_hana_14.png",
    10:"assets/images/stamps/1_hana_15.png",
    11:"assets/images/stamps/1_gift_11.png",
    12:"assets/images/stamps/1_gift_12.png",
    13:"assets/images/stamps/1_gift_13.png",
    14:"assets/images/stamps/1_gift_14.png",
    15:"assets/images/stamps/1_cupcake_11.png",
    16:"assets/images/stamps/1_cupcake_12.png",
    17:"assets/images/stamps/1_cupcake_13.png",
    18:"assets/images/stamps/1_cupcake_14.png",
    19:"assets/images/stamps/1_cupcake_15.png",
    20:"assets/images/stamps/1_cupcake_16.png",
    21:"assets/images/stamps/1_fruit_11.png",
    22:"assets/images/stamps/1_fruit_12.png",
    23:"assets/images/stamps/1_fruit_13.png",
    24:"assets/images/stamps/1_fruit_14.png",
    25:"assets/images/stamps/1_fruit_15.png",
    26:"assets/images/stamps/1_fruit_16.png",
    27:"assets/images/stamps/1_vegetable_01.png",
    28:"assets/images/stamps/1_vegetable_02.png",
    29:"assets/images/stamps/1_vegetable_03.png",
    30:"assets/images/stamps/1_vegetable_04.png",
    31:"assets/images/stamps/1_sweets_01.png",
    32:"assets/images/stamps/1_sweets_02.png",
    33:"assets/images/stamps/1_sweets_03.png",
    34:"assets/images/stamps/1_sweets_04.png",
    35:"assets/images/stamps/1_sweets_05.png",
    36:"assets/images/stamps/1_sweets_06.png",
    37:"assets/images/stamps/1_sweets_07.png",
    38:"assets/images/stamps/1_cars_01.png",
    39:"assets/images/stamps/1_cars_02.png",
    40:"assets/images/stamps/1_cars_03.png",
    41:"assets/images/stamps/1_cars_04.png",
    42:"assets/images/stamps/1_cars_05.png",
    43:"assets/images/stamps/1_cars_06.png",
    44:"assets/images/stamps/1_bird_01.png",
    45:"assets/images/stamps/1_bird_02.png",
    46:"assets/images/stamps/1_bird_03.png",
    47:"assets/images/stamps/1_bird_04.png",
    48:"assets/images/stamps/1_bird_05.png",
    49:"assets/images/stamps/1_bird_06.png",
  };

  String? getImagePath(){
    var random = math.Random();
    int imgPathNum = random.nextInt(_numOfImage);
    String? imgPath = imagePathMap[imgPathNum];
    print('_numOfImage:$_numOfImage');
    print('imgPathNum:$imgPathNum');
    return imgPath;
  }

}

class ImagePathList2 {
  final int _numOfImage = imagePathMap.length;
  static final Map<int,String> imagePathMap = {
    0:"assets/images/stamps/2_stamp_aka.png",
    1:"assets/images/stamps/2_cloud_and_sun.png",
    2:"assets/images/stamps/2_cloud_and_moon.png",
  };

  String? getImagePath(){
    var random = math.Random();
    int imgPathNum = random.nextInt(_numOfImage);

    String? imgPath = imagePathMap[imgPathNum];
    return imgPath;
  }
}

class ImagePathList3 {
  final int _numOfImage = imagePathMap.length;
  static final Map<int,String> imagePathMap = {
    0:"assets/images/stamps/3_stamp_aka.png",
    1:"assets/images/stamps/3_cloud.png",
    2:"assets/images/stamps/3_rain.png",
  };

  String? getImagePath(){
    var random = math.Random();
    int imgPathNum = random.nextInt(_numOfImage);
    String? imgPath = imagePathMap[imgPathNum];
    return imgPath;
  }

}


