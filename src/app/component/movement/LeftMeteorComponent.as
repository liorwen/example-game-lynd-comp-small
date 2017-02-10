/**
 * Created by zear19st on 2017/2/7.
 */
package app.component.movement
{
    import app.component.movement.base.MovementComponent;
    import app.config.Types;

    import com.greensock.TweenLite;
    import com.greensock.easing.Linear;

    import flash.geom.Point;

    import lyndcomp.Lynd;

    public class LeftMeteorComponent extends MovementComponent
    {
        public function LeftMeteorComponent(lynd:Lynd, param:Object)
        {
            param.view = new LeftMeteor();
            super(lynd, param);
        }

        override protected function create(param:Object):void
        {
            _view.gotoAndStop(1);
            _view.body.gotoAndStop(1);
        }

        override protected function moveBehavior():void
        {
            var pt1:Point = new Point(-60, -60);
            var pt2:Point = new Point(950, 888);
            var rot:Number = getRotation(pt1, pt2);
            var dist:Number = Point.distance(pt1, pt2);
            var time:Number = dist / (MovementComponent.SPEED * 3);
            _view.body.rotation = rot / Math.PI * 180;
            _view.cacheAsBitmap = true;
            _view.x = pt1.x;
            _view.y = pt1.y;
            TweenLite.to(_view, time, {x: pt2.x, y: pt2.y, ease: Linear.easeNone, onComplete: onMoveComplete});
        }

        private function onMoveComplete():void
        {
            state = MovementComponent.END;
        }

        override protected function touchBehavior():void
        {
            new BrokeSound().play();
            store.commit(Types.ADD_YOUR_SCORE, -2);
            TweenLite.killTweensOf(_view);
            _view.gotoAndStop(2);
            _view.body.gotoAndStop(2);
            TweenLite.to(_view, 1, {alpha: 0, ease: Linear.easeNone, onComplete: onTouchComplete});
        }

        private function onTouchComplete():void
        {
            state = MovementComponent.END;
        }

        override protected function endBehavior():void
        {
            stopup(true);
        }
    }
}
