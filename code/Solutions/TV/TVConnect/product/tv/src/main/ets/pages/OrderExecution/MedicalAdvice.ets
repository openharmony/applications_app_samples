import cert from '@ohos.security.cert';
import { promptAction, router } from '@kit.ArkUI';
import { name } from './PatientList';
import http from '@ohos.net.http';
import { DrugClass, DrugData, DrugObject } from '../../viewmodel/OrderExecution/MediacalData';
import Net from '../../viewmodel/OrderExecution/netConfig';
import emitter from '@ohos.events.emitter';

export let drugsList: DrugClass[] = [];

export async function Post(typeId: string, orgId: string, deptId: string): Promise<Array<DrugClass> | null> {
  let httpPostRequest = http.createHttp();
  httpPostRequest.on('headersReceive', (header) => {
    console.info('Get header: ' + JSON.stringify(header));
  });
  return new Promise((resolve, reject) => {
    let promise =
      httpPostRequest.request('http://' + Net.getInstance().ip + '/app-gateway/patient-biz/doctor-advice/list', {
        method: http.RequestMethod.POST,
        extraData: JSON.stringify({
          typeId: typeId,
          orgId: orgId,
          deptId: deptId,
          patientId: name.patientId,
          page: 1,
          size: 10
        }),
        connectTimeout: 60000,
        readTimeout: 60000,
        header: {
          'Content-Type': 'application/json'
        }
      });
    promise.then((data) => {
      let resultObject: DrugObject = JSON.parse(data.result as string) as DrugObject;
      if (resultObject && resultObject.data && Array.isArray(resultObject.data.list)) {
        drugsList = [];
        let drugs: DrugClass[] = resultObject.data.list.map((item: DrugData) => DrugClass.fromJSON(item));
        // 现在 Drugs 是 Drug 类的实例数组，你可以进行进一步的操作
        drugs.forEach((drug) => {
          drugsList.push(drug);
        });
        resolve(drugsList);
      } else {
        console.error('Expected resultObject.data to be an array');
        resolve(null);
      }
    }).catch((err: Error) => {
      console.info('error:' + JSON.stringify(err));
      reject(err);
    });
  });
}


class MyDataSource implements IDataSource {
  private list: number[] = [];
  private listener: DataChangeListener | undefined | null;

  constructor(list: number[]) {
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): number {
    return this.list[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener;
  }

  unregisterDataChangeListener() {
  }
}

@Component
struct test {
  @State text: string = '';
  @State status: string = '';
  @State time: string = '';

  build() {
    Column() {
      Row() {
        Text(this.text)
          .fontSize(20)
          .fontWeight(600)
          .fontColor($r('app.color.nurse_blue'))
          .lineHeight(24)
          .width('70%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis });
        if (this.status == '已执行') {
          Text(this.status).fontSize(14).fontColor(Color.Blue).lineHeight(14);
        } else {
          Text(this.status).fontSize(14).fontColor(Color.Gray).lineHeight(14);
        }
      }.width('100%').justifyContent(FlexAlign.SpaceBetween);

      Text(this.time)
        .fontSize(16)
        .fontColor(Color.Gray)
        .lineHeight(24)
        .width('100%')
        .textAlign(TextAlign.Start);
    }
    .onClick(() => {
      if (this.status == '未执行') {
        router.pushUrl({
          url: 'pages/OrderExecution/Drug'
        });
      }
    })
    .width('92%')
    .padding(10)
    .margin({ top: 15, left: 15 })
    .backgroundColor(Color.White)
    .shadow({
      radius: 20,
      color: $r('app.color.gray999'),
      offsetX: 2,
      offsetY: 2
    })
    .borderRadius(5);
  }
}

@Entry
@Component
export struct MedicalAdvice {
  private count: number = 1;
  private swiperController: SwiperController = new SwiperController();
  @State drugsList: DrugClass[] = [];
  @State isRefreshing: boolean = false;

  async aboutToAppear(): Promise<void> {
    try {
      let innerEvent: emitter.InnerEvent = {
        eventId: 10086
      };
      // 事件回调中的异步函数
      const eventCallback = async () => {
        try {
          const data = await Post(Net.getInstance().typeId, Net.getInstance().orgId, Net.getInstance().deptId);
          if (data != null) {
            this.drugsList = [];
            this.drugsList = data;
            console.info('Data updated from event:', this.drugsList);
          }
        } catch (error) {
          console.error('Error fetching data from event:', error);
        }
      };
      emitter.on(innerEvent, eventCallback);
      const data = await Post(Net.getInstance().typeId, Net.getInstance().orgId, Net.getInstance().deptId);
      if (data != null) {
        this.drugsList = data;
      }
    } catch (error) {
      console.error('Error fetching data: ' + error);
    }
  }

  aboutToDisappear(): void {
    emitter.off(10086);
  }

  @State currentIndex: number = 0;
  scroller: Scroller = new Scroller();

  build() {
    Column() {
      //header
      Row() {
        Image($r('app.media.nurse_back')).width(20).position({ x: 10, y: 18 })
          .onClick(() => {
            router.back();
          });
        Text('医嘱执行')
          .height(22)
          .fontColor('#fff')
          .fontSize(20);
      }.backgroundColor('#6fa7ff').width('100%').height(50).justifyContent(FlexAlign.Center);

      Row() {
      }
      .backgroundColor('#6fa7ff')
      .borderRadius({ bottomLeft: 10, bottomRight: 10 })
      .width('100%')
      .height(50)
      .justifyContent(FlexAlign.Center);

      // patient info
      Row() {
        Row() {
        }
        .width(50)
        .height('66%')
        .backgroundColor(Color.White)
        .borderRadius(5)
        .shadow({
          radius: 20,
          color: $r('app.color.gray999'),
          offsetX: 2,
          offsetY: 2
        })
        .position({ x: '-8%', y: 20 });

        Column() {
          Row() {
            Text(name.bedName).fontSize(30).fontColor(Color.Orange);
            Text('床').fontSize(16).fontColor(Color.Gray).margin({ right: 10, bottom: 3 });
            Text(name.patientName).fontSize(30).fontColor($r('app.color.nurse_blue')).margin({ right: 10 });
            Text(name.illnessStatus).fontSize(16).fontColor(Color.Gray).margin({ bottom: 3 });
          }.margin({ top: 15, bottom: 10 }).alignItems(VerticalAlign.Bottom);

          Row() {
            Text(name.sex).fontSize(16).fontColor(Color.Gray).margin({ right: 10 });
            Text(name.patientAge).fontSize(16).fontColor(Color.Gray);
          };
        }
        .width('84%')
        .height('80%')
        .backgroundColor(Color.White)
        .borderRadius(5)
        .shadow({
          radius: 20,
          color: $r('app.color.gray999'),
          offsetX: 2,
          offsetY: 2
        })
        .margin({ left: '9%' });

        Row() {
        }
        .width(50)
        .height('66%')
        .backgroundColor(Color.White)
        .borderRadius(5)
        .shadow({
          radius: 20,
          color: $r('app.color.gray999'),
          offsetX: 2,
          offsetY: 2
        })
        .position({ x: '96%', y: 20 });
      }.width('100%').height(120).position({ x: 0, y: 45 });

      Refresh({ refreshing: $$this.isRefreshing }) {
        Stack({ alignContent: Alignment.TopStart }) {
          Column() {
            //列表
            List({ space: 5, initialIndex: 0 }) {
              ForEach(this.drugsList, (item: DrugClass) => {
                ListItem() {
                  test({ text: item.field1, status: item.field20, time: item.field10 });
                };
              });
              ListItem() {
                Text('  ').height(50);
              }.margin({ top: 15, left: 15 });
            }
            .listDirection(Axis.Vertical) // 排列方向
            .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
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
      }
      .margin({ top: 70 })
      .onStateChange((refreshStatus: RefreshStatus) => {
        console.info('Refresh onStatueChange state is ' + refreshStatus);
      })
      .onRefreshing(() => {
        Post(Net.getInstance().typeId, Net.getInstance().orgId, Net.getInstance().deptId).then((data) => {
          if (data != null) {
            this.drugsList = data;
          }
          this.isRefreshing = false;
        });
        console.log('onRefreshing test');
      });
    }.backgroundColor('#f1f2f6');
  }
}