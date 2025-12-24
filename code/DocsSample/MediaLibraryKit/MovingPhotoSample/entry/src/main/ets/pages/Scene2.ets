// [Start Obtaining_Moving_Photo_Sample]
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';


@Entry({ routeName : 'Scene2' })
@Component
export struct Scene2 {

  @State statusMessage: string = '';

  build() {
    NavDestination() {
      Column({ space: 20 }) {

        Button('example')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(async () => {
            let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
            this.statusMessage = await example(phAccessHelper, context);
          })

        // [StartExclude Obtaining_Moving_Photo_Sample]
        if (this.statusMessage !== '') {

          Scroll() {
            Text(this.statusMessage)
              .fontSize(12)
              .width('90%')
              .padding(15)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
          }

          .width('100%')
          .layoutWeight(1)
          .margin({ top: 10 })
        }
        // [EndExclude Obtaining_Moving_Photo_Sample]
      }
      .width('100%')
      .height('100%')
    }
    .title('Get from Media Library')
  }
}
async function example(phAccessHelper: photoAccessHelper.PhotoAccessHelper, context: Context): Promise<string> {
  try {
    // Use Picker to select the URI of the moving photo.
    let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE;
    photoSelectOptions.maxSelectNumber = 9;
    let photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    let photoSelectResult = await photoViewPicker.select(photoSelectOptions);
    let uris = photoSelectResult.photoUris;

    let resultMessage = 'Selected ' + uris.length + ' moving photo(s)\n\n';

    for (let i = 0; i < uris.length; i++) {
      // Obtain the photo asset corresponding to the URI.
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uris[i]);
      let fetchOption: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates
      };
      let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = 
        await phAccessHelper.getAssets(fetchOption);
      let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();

      let movingPhotoUri = await new Promise<string>((resolve) => {
        // Obtain the moving photo object corresponding to the photo asset.
        photoAccessHelper.MediaAssetManager.requestMovingPhoto(context, photoAsset, {
          deliveryMode: photoAccessHelper.DeliveryMode.FAST_MODE
        }, {
          async onDataPrepared(movingPhoto: photoAccessHelper.MovingPhoto) {
            if (movingPhoto !== undefined) {
              // Customize the logic for processing the moving photo.
              console.info('request moving photo successfully, uri: ' + movingPhoto.getUri());
              resolve(movingPhoto.getUri());
            }
          }
        })
      });

      resultMessage += (i + 1) + '. request moving photo successfully, uri: ' + movingPhotoUri + '\n';
    }

    return resultMessage;
  } catch (err) {
    console.error(`request moving photo failed with error: ${err.code}, ${err.message}`);
    return `request moving photo failed with error: ${err.code}, ${err.message}`;
  }
}
// [End Obtaining_Moving_Photo_Sample]