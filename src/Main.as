package
{

    import app.App;
    import app.store.AppStore;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import lyndcomp.Lynd;

    [SWF(width="1024", height="768", frameRate="60", backgroundColor="0")]
    public class Main extends Sprite
    {
        private var defaultStageWidth:Number = 1024;
        private var defaultStageHeight:Number = 768;
        private var _lynd:Lynd;

        public function Main()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            addEventListener(Event.ADDED_TO_STAGE, onAdded);
        }

        private function onAdded(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAdded);
            stage.addEventListener(Event.RESIZE, onResize);
            _lynd = new Lynd({
                root: this,
                store: {
                    app: AppStore
                },
                component: App
            });
        }

        private function onResize(event:Event):void
        {
            trace("onResize");
            if (_lynd.extra.canBeUsed())
            {

                switch (_lynd.extra.type)
                {
                    case "mdm":
                        mdmResize();
                        break;
                    case "delphi":

                        break;
                }
            }
        }

        private function mdmResize():void
        {

            var newScaleX:Number = stage.stageWidth / defaultStageWidth;
            var newScaleY:Number = stage.stageHeight / defaultStageHeight;

            if (newScaleX > newScaleY)
                newScaleX = newScaleY;
            else
                newScaleY = newScaleX;

            this.scaleX = newScaleX;
            this.scaleY = newScaleY;
            var newDefaultWith:Number = defaultStageWidth * newScaleX;
            var newDefaultHeight:Number = defaultStageHeight * newScaleY;
            var offsetX:Number = defaultStageWidth / 2 - stage.stageWidth / 2;
            var offsetY:Number = defaultStageHeight / 2 - stage.stageHeight / 2;
            this.x = offsetX + stage.stageWidth / 2 - newDefaultWith / 2;
            this.y = offsetY + stage.stageHeight / 2 - newDefaultHeight / 2;

        }
    }
}
