import { cardsMockData } from '../mock/Data'

export class CardDataFormat {
  constructor(title: string, detail: string) {
    this.title = title
    this.detail = detail
  }

  getValue(name: string) {
    if (name === 'title') {
      return this.title
    } else if (name === 'detail') {
      return this.detail
    }
  }

  private title: string
  private detail: string
}

export function getCardsData(count: number): Array<CardDataFormat> {
  let data: Array<CardDataFormat> = []
  if (count === -1) {
    cardsMockData.forEach((item) => {
      data.push(new CardDataFormat(item.title, item.detail))
    })
    return data
  }
  try {
    cardsMockData.forEach((item, idx) => {
      if (idx === count) {
        throw new Error('break')
      }
      data.push(new CardDataFormat(item.title, item.detail))
    })
  } catch (e) {
    return data
  }
}

@Component
export struct CardGenerator {
  private data: CardDataFormat

  build() {
    Column() {
      Text(this.data.getValue('title'))
        .fontWeight(FontWeight.Bold)
        .fontSize(16)
        .textAlign(TextAlign.Start)
        .width('100%')
      Scroll() {
        Text(this.data.getValue('detail')).textAlign(TextAlign.Start).width('100%')
      }.height('70%').scrollBar(BarState.Off).align(Alignment.TopStart)
    }.borderWidth(1).height(100)
  }
}