import { PhotoModel } from '../../models/PhotoModel'
import { getThumbByUri } from '../../manager/loader/LoadUtil'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { EventUtil } from '../../common/EventUtil'
import { IntentionCode, KeyCode } from '@kit.InputKit'

@Component
export struct PickImageVideo {
  @ObjectLink
  photoModel: PhotoModel | undefined;
  @Require
  focusId: string = ''
  @Require
  eventClickBack?: () => void
  private defaultInFocus: boolean = true
  @State album: string | undefined = undefined

  aboutToAppear(): void {
    if (this.photoModel) {
      if (this.photoModel.photoType == photoAccessHelper.PhotoType.VIDEO) {
        getThumbByUri(getContext(), this.photoModel, 'videoImage' + this.focusId)
          .then((thumbUri) => {
            this.album = thumbUri;
            this.photoModel!.pickVideoPreview = thumbUri;
          })
      } else {
        this.album = this.photoModel.uri
      }
    }
  }

  build() {
    Image(this.album)
      .borderRadius("18lpx")
      .id(this.focusId)
      .focusable(true)
      .width('100%')
      .stateStyles({
        focused: {
          .border({
            color: Color.Transparent
          })
        }
      })
      .aspectRatio(1)
      .shadow({ radius: 1, color: Color.Gray })
      .defaultFocus(this.defaultInFocus)
      .autoResize(true)
      .onClick(() => {
        this.eventClickBack && this.eventClickBack();
      })
      .width('100%')
      .height('100%')
  }
}

