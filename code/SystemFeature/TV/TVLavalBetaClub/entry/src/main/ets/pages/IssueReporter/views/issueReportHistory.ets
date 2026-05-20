class IssueHistory {
  public title: string = ''
  public time: string = ''
  public content?: string = ''
}

@Component
export default struct issueReportHistory {
  @Prop issueHistory: IssueHistory[] = []

  build() {
    Column() {
      if (this.issueHistory?.length) {
        Column() {
          Text('操作历史')
            .fontSize('42lpx')
            .fontWeight(600)
            .margin({ left: '72lpx', bottom: '24lpx' })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .margin({ bottom: '24lpx' })
      }

      Column({ space: '24lpx' }) {
        ForEach(this.issueHistory, (item: IssueHistory, index: number) => {
          Column({ space: '12lpx' }) {
            Row({ space: '24lpx' }) {
              Column() {
                Column() {
                  Column() {
                  }
                  .width('12lpx')
                  .height('12lpx')
                  .border({ width: '3lpx', color: Color.Black, radius: '6lpx' })
                }
                .width('36lpx')
                .height('36lpx')
                .border({ width: '3lpx', color: Color.Black, radius: '18lpx' })
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)

              }

              Text(item.time)
                .fontSize('42lpx')
                .fontWeight(400)
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Row() {
              Text(item.title)
                .fontSize('42lpx')
                .fontWeight(600)
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .padding({ left: '60lpx' })

            Row() {
              Text(item.content)
                .fontSize('42lpx')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .padding({ left: '60lpx' })
          }
        })
      }
      .margin({ left: '36lpx', right: '36lpx' })
      .padding({ left: '48lpx', right: '48lpx', top: '84lpx', bottom: '66lpx' })
      .backgroundColor(Color.White)
      .borderRadius(10)
    }
    .margin({ top: '66lpx', bottom: '66lpx' })
  }
}