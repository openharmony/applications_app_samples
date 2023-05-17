
@Component
export default struct TabLayout {
  private fontSizeNormal = 18 //字体大小
  private tabMargin = 15// tab左右margin， margin：离栅格容器边缘的距离。可以根据设备的不同尺寸，定义不同的margin值，作为栅格布局的统一规范

  @Link titleArr: string[]
  @Link currentIndex:number
  private left: number= 0

  private tabSelected: (position: number, title: string) => void = (position: number, title: string) => {
    console.log('tabSelected position = ' + position + ', title = ' + title)
  }
  @State private tabDataArr: TabModel[] = []
  private scroller: Scroller = new Scroller()

  aboutToAppear() {//函数在创建自定义组件的新实例后，在执行其 build() 函数之前执行。允许在该函数中改变状态变量，更改将在后续执行 build() 函数中生效
    this.tabDataArr = this.titleArr.map((title, index) => {
      let tabModel = new TabModel()//页面模型
      tabModel.index = index//index：页面索引
      tabModel.content = title//content：内容
      tabModel.left = this.left//离容器左边的距离
      let width = title.length * this.fontSizeNormal + this.tabMargin * 2
      //宽度 = 字体的宽度*字号 + 容器边缘的距离 *2
      tabModel.width = width
      tabModel.left = this.left
      this.left += width
      return tabModel
    })
  }
  build() {
    Scroll(this.scroller) {
      Flex({direction:FlexDirection.Row}) {
        ForEach(this.tabDataArr, (Item:TabModel)=> {
          Flex({direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center}) {
            Text(Item.content)
              .fontSize(this.currentIndex == Item.index ? this.fontSizeNormal + 3 : this.fontSizeNormal)
              .fontColor(this.currentIndex == Item.index ? "#2AEFCC" : Color.White)
              .fontWeight(this.currentIndex == Item.index ? FontWeight.Bold : FontWeight.Normal)
              .textAlign(TextAlign.Center)
            Column()
              .height(3)
              .width(Item.width - this.tabMargin * 2)
              .margin({top:10})
              .backgroundColor("#2AEFCC")
              .visibility(this.currentIndex == Item.index ? Visibility.Visible : Visibility.Hidden)
          }.width(Item.width).height('100%').backgroundColor("#00002222")
          .onClick(()=> {
            this.currentIndex = Item.index
          })
        }, Item => Item.index)
      }
    }.scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)
  }
}


export class TabModel {
  index: number
  content: string
  left: number
  width: number
}