import { Disk } from '../engine/hanoi';
import { DiskView } from './DiskView';

/**
 * 学习点 ①(工单 03):自定义组件拆分——一根柱。
 * 柱杆固定居中,圆盘自底向上堆叠(disks 为柱底→柱顶顺序,渲染时反转)。
 * selected 为真时高亮(工单 04:源柱选中态)。
 */
@Component
export struct PegView {
  @Prop disks: Disk[];
  @Prop selected: boolean;

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 底座(先声明,垫在最底层)
      Row() {
      }
      .width(110)
      .height(8)
      .borderRadius(4)
      .backgroundColor('#5D4037')

      // 柱杆
      Column() {
      }
      .width(6)
      .height(210)
      .borderRadius(3)
      .backgroundColor('#8D6E63')

      // 圆盘堆(渲染顺序:顶盘在最上;抬高底座高度避免被底座盖住)
      Column({ space: 2 }) {
        ForEach(this.disks.slice().reverse(), (disk: Disk) => {
          DiskView({ diskSize: disk.size })
        }, (disk: Disk) => `d${disk.size}`)
      }
      .margin({ bottom: 8 })
    }
    .width(120)
    .borderRadius(12)
    .border({
      width: this.selected ? 3 : 0,
      color: '#FF7043'
    })
    .animation({ duration: 150 })
  }
}
