import {Scene1} from './Scene1';
import {Scene2} from './Scene2';
import {Scene3} from './Scene3';
import {Scene4} from './Scene4';

class DividerTmp {
  strokeWidth: Length = 1
  startMargin: Length = 60
  endMargin: Length = 10
  color: ResourceColor = '#ffe9f0f0'

  constructor(strokeWidth: Length, startMargin: Length, endMargin: Length, color: ResourceColor) {
    this.strokeWidth = strokeWidth
    this.startMargin = startMargin
    this.endMargin = endMargin
    this.color = color
  }
}

@Entry({ routeName : 'Index' })
@Component
struct Index {
  @Provide('NavPathStack') pageInfos: NavPathStack = new NavPathStack()
  @State egDivider: DividerTmp = new DividerTmp(1, 60, 10, '#ffe9f0f0')

  @Builder
  PagesMap(name: string) {
    if (name == 'Scene1') {
      Scene1()
    } else if (name == 'Scene2') {
      Scene2()
    } else if (name == 'Scene3') {
      Scene3()
    } else if (name == 'Scene4') {
      Scene4()
    }
  }

  build() {
    Column({ space: 15 }) {

      Navigation(this.pageInfos) {
        List({ space: 12 }) {
          ListItem() {
            Text($r('app.string.sample_label'))
              .fontSize(18)
          }
          ListItem() {
            Text($r('app.string.saving_file_desc'))
              .fontSize(20)
          }
          ListItem() {
            Button($r('app.string.saving_file_desc'))
              .width('80%')
              .onClick(() => {
                this.pageInfos.pushPathByName('Scene1', '');
              })
          }
          ListItem() {
            Text($r('app.string.streaming_desc'))
              .fontSize(20)
          }
          ListItem() {
            Button($r('app.string.streaming_desc'),{ type: ButtonType.Capsule, stateEffect: true })
              .width('80%')
              .onClick(() => {
                this.pageInfos.pushPathByName('Scene2', '');
              })
          }
          ListItem() {
            Button($r('app.string.streaming_surface_mode_desc'))
              .width('80%')
              .onClick(() => {
                this.pageInfos.pushPathByName('Scene3', '');
              })
          }
        }
        .width("100%")
        .margin({ top: 12 })
        .alignListItem(ListItemAlign.Center)
        .divider(this.egDivider)

      }
      .mode(NavigationMode.Stack)
      .title($r('app.string.sample_label'))
      .titleMode(NavigationTitleMode.Full)
      .navDestination(this.PagesMap)

    }
    .height('100%')
  }
}
