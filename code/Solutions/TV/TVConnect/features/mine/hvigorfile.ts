import { harTasks } from '@ohos/hvigor-ohos-plugin';
import { harPlugin } from '@hadss/hmrouter-plugin';

export default {
  system: harTasks,
  plugins:[harPlugin()]  // 使用HMRouter标签的模块均需要配置，与模块类型保持一致
}