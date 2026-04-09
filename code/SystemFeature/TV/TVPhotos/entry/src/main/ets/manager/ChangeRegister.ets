import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';


let context: Context = getContext(this) as common.UIAbilityContext

export async function createRegister(onRefresh: () => void) {
  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  let onCallback = (changeData: photoAccessHelper.ChangeData) => {
    console.info('onCallback successfully, changData: ' + JSON.stringify(changeData));
    onRefresh()
  }
  phAccessHelper.registerChange(photoAccessHelper.DefaultChangeUri.DEFAULT_PHOTO_URI, true, onCallback);
}