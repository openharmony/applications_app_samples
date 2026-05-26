import cert from '@ohos.security.cert';

class P {
  public id?: string;
  public text?: string;
  public amount?: string;
  public time?: string;
  public bedname?: string;
  public patientname?: string;
  public sex?: string;
  public age?: string;
  public frequency?: string;
  public type?: string;
}

@Component
export struct Drug {
  private name = '张晓彤';
  private arrList: P[] = [
    {
      id: '88342333',
      text: '10%葡萄碳酸钙注射液',
      amount: '20ml',
      time: '2024-05-09 9:00',
      bedname: '12床',
      patientname: this.name,
      sex: '女',
      age: '32岁',
      frequency: 'q8h',
      type: '静滴'
    },
    {
      id: '88342332',
      text: '复方二氧醋酸异丙胺注射液',
      amount: '20ml',
      time: '2024-05-09 9:00',
      bedname: '12床',
      patientname: this.name,
      sex: '女',
      age: '32岁',
      frequency: 'q8h',
      type: '静滴'
    },
    {
      id: '88342335',
      text: '复方甘草酸干注射液',
      amount: '20ml',
      time: '2024-05-09 9:00',
      bedname: '12床',
      patientname: this.name,
      sex: '女',
      age: '32岁',
      frequency: 'q8h',
      type: '静滴'
    },
    {
      id: '88342334',
      text: '硫普罗宁注射液',
      amount: '20ml',
      time: '2024-05-09 9:00',
      bedname: '12床',
      patientname: this.name,
      sex: '女',
      age: '32岁',
      frequency: 'q8h',
      type: '静滴'
    },
  ];
  @State currentIndex: number = 0;
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        //header
        Row() {
          Image($r('app.media.nurse_back_gray')).width(20).height(20).position({ x: 10, y: 10 })
            .onClick(() => {
              this.pageInfos.popToName('MedicalAdvice');
            });
        }
        .backgroundColor(Color.White)
        .width('100%')
        .height(30)
        .justifyContent(FlexAlign.Center)
        .shadow({
          radius: 20,
          color: Color.Gray,
          offsetX: 2,
          offsetY: 2
        });

        Stack({ alignContent: Alignment.TopStart }) {
          Column() {
            //列表
            List({ space: 5, initialIndex: 0 }) {
              ForEach(this.arrList, (item: P) => {
                ListItem() {
                  Column() {
                    Row() {
                      Text(item.bedname).fontSize(8).fontColor(Color.Gray).margin({ right: 10 });
                      Text(item.patientname).fontSize(8).fontColor(Color.Gray).margin({ right: 10 });
                      Text(item.sex).fontSize(8).fontColor(Color.Gray).margin({ right: 10 });
                      Text(item.age).fontSize(8).fontColor(Color.Gray).margin({ right: 10 });
                      Text('ID：' + item.id).fontSize(8).fontColor(Color.Gray);
                    }.width('100%');

                    Row() {
                      Text(item.text)
                        .fontSize(10)
                        .fontWeight(600)
                        .fontColor($r('app.color.nurse_blue'))
                        .lineHeight(12)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .margin({ right: 5 });
                      Text('(' + item.amount + ')').fontSize(9).fontColor(Color.Gray).lineHeight(12);
                    }.width('100%').margin({ top: 4, bottom: 4 });

                    Row() {
                      Text('频次：' + item.frequency).fontSize(8).fontColor(Color.Gray).margin({ right: 10 });
                      Text(item.type).fontSize(8).fontColor(Color.Gray).margin({ right: 40 });
                      Text('收药时间：' + item.time).fontSize(8).fontColor(Color.Gray);
                    }.width('100%');
                  }
                  .width('96%')
                  .padding(5)
                  .margin({ top: 5, left: 5, right: 5 })
                  .backgroundColor(Color.White)
                  .shadow({
                    radius: 20,
                    color: $r('app.color.gray999'),
                    offsetX: 2,
                    offsetY: 2
                  })
                  .borderRadius(5);

                };
              });
            }
            .listDirection(Axis.Vertical) // 排列方向
            .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
            .chainAnimation(false) // 联动特效关闭
            .onScrollIndex((firstIndex: number, lastIndex: number) => {
              console.info('first' + firstIndex);
              console.info('last' + lastIndex);
            })
            .width('100%')
            .height('100%')
            .padding(5);
          }.width('100%').height('95%');
        };

      };
    }.hideTitleBar(true);
  }
}