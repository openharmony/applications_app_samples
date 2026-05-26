import { router } from '@kit.ArkUI';
import { name } from './PatientList';
import { drugsList } from './MedicalAdvice';
import { DrugClass, DrugData, DrugObject } from '../../viewmodel/OrderExecution/MediacalData';

@Entry
@Component
export struct Drug {
  @State currentIndex: number = 0;

  onCancel() {
    console.info('Callback when the first button is clicked');
  }

  onAccept() {
    console.info('Callback when the second button is clicked');
  }

  build() {
    Column() {
      //header
      Row() {
        Image($r('app.media.nurse_back_gray')).width(20).height(20).position({ x: 10, y: 18 })
          .onClick(() => {
            router.back();
          });
        Text('药品配液')
          .height(22)
          .fontSize(20);
      }
      .backgroundColor(Color.White)
      .width('100%')
      .height(50)
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
            ForEach(drugsList, (item: DrugClass) => {
              ListItem() {
                Column() {
                  Row() {
                    Text(name.bedName).fontSize(16).fontColor(Color.Gray).margin({ right: 10 });
                    Text(name.patientName).fontSize(16).fontColor(Color.Gray).margin({ right: 10 });
                    Text(name.sex).fontSize(16).fontColor(Color.Gray).margin({ right: 10 });
                    Text(name.patientAge).fontSize(16).fontColor(Color.Gray).margin({ right: 10 });
                    Text('ID：' + name.patientId).fontSize(16).fontColor(Color.Gray);
                  }.width('100%').padding(10);

                  Row() {
                    Text(item.field1)
                      .fontSize(20)
                      .fontWeight(600)
                      .fontColor($r('app.color.nurse_blue'))
                      .lineHeight(24)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .margin({ right: 5 });
                  }.width('100%').padding(10);

                  Divider().strokeWidth(1).color('#999').margin({ top: 5 });
                  Row() {
                    Text('频次：' + item.field9).fontSize(16).fontColor(Color.Gray).margin({ right: 10 });
                    Text(item.field8).fontSize(16).fontColor(Color.Gray).margin({ right: 20 });
                    Text('收药时间：' + item.field10).fontSize(16).fontColor(Color.Gray);
                  }.width('100%').padding(10);
                }.width('92%')
                .margin({ top: 15, left: 15 })
                .backgroundColor(Color.White)
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
        }.width('100%').height('85%');
      };

      Row() {
        Button('完成配液并复核', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0xeaf3ff)
          .fontColor($r('app.color.nurse_blue'))
          .width(150)
          .margin({ right: 20 })
          .onClick(() => {
            router.back();
          });
        Button('完成配液', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor($r('app.color.nurse_blue'))
          .width(150)
          .onClick(() => {
            router.back();
          });
      }.width('100%').backgroundColor(Color.White).padding({ top: 15, bottom: 15 }).justifyContent(FlexAlign.Center);
    }.backgroundColor('#f1f2f6');
  }
}