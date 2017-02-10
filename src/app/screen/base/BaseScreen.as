/**
 * Created by zear19st on 2017/2/6.
 */
package app.screen.base
{
    import flash.utils.getQualifiedClassName;

    import lyndcomp.Lynd;
    import lyndcomp.component.base.Component;

    public class BaseScreen extends Component
    {
        public function BaseScreen(lynd:Lynd, param:Object)
        {
            super(lynd, param);
        }

        override protected function create(param:Object):void
        {
            store.addListen(store.state.app.screen, onScreenChange);
        }

        private function onScreenChange(screen:Class):void
        {
            if (getQualifiedClassName(this) == getQualifiedClassName(screen))
                startup();
            else if (isAdded)
                stopup(true);
        }
    }
}
