import { VideoScreenDirectionSwitchingComponent } from '../view/VideoScreenDirectionSwitching';

@Entry
@Component
struct Index {

  build() {
    RelativeContainer() {
      VideoScreenDirectionSwitchingComponent()
        .height('100%')
        .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}