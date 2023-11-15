import avSession from '@ohos.multimedia.avsession';

@Component
export struct SongItem {
  @State index: number = -1;
  @State item: avSession.AVMediaDescription = null;
  @Link currentPlayInfo: avSession.AVMediaDescription;

  build(){
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }){
        Text('' + (this.index + 1)).fontSize(12)
          .fontColor(this.currentPlayInfo.mediaId === this.item.mediaId ? '#0A59F7' : Color.Black)
          .opacity(0.3)
        Flex({
          direction: FlexDirection.Row,
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center
        }){
          Text(this.item.title)
            .fontSize(14)
            .opacity(1)
            .maxLines(1)
            .fontWeight(FontWeight.Medium)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontColor(this.currentPlayInfo.mediaId === this.item.mediaId ? '#0A59F7' : Color.Black)
          Text(this.item.artist)
            .margin({ top: 8 })
            .fontSize(12)
            .opacity(1)
            .fontWeight(FontWeight.Regular)
            .fontColor(this.currentPlayInfo.mediaId === this.item.mediaId ? '#0A59F7' : Color.Black)
        }.margin({ left: 12 })
      }
      .margin({ left: 0 })

      Image($r('app.media.icon'))
        .size({ width: '24vp', height: '24vp' })
        .fillColor('#0A59F7')
        .backgroundColor(Color.Transparent)
        .margin({ left: 4 })
        .opacity(1)
        .visibility(this.currentPlayInfo.mediaId === this.item.mediaId ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
    .height(56)
    .padding({ right: 24 })
  }
}