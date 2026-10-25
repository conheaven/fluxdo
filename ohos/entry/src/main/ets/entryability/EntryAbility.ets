import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    const mainWindow: window.Window = windowStage.getMainWindowSync();
    mainWindow.setWindowLayoutFullScreen(false).then(() => {
      windowStage.loadContent('pages/Index');
    }).catch(() => {
      windowStage.loadContent('pages/Index');
    });
  }
}
