import { describe, it, expect } from '@ohos/hypium';
import { TowerOfHanoi } from '../main/ets/engine/hanoi';

export default function localUnitTest() {
  describe('towerOfHanoi', () => {
    it('开局后三根柱就位,圆盘按大小顺序堆在起始柱上', 0, () => {
      let game = new TowerOfHanoi(3);
      let pegs = game.pegs;
      expect(pegs.length).assertEqual(3);
      expect(pegs[0].map(disk => disk.size).join(',')).assertEqual('3,2,1');
      expect(pegs[1].length).assertEqual(0);
      expect(pegs[2].length).assertEqual(0);
    });

    it('从空柱取盘被拒绝', 0, () => {
      let game = new TowerOfHanoi(3);
      expect(game.tryMove(1, 0)).assertFalse();
    });

    it('大压小被拒绝', 0, () => {
      let game = new TowerOfHanoi(3);
      // 先把最小的盘(1)移到第二根柱,再试图把 2 压在它上面
      expect(game.tryMove(0, 1)).assertTrue();
      expect(game.tryMove(0, 1)).assertFalse();
    });

    it('同柱移动被拒绝', 0, () => {
      let game = new TowerOfHanoi(3);
      expect(game.tryMove(0, 0)).assertFalse();
    });

    it('非法移动不改变局面与步数', 0, () => {
      let game = new TowerOfHanoi(3);
      game.tryMove(0, 1);          // 合法:1 号盘到柱 1
      game.tryMove(0, 1);          // 非法:大压小
      let pegs = game.pegs;
      expect(pegs[0].map(disk => disk.size).join(',')).assertEqual('3,2');
      expect(pegs[1].map(disk => disk.size).join(',')).assertEqual('1');
      expect(game.moveCount).assertEqual(1);
    });

    it('盘数 3–8 任一开局都成立', 0, () => {
      for (let n = 3; n <= 8; n++) {
        let game = new TowerOfHanoi(n);
        let pegs = game.pegs;
        expect(pegs[0].length).assertEqual(n);
        expect(pegs[0][0].size).assertEqual(n); // 柱底最大
        expect(pegs[0][n - 1].size).assertEqual(1); // 柱顶最小
      }
    });

    it('最少步数等于 2 的 n 次方减一', 0, () => {
      expect(new TowerOfHanoi(3).minMoves).assertEqual(7);
      expect(new TowerOfHanoi(5).minMoves).assertEqual(31);
      expect(new TowerOfHanoi(8).minMoves).assertEqual(255);
    });

    it('全部圆盘到齐目标柱时胜利', 0, () => {
      let game = new TowerOfHanoi(3);
      expect(game.isWon).assertFalse();
      // 最优解:0→2, 0→1, 2→1, 0→2, 1→0, 1→2, 0→2
      let solution = [[0, 2], [0, 1], [2, 1], [0, 2], [1, 0], [1, 2], [0, 2]];
      for (let i = 0; i < solution.length - 1; i++) {
        expect(game.tryMove(solution[i][0], solution[i][1])).assertTrue();
        expect(game.isWon).assertFalse(); // 中途未胜
      }
      expect(game.tryMove(0, 2)).assertTrue();
      expect(game.isWon).assertTrue();
      expect(game.moveCount).assertEqual(7);
    });

    it('圆盘全在非目标柱上不算胜利', 0, () => {
      // 构造:把 3 盘全堆到中间柱(合法移动可达)——不在目标柱,不算胜利
      let game = new TowerOfHanoi(3);
      let toMiddle = [[0, 1], [0, 2], [1, 2], [0, 1], [2, 0], [2, 1], [0, 1]];
      for (let i = 0; i < toMiddle.length; i++) {
        expect(game.tryMove(toMiddle[i][0], toMiddle[i][1])).assertTrue();
      }
      expect(game.pegs[1].length).assertEqual(3);
      expect(game.isWon).assertFalse();
    });
  });
}
