import {PlayVibrateCustom,avPlayer,getDynamicStates} from '../moudle/util'
import {getImageExerciseList,ImageDataSource,ImagesData} from '../moudle/ImageData'
export enum flag {
  BADMINTON = 0,
  BASEBALL,
  BASKETBALL,
  SKATING,
  SKIING,
  TABLE_TENNIS,
  DIVING
}

@Component
export default struct ExerciseLayout {
  @State status:boolean[] = [false,false,false,false,false,false,false]
  private ExerciseList = new ImageDataSource(getImageExerciseList())
  @Link vibrationIntensity:string

  build(){
    Column({space:10}){
      List() {
        LazyForEach(this.ExerciseList, (Item: ImagesData) => {
          ListItem() {
            Row(){
              Row() {
                Image(Item.src).width(60).height(50).borderRadius(5).autoResize(false)
              }
              Stack({alignContent:Alignment.Start}) {
                Column() {
                  Text(Item.name).fontSize(15).fontColor(Color.White)
                }.alignItems(HorizontalAlign.Start).padding({ left: 20 })
              }.layoutWeight(7)
              Image($r("app.media.music")).width(15).height(15)
                .visibility(this.status[Item.id] ? Visibility.Visible : Visibility.Hidden)
            } .width("95%").height(70).padding({ top: 5, left: 10, right: 10, bottom: 5 })
            .backgroundColor(this.status[Item.id] ? "#1a3e3f56" : "#4d191a32")
            .onClick(() => {
              this.status = getDynamicStates(this.status, Item.id)
              if(this.vibrationIntensity === 'H') {
                console.info("振动文件源为：高强度模式")
                PlayVibrateCustom(Item.vibratorFileH)
              } else if(this.vibrationIntensity === 'M') {
                console.info("振动文件源为：中强度模式")
                PlayVibrateCustom(Item.vibratorFileM)
              } else if(this.vibrationIntensity === 'OHOS') {
                console.info("振动文件源为：低强度模式")
                PlayVibrateCustom(Item.vibratorFileL)
              } else {
                console.info("振动文件源为：OHOS音频转换模式")
                PlayVibrateCustom(Item.vibratorFileOHOS)
              }
              /*PlayVibrateCustom(Item.vibratorFile)*/
              console.info(Item.id.toString() +' '+ Item.name + ' ' + Item.audioName)
              avPlayer(Item.audioName)
            })
          }
        }) //LazyForEach
      } .listDirection(Axis.Vertical)
      .divider({ strokeWidth: 3, color: "#00f3f3f3", startMargin: 0, endMargin: 0 })
      .height('50%')
      .width('100%')
    }
  }
}