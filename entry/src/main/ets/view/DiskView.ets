import { Disk } from '../engine/hanoi';

/**
 * 学习点 ①(工单 03):自定义组件拆分——单枚圆盘。
 * 宽度随大小递增,颜色按大小取调色板,大小一眼可辨。
 */
const DISK_COLORS: ResourceColor[] = [
  '#E53935', // 1
  '#FB8C00', // 2
  '#FDD835', // 3
  '#43A047', // 4
  '#1E88E5', // 5
  '#5E35B1', // 6
  '#8E24AA', // 7
  '#D81B60', // 8
];

@Component
export struct DiskView {
  @Prop diskSize: number;

  build() {
    Row() {
    }
    .width(16 + this.diskSize * 11)
    .height(18)
    .borderRadius(9)
    .backgroundColor(DISK_COLORS[this.diskSize - 1])
    .shadow({ radius: 2, offsetX: 0, offsetY: 1, color: 'rgba(0,0,0,0.25)' })
  }
}
