/*
* Copyright (c) 2024-2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import resourceManager from '@ohos.resourceManager'
import fileIo from '@ohos.file.fs';
import msliteNapi from 'libentry.so'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@ohos.base';
import image from '@ohos.multimedia.image';
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'MindSporeLite';
const PERMISSIONS: Permissions[] = ['ohos.permission.READ_IMAGEVIDEO'];

@Entry
@Component
struct Index {
  @State message: string = 'MindSporeLite C Demo';
  @State modelName: string = 'mobilenetv2.ms';
  @State modelInputHeight: number = 224;
  @State modelInputWidth: number = 224;
  @State uris: Array<string> = [];
  @State max: number = 0;
  @State maxIndex: number = 0;
  @State maxArray: Array<number> = [];
  @State maxIndexArray: Array<number> = [];
  @State labelsNameMap: string[] = [
    'Herd', 'Safari', 'Bangle', 'Cushion', 'Countertop',
    'Prom', 'Branch', 'Sports', 'Sky', 'Community',
    'Wheel', 'Cola', 'Tuxedo', 'Flowerpot', 'Team',
    'Computer', 'Unicycle', 'Brig', 'Aerospace engineering', 'Scuba diving',
    'Goggles', 'Fruit', 'Badminton', 'Horse', 'Sunglasses',
    'Fun', 'Prairie', 'Poster', 'Flag', 'Speedboat',
    'Eyelash', 'Veil', 'Mobile phone', 'Wheelbarrow', 'Saucer',
    'Leather', 'Drawer', 'Paper', 'Pier', 'Waterfowl',
    'Tights', 'Rickshaw', 'Vegetable', 'Handrail', 'Ice',
    'Metal', 'Flower', 'Wing', 'Silverware', 'Event',
    'Skyline', 'Money', 'Comics', 'Handbag', 'Porcelain',
    'Rodeo', 'Curtain', 'Tile', 'Human mouth', 'Army',
    'Menu', 'Boat', 'Snowboarding', 'Cairn terrier', 'Net',
    'Pasteles', 'Cup', 'Rugby', 'Pho', 'Cap',
    'Human hair', 'Surfing', 'Loveseat', 'Museum', 'Shipwreck',
    'Trunk (Tree)', 'Plush', 'Monochrome', 'Volcano', 'Rock',
    'Pillow', 'Presentation', 'Nebula', 'Subwoofer', 'Lake',
    'Sledding', 'Bangs', 'Tablecloth', 'Necklace', 'Swimwear',
    'Standing', 'Jeans', 'Carnival', 'Softball', 'Centrepiece',
    'Skateboarder', 'Cake', 'Dragon', 'Aurora', 'Skiing',
    'Bathroom', 'Dog', 'Needlework', 'Umbrella', 'Church',
    'Fire', 'Piano', 'Denim', 'Bridle', 'Cabinetry',
    'Lipstick', 'Ring', 'Television', 'Roller', 'Seal',
    'Concert', 'Product', 'News', 'Fast food', 'Horn (Animal)',
    'Tattoo', 'Bird', 'Bridegroom', 'Love', 'Helmet',
    'Dinosaur', 'Icing', 'Miniature', 'Tire', 'Toy',
    'Icicle', 'Jacket', 'Coffee', 'Mosque', 'Rowing',
    'Wetsuit', 'Camping', 'Underwater', 'Christmas', 'Gelato',
    'Whiteboard', 'Field', 'Ragdoll', 'Construction', 'Lampshade',
    'Palace', 'Meal', 'Factory', 'Cage', 'Clipper (Boat)',
    'Gymnastics', 'Turtle', 'Human foot', 'Marriage', 'Web page',
    'Human beard', 'Fog', 'Wool', 'Cappuccino', 'Lighthouse',
    'Lego', 'Sparkler', 'Sari', 'Model', 'Temple',
    'Beanie', 'Building', 'Waterfall', 'Penguin', 'Cave',
    'Stadium', 'Smile', 'Human hand', 'Park', 'Desk',
    'Shetland sheepdog', 'Bar', 'Eating', 'Neon', 'Dalmatian',
    'Crocodile', 'Wakeboarding', 'Longboard', 'Road', 'Race',
    'Kitchen', 'Odometer', 'Cliff', 'Fiction', 'School',
    'Interaction', 'Bullfighting', 'Boxer', 'Gown', 'Aquarium',
    'Superhero', 'Pie', 'Asphalt', 'Surfboard', 'Cheeseburger',
    'Screenshot', 'Supper', 'Laugh', 'Lunch', 'Party ',
    'Glacier', 'Bench', 'Grandparent', 'Sink', 'Pomacentridae',
    'Blazer', 'Brick', 'Space', 'Backpacking', 'Stuffed toy',
    'Sushi', 'Glitter', 'Bonfire', 'Castle', 'Marathon',
    'Pizza', 'Beach', 'Human ear', 'Racing', 'Sitting',
    'Iceberg', 'Shelf', 'Vehicle', 'Pop music', 'Playground',
    'Clown', 'Car', 'Rein', 'Fur', 'Musician',
    'Casino', 'Baby', 'Alcohol', 'Strap', 'Reef',
    'Balloon', 'Outerwear', 'Cathedral', 'Competition', 'Joker',
    'Blackboard', 'Bunk bed', 'Bear', 'Moon', 'Archery',
    'Polo', 'River', 'Fishing', 'Ferris wheel', 'Mortarboard',
    'Bracelet', 'Flesh', 'Statue', 'Farm', 'Desert',
    'Chain', 'Aircraft', 'Textile', 'Hot dog', 'Knitting',
    'Singer', 'Juice', 'Circus', 'Chair', 'Musical instrument',
    'Room', 'Crochet', 'Sailboat', 'Newspaper', 'Santa claus',
    'Swamp', 'Skyscraper', 'Skin', 'Rocket', 'Aviation',
    'Airliner', 'Garden', 'Ruins', 'Storm', 'Glasses',
    'Balance', 'Nail (Body part)', 'Rainbow', 'Soil ', 'Vacation ',
    'Moustache', 'Doily', 'Food', 'Bride ', 'Cattle',
    'Pocket', 'Infrastructure', 'Train', 'Gerbil', 'Fireworks',
    'Pet', 'Dam', 'Crew', 'Couch', 'Bathing',
    'Quilting', 'Motorcycle', 'Butterfly', 'Sled', 'Watercolor paint',
    'Rafting', 'Monument', 'Lightning', 'Sunset', 'Bumper',
    'Shoe', 'Waterskiing', 'Sneakers', 'Tower', 'Insect',
    'Pool', 'Placemat', 'Airplane', 'Plant', 'Jungle',
    'Armrest', 'Duck', 'Dress', 'Tableware', 'Petal',
    'Bus', 'Hanukkah', 'Forest', 'Hat', 'Barn',
    'Tubing', 'Snorkeling', 'Cool', 'Cookware and bakeware', 'Cycling',
    'Swing (Seat)', 'Muscle', 'Cat', 'Skateboard', 'Star',
    'Toe', 'Junk', 'Bicycle', 'Bedroom', 'Person',
    'Sand', 'Canyon', 'Tie', 'Twig', 'Sphynx',
    'Supervillain', 'Nightclub', 'Ranch', 'Pattern', 'Shorts',
    'Himalayan', 'Wall', 'Leggings', 'Windsurfing', 'Deejay',
    'Dance', 'Van', 'Bento', 'Sleep', 'Wine',
    'Picnic', 'Leisure', 'Dune', 'Crowd', 'Kayak',
    'Ballroom', 'Selfie', 'Graduation', 'Frigate', 'Mountain',
    'Dude', 'Windshield', 'Skiff', 'Class', 'Scarf',
    'Bull', 'Soccer', 'Bag', 'Basset hound', 'Tractor',
    'Swimming', 'Running', 'Track', 'Helicopter', 'Pitch',
    'Clock', 'Song', 'Jersey', 'Stairs', 'Flap',
    'Jewellery', 'Bridge', 'Cuisine', 'Bread', 'Caving',
    'Shell', 'Wreath', 'Roof', 'Cookie', 'Canoe'
  ];

  aboutToAppear() {
    abilityAccessCtrl.createAtManager().requestPermissionsFromUser(getContext(this), PERMISSIONS).then((data) => {
      if (data.authResults[0] == 0) {
        hilog.info(0xFF00, TAG, '%{public}s', 'request permission success');
      } else {
        hilog.info(0xFF00, TAG, '%{public}s', 'user rejected');
      }
    }).catch((err: BusinessError) => {
      hilog.error(0xFF00, TAG, '%{public}s',
        `request permission failed, error message: ${(err as BusinessError).message}`);
    });
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold);
        //图片显示
        Image(this.uris[0]).width(320).height(540).margin(15)
        //显示分类最大值
        if (this.max) {
          Text(this.labelsNameMap[this.maxIndexArray[0]] +
            ': ' +
          (this.maxArray[0] / 100).toString() +
            '%\n' +
          this.labelsNameMap[this.maxIndexArray[1]] +
            ': ' +
          (this.maxArray[1] / 100).toString() +
            '%\n' +
          this.labelsNameMap[this.maxIndexArray[2]] +
            ': ' +
          (this.maxArray[2] / 100).toString() +
            '%\n' +
          this.labelsNameMap[this.maxIndexArray[3]] +
            ': ' +
          (this.maxArray[3] / 100).toString() +
            '%').focusable(true).fontSize(20)
        }
        Button() {
          Text('photo')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%')
        .onClick(() => {
          let resMgr: resourceManager.ResourceManager = getContext().getApplicationContext().resourceManager;

          //获取相册图片
          //1.创建图片-视频类型文件选择选项实例
          let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();

          //2.选择媒体文件类型和选择媒体文件的最大数目
          PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 过滤选择媒体文件类型为IMAGE
          PhotoSelectOptions.maxSelectNumber = 1; // 选择媒体文件的最大数目

          //3.创建图库选择器实例，调用select()接口拉起图库界面进行文件选择。文件选择成功后，返回 photoSelectResult 结果集。
          let photoPicker = new photoAccessHelper.PhotoViewPicker();
          photoPicker.select(PhotoSelectOptions,
            async (err: BusinessError, photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
              if (err) {
                console.error('MS_LITE_ERR: PhotoViewPicker.select failed with err: ' + JSON.stringify(err));
                return;
              }
              console.info('MS_LITE_LOG: PhotoViewPicker.select successfully, photoSelectResult uri: ' +
              JSON.stringify(photoSelectResult));
              this.uris = photoSelectResult.photoUris;
              console.info('MS_LITE_LOG: uri: ' + this.uris);
              try {
                // 预处理图片数据
                // 1.使用fs.openSync接口，通过uri打开这个文件得到fd
                let file = fileIo.openSync(this.uris[0], fileIo.OpenMode.READ_ONLY);
                console.info('MS_LITE_LOG: file fd: ' + file.fd);

                // 2.通过fd使用fs.readSync接口读取这个文件内的数据
                let inputBuffer = new ArrayBuffer(4096000);
                let readLen = fileIo.readSync(file.fd, inputBuffer);
                console.info('MS_LITE_LOG: readSync data to file succeed and inputBuffer size is:' + readLen);

                // 3.通过 PixelMap 预处理
                let imageSource = image.createImageSource(file.fd);
                let pixelMap = await imageSource.createPixelMap({ editable: true });
                let info = await pixelMap.getImageInfo();
                console.info('MS_LITE_LOG: info.width = ' + info.size.width);
                console.info('MS_LITE_LOG: info.height = ' + info.size.height);

                // 4. 获取图片buffer数据readBuffer，并进行处理
                pixelMap.scale(256.0 / info.size.width, 256.0 / info.size.height).then(() => {
                  pixelMap.crop({
                    x: 16,
                    y: 16,
                    size: { height: this.modelInputHeight, width: this.modelInputWidth }
                  })
                    .then(async () => {
                      let info = await pixelMap.getImageInfo();
                      console.info('MS_LITE_LOG: crop info.width = ' + info.size.width);
                      console.info('MS_LITE_LOG: crop info.height = ' + info.size.height);
                      // 需要创建的像素buffer大小
                      let readBuffer = new ArrayBuffer(this.modelInputHeight * this.modelInputWidth * 4);
                      await pixelMap.readPixelsToBuffer(readBuffer);
                      console.info('MS_LITE_LOG: Succeeded in reading image pixel data, buffer: ' + readBuffer.byteLength);

                      // 处理readBuffer
                      const imageArr =
                        new Uint8Array(readBuffer.slice(0, this.modelInputHeight * this.modelInputWidth * 4));
                      console.info('MS_LITE_LOG: imageArr length: ' + imageArr.length);
                      let means = [0.485, 0.456, 0.406];
                      let stds = [0.229, 0.224, 0.225];
                      let float32View = new Float32Array(this.modelInputHeight * this.modelInputWidth * 3);
                      let index = 0;
                      for (let i = 0; i < imageArr.length; i++) {
                        if ((i + 1) % 4 == 0) {
                          float32View[index] = (imageArr[i - 3] / 255.0 - means[0]) / stds[0]; // B
                          float32View[index+1] = (imageArr[i - 2] / 255.0 - means[1]) / stds[1]; // G
                          float32View[index+2] = (imageArr[i - 1] / 255.0 - means[2]) / stds[2]; // R
                          index += 3;
                        }
                      }
                      console.info('MS_LITE_LOG: float32View length: ' + float32View.length);
                      let printStr = 'float32View data:';
                      for (let i = 0; i < 20; i++) {
                        printStr += ' ' + float32View[i];
                      }
                      console.info('MS_LITE_LOG: float32View data: ' + printStr);

                      // 调用c++的runDemo
                      console.info('MS_LITE_LOG: *** Start MSLite Demo ***');
                      let output: Array<number> = msliteNapi.runDemo(Array.from(float32View), resMgr);
                      console.warn('MS_LITE_WARN: output length = ', output.length, ';value = ', output.slice(0, 20));

                      // 取分类最大值top5
                      this.max = 0;
                      this.maxIndex = 0;
                      this.maxArray = [];
                      this.maxIndexArray = [];
                      let newArray = output.filter(value => value !== this.max);
                      for (let n = 0; n < 5; n++) {
                        this.max = output[0];
                        this.maxIndex = 0;
                        // 取最大值
                        for (let m = 0; m < newArray.length; m++) {
                          if (newArray[m] > this.max) {
                            this.max = newArray[m];
                            this.maxIndex = m;
                          }
                        }
                        this.maxArray.push(Math.round(this.max * 10000));
                        this.maxIndexArray.push(this.maxIndex);
                        // filter函数 数组过滤函数
                        newArray = newArray.filter(value => value !== this.max);
                      }
                      console.info('MS_LITE_LOG: max:' + this.maxArray);
                      console.info('MS_LITE_LOG: maxIndex:' + this.maxIndexArray);
                      console.info('MS_LITE_LOG: *** Finished MSLite Demo ***');
                    })
                })
                // 5.关闭文件
                fileIo.closeSync(file);
              } catch (err) {
                console.error('MS_LITE_LOG: uri: open file fd failed.' + err);
              }
            })
        })
      }.width('100%')
    }
    .height('100%')
  }
}