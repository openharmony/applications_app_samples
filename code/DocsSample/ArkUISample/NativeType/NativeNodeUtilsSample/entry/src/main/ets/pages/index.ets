// index.ets
import router from '@system.router';
import entry from 'libentry.so';

@Entry
@Component
struct Index {

  build() {
    Flex() {
      Column() {
        Button("多实例创建组件").onClick(() => {
          router.push({
            uri: 'pages/entry'
          });
        })
        Button("自定义属性测试").onClick(() => {
          router.push({
            uri: 'pages/customproperty'
          });
        })
        Button("懒加载页面").onClick(() => {
          router.push({
            uri: 'pages/nodeadapter'
          });
        })
        // 该接口作用为NDK侧保存主窗口实例，用户保护实例错误调用场景。
        Button("设置NDK侧主窗口Context").onClick(()=> {
          entry.getContext(this.getUIContext())
        })
      }.width('100%')
    }.width('100%')
  }
}
