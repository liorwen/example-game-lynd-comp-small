/**
 * Created by zear19st on 2017/2/7.
 */
package app.component.movement.base
{
    import com.greensock.TweenLite;

    import flash.events.MouseEvent;
    import flash.geom.Point;

    import lyndcomp.Lynd;
    import lyndcomp.component.base.Component;

    public class MovementComponent extends Component
    {
        public static const MOVE:String = "MovementComponent.Move";
        public static const END:String = "MovementComponent.End";
        public static const STOP:String = "MovementComponent.Stop";
        public static const TOUCH:String = "MovementComponent.Touch";

        public static const SPEED:Number = 60;

        public function MovementComponent(lynd:Lynd, param:Object)
        {
            super(lynd, param);
        }

        override protected function added():void
        {
            _state.addState(MOVE, moveInState, moveOutState);
            _state.addState(TOUCH, touchInState, touchOutState);
            _state.addState(END, endInState, endOutState);
            _state.addState(STOP, stopInState, stopOutState);

            store.addListen(store.state.app.isGame, onGameFlag);
            store.addListen(store.state.app.clear, onClear);

            onGameFlag(store.state.app.isGame.value);
        }

        override protected function removed():void
        {
            store.removeListen(store.state.app.isGame, onGameFlag);
            store.removeListen(store.state.app.clear, onClear);
            _state.clearState();
            _view = null;
        }

        private function onClear(isClear:Boolean):void
        {
            state = END;
        }

        private function onGameFlag(isGame:Boolean):void
        {
            if (isGame)
                state = MOVE;
            else
                state = STOP;
        }

        private function onClick(event:MouseEvent):void
        {
            state = TOUCH;
        }

        private function moveInState():void
        {
            _view.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
            _view.mouseEnabled = true;
            _view.buttonMode = true;
            moveBehavior();
        }

        protected function moveBehavior():void
        {

        }

        private function moveOutState():void
        {
            _view.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
            _view.mouseEnabled = false;
            _view.buttonMode = false;
        }

        private function touchInState():void
        {
            touchBehavior();
        }

        protected function touchBehavior():void
        {

        }

        private function touchOutState():void
        {

        }

        private function endInState():void
        {
            endBehavior();
        }

        protected function endBehavior():void
        {

        }

        private function endOutState():void
        {

        }

        private function stopInState():void
        {
            TweenLite.killTweensOf(_view);
        }

        private function stopOutState():void
        {

        }

        protected function getRotation(pt1:Point, pt2:Point):Number
        {
            var dX:Number = pt2.x - pt1.x;
            var dY:Number = pt2.y - pt1.y;
            var dRoation:Number = Math.atan2(dY, dX);
            return dRoation;
        }

        protected function getPoint(pt:Point, dist:Number, rot:Number):Point
        {
            var distY:Number = pt.y + Math.round(dist * Math.sin(rot));
            var distX:Number = pt.x + Math.round(dist * Math.cos(rot));
            return new Point(distX, distY);
        }
    }
}
