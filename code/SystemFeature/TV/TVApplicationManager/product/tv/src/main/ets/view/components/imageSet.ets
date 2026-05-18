import { StyleConstants } from '../../common/constants/StyleConstants'

@Component
export default struct imageSet  {
  @Link imageSrc:Array<string>
  setList:Array<number>=[0.02,0.03,(-0.023),0.03]
  imageIndex:number=0

  @State setListData:Array<number>=[]
  aboutToAppear(): void {
    this.setListData = []
    this.setListData =[...this.setList]
  }
  build() {
    Column() {

      Image($r(this.imageSrc[this.imageIndex]))
        .width(StyleConstants.LPX_DESIGNWIDTH *this.setListData[0] + 'lpx')
        .height(StyleConstants.LPX_DESIGNWIDTH * this.setListData[1] + 'lpx')
        .zIndex(10)
        .position({
          x: StyleConstants.LPX_DESIGNWIDTH * this.setListData[2]+ 'lpx',
          y: StyleConstants.LPX_DESIGNWIDTH * this.setListData[3] + 'lpx'
        }) .autoResize(true)
    }
  }
}

