import IssueDetailInfo from '../models/IssueDetailInfo'

@Component
export default struct IssueReporterListItem {

  issueDetailInfo: IssueDetailInfo = new IssueDetailInfo()

  build() {
    Row() {
      Column({ space: '20lpx' }) {
        Text(this.issueDetailInfo.issueId)
          .fontSize('50lpx')
          .width('100%')
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)

        Text(this.issueDetailInfo.description)
          .fontSize('60lpx')
          .width('100%')
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
      }
      .width('100%')
      .padding({ left: '40lpx', right: '40lpx', top: '20lpx', bottom: '20lpx'})
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      Text(this.issueDetailInfo.statusDesc)
        .fontSize('60lpx')
        .margin({ right: '40lpx', top: '20lpx', bottom: '20lpx' })
        .width('260lpx')
        .maxLines(1)
        .textAlign(TextAlign.End)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }
}