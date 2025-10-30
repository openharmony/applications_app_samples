import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller();
  private arr: number[] =
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25];

  build() {
    Column() {
      Row() {
        Scroll() {
          Column() {
            Grid(this.scroller) {
              ForEach(this.arr, (item: number) => {
                GridItem() {
                  Text('ListItem' + item)
                    .width('100%')
                    .height('100%')
                    .borderRadius(15)
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(Color.White)
                }.width('100%').height(100)
              }, (item: number) => item.toString())
            }

          }.width('90%').backgroundColor(0xDCDCDC)
        }
        .scrollBar(BarState.On)
        .edgeEffect(EdgeEffect.Spring)
        .onWillStartDragging(() => {
          console.log('callback1 onWillStartDragging');
        })
        .onDidStopDragging((willFling: boolean) => {
          console.log('callback2 onDidStopDragging willFling = ' + willFling);
        })
        .onWillStopDragging((velocity: number) => {
          console.log('callback onWillStopDragging velocity = ' + velocity);
        })
        .onWillStartFling(() => {
          console.log('callback3 onWillStartFling');
        })
        .onDidStopFling(() => {
          console.log('callback4 onDidStopFling');
        })
        .backgroundColor(Color.Yellow)
        .height('90%')

        ScrollBar({ scroller: this.scroller, state: BarState.On }) {
          Text()
            .width(20)
            .height(100)
            .borderRadius(10)
            .backgroundColor('#C0C0C0')
        }
        .width(20)
      }
      .height('90%')

      Button('滑动').onClick((event: ClickEvent) => {
        this.scroller.scrollTo({
          xOffset: this.scroller.currentOffset().xOffset,
          yOffset: this.scroller.currentOffset().yOffset + 100,
          animation: { duration: 500 }
        });
      })

      Button('翻页').onClick(() => {
        router.pushUrl({
          url: 'pages/grid/ScrollSnap/GridIndex2',
          params: {
            data1: 'message'
          }
        });
      })
    }

  }
}