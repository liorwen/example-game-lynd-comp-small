/**
 * Created by zear19st on 2017/2/7.
 */
package app.component.movement
{
    import app.component.movement.base.MovementComponent;
    import app.component.movement.base.GameManager;
    import app.config.Types;

    import com.greensock.TweenLite;
    import com.greensock.easing.Linear;

    import flash.geom.Point;
    import flash.media.Sound;
    import flash.text.TextFieldAutoSize;
    import flash.utils.setTimeout;

    import lyndcomp.Lynd;

    public class CraftComponent extends MovementComponent
    {
        private static var _stylePool:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
        private var _myQuest:Object;
        private var _isSelect:Boolean;
        private var _startPt:Point;
        private var _dist:Number;
        private var _isRemoveShow:Boolean;

        public function CraftComponent(lynd:Lynd, param:Object)
        {
            param.view = new Craft();
            super(lynd, param);
        }

        private static function getStyle():int
        {
            var startType:int = int(String(_stylePool.length * Math.random()).split(".")[0]);
            var res:int = _stylePool.splice(startType, 1)[0];
            if (_stylePool.length == 0)
            {
                _stylePool = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
                _stylePool.splice(res, 1)[0];
            }
            return res + 1;
        }

        override protected function create(param:Object):void
        {
            _isSelect = false;
            _view.alpha = 0;
            _view.gotoAndStop(1);
            _view.txt.mouseEnabled = false;
            _view.txt.autoSize = TextFieldAutoSize.CENTER;
            _myQuest = GameManager.getInstance().getQuest(store.state.app.isStartQuest.value);
            _view.txt.text = _myQuest.key;
            var body:int = getStyle();
            _view.body.gotoAndStop(body);
        }

        override protected function moveBehavior():void
        {
            var mPt:Object = GameManager.getInstance().getMovePoint();
            _startPt = mPt.pt1;
            var endPt:Point = mPt.pt2;
            var rot:Number = getRotation(_startPt, endPt);
            _dist = Point.distance(_startPt, endPt);
            var time:Number = _dist / (MovementComponent.SPEED);
            _view.body.rotation = rot / Math.PI * 180;
            _view.cacheAsBitmap = true;
            _view.x = _startPt.x;
            _view.y = _startPt.y;
            _isRemoveShow = false;
            TweenLite.to(_view, 0.5, {alpha: 1});
            TweenLite.to(_view, time, {
                delay: 0.5,
                x: endPt.x,
                y: endPt.y,
                ease: Linear.easeNone,
                onUpdate: onMoveUpdate,
                onComplete: onMoveComplete
            });
        }

        private function onMoveUpdate():void
        {
            if (_isRemoveShow)
                return;
            if (_view.x <= 0 || _view.x >= 1024 || _view.y >= 768)
            {
//                trace("pushCraft")
                _isRemoveShow = true;
                if (_isSelect)
                    return;
                GameManager.getInstance().removeShowQuest(_myQuest);
                store.trigger(store.state.app.pushCraft);
            }
        }

        private function getSpeedPlus():Number
        {
            var select:int = int(String(2 * Math.random()).split(".")[0]);
            if (select > 0)
                return 1.5;
            return 1;
        }

        private function onMoveComplete():void
        {
            state = MovementComponent.END;
        }

        override protected function touchBehavior():void
        {
            var sound:Sound;
            if (GameManager.getInstance().nowQuest.key == _view.txt.text)
            {
                store.commit(Types.ADD_YOUR_SCORE, 1);
                _view.gotoAndStop(2);
                _isSelect = true;
                sound = new RightSound();
            }
            else
            {
                store.commit(Types.ADD_YOUR_SCORE, -1);
                _view.gotoAndStop(3);
                sound = new ErrorSound();
                setTimeout(repeatQuest, 500);

            }
//            GameManager.getInstance().backQuest(_myQuest);
//            store.trigger(store.state.app.pushCraft);
            sound.play();
            TweenLite.killTweensOf(_view);
            TweenLite.to(_view, 0.5, {alpha: 0, ease: Linear.easeNone, onComplete: onTouchComplete});
        }

        private function repeatQuest():void
        {
            if (!store.state.app.isGame.value)
                return;
            GameManager.getInstance().repeatQuest();
        }

        private function onTouchComplete():void
        {
            state = MovementComponent.END;
        }

        override protected function endBehavior():void
        {
            if (store.state.app.isGame.value)
            {
                if (_isSelect)
                {
                    GameManager.getInstance().backQuest(_myQuest);
                    GameManager.getInstance().selectQuest();
                    store.trigger(store.state.app.pushCraft);
                }
                else
                {
                    GameManager.getInstance().backQuest(_myQuest);
                }

            }
            stopup(true);
        }
    }
}
