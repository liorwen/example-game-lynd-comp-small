/**
 * Created by zear19st on 2017/2/8.
 */
package app.component.movement.base
{
    import app.component.movement.CraftComponent;
    import app.component.movement.LeftMeteorComponent;
    import app.component.movement.RightMeteorComponent;
    import app.component.movement.UfoComponent;
    import app.config.Question;

    import flash.display.DisplayObjectContainer;

    import flash.geom.Point;
    import flash.media.Sound;
    import flash.utils.Dictionary;
    import flash.utils.setTimeout;

    import lyndcomp.Lynd;
    import lyndcomp.tool.util;

    public class GameManager
    {
        private var _startPool:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
        private var _meteorPool:Array = [0, 0, 1];
        private var _quests:Array;

        public var nowQuest:Object;
        public var nextQuest:Object;
        private var _nowQuests:Array = [];
        private var _showQuest:Array = [];
        private var _usedQuestDict:Dictionary;

        private static var _instance:GameManager;

        public function GameManager()
        {
            _usedQuestDict = new Dictionary();
        }

        public static function getInstance():GameManager
        {
            if (_instance == null)
                _instance = new GameManager();
            return _instance;
        }

        private function getStartType():int
        {
            var startType:int = int(String(_startPool.length * Math.random()).split(".")[0]);
            var res:int = _startPool.splice(startType, 1)[0];
            if (_startPool.length == 0)
            {
                _startPool = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
                _startPool.splice(res, 1)[0];
            }
            return res;
        }

        public function init():void
        {
            _startPool = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
            _meteorPool = [0, 0, 1];
            _quests = Question.getQuests(true);
            nowQuest = null;
            nextQuest = null;
            _nowQuests = [];
            _showQuest = [];
            clearUsedQuest();
//            _pool = Question.GetQuests();
        }

        public function getMovePoint():Object
        {
            var startPt:Vector.<Point> = new Vector.<Point>();
//            startPt.push(new Point(495 +Math.round(313 * Math.random()), 276 + Math.round(280 * Math.random())));
//            startPt.push(new Point(173 + Math.round(313 * Math.random()), 276 + Math.round(280 * Math.random())));
            startPt.push(new Point(108, 290));
            startPt.push(new Point(270, 290));
            startPt.push(new Point(431, 290));
            startPt.push(new Point(108, 426));
            startPt.push(new Point(270, 426));
            startPt.push(new Point(431, 426));
            startPt.push(new Point(108, 563));
            startPt.push(new Point(270, 563));
            startPt.push(new Point(431, 563));

            startPt.push(new Point(593, 290));
            startPt.push(new Point(755, 290));
            startPt.push(new Point(916, 290));
            startPt.push(new Point(593, 426));
            startPt.push(new Point(755, 426));
            startPt.push(new Point(916, 426));
            startPt.push(new Point(593, 563));
            startPt.push(new Point(755, 563));
            startPt.push(new Point(916, 563));


            var endPt:Vector.<Point> = new Vector.<Point>();
            endPt.push(new Point(1120, 220 + Math.round(360 * Math.random())));
            endPt.push(new Point(600 + Math.round(327 * Math.random()), 888));
            endPt.push(new Point(-100, 220 + Math.round(360 * Math.random())));
            endPt.push(new Point(15 + Math.round(320 * Math.random()), 888));
            var pRight:int = 0;
            var pLeft:int = 2;
            var startType:int = getStartType();
            var endType:int = startType <= 8 ? pRight : pLeft;
            endType += int(String(2 * Math.random()).split(".")[0]);
            return {pt1: startPt[startType], pt2: endPt[endType]};
        }

        public function getMovement(lynd:Lynd, screen:DisplayObjectContainer):MovementComponent
        {
            var selectType:int = int(String(2 * Math.random()).split(".")[0]);
            if (selectType == 0)
                return new CraftComponent(lynd, {screen: screen});
            return new UfoComponent(lynd, {screen: screen});
        }

        public function getMeteor(lynd:Lynd, screen:DisplayObjectContainer):MovementComponent
        {
            var selectIndex:int = int(String(_meteorPool.length * Math.random()).split(".")[0]);
            var res:int = _meteorPool.splice(selectIndex, 1)[0];
            if (_meteorPool.length == 0)
            {
                _meteorPool = [0, 0, 1];
            }
            if (res == 0)
                return new RightMeteorComponent(lynd, {screen: screen});
            return new LeftMeteorComponent(lynd, {screen: screen});
        }

//        public static function getQuest():Object
//        {
//            var selectIndex:int;
//            selectIndex = int(String(_nowQuests.length * Math.random()).split(".")[0]);
//            var res:Object = _nowQuests.splice(selectIndex, 1)[0];
//            _showQuest.push(res);
//            if (_nowQuests.length == 0)
//            {
//                selectIndex = int(String(_quests.length * Math.random()).split(".")[0]);
//                _nowQuests.push(_quests.splice(selectIndex, 1)[0]);
//            }
//            return res;
//        }
        public function getQuest(needQuest:Boolean):Object
        {
            var res:Object;
            if (!hasShowQuest(nowQuest.id) && needQuest)
                res = nowQuest;
            else if (!hasShowQuest(nextQuest.id))
                res = nextQuest;
            else
                res = randomGetQuest();
            _showQuest.push(res);
            return res;
        }

        public function selectQuest():void
        {


            if (nextQuest == null)
            {
                nowQuest = randomGetQuest();
                saveUsed(nowQuest.id);
                nextQuest = randomGetQuest();
            }
            else
            {
                nowQuest = nextQuest;
                if (usedQuestNum() == Question.getQuestsNum() - 1)
                    clearUsedQuest();
                saveUsed(nowQuest.id);
                nextQuest = randomGetShowQuest();
            }


            util.playSound(nowQuest.sound);
            trace("nowQuest", nowQuest.key);
        }

        private function randomGetQuest():Object
        {
            var selectIndex:int;
            if (_quests.length == 0)
            {

                _quests = Question.getQuests(true);
//                clearUsedQuest();
                if (nowQuest != null && _quests.length > 1)
                    _quests.splice(nowQuest.id, 1);
            }
            selectIndex = int(String(_quests.length * Math.random()).split(".")[0]);
            return _quests.splice(selectIndex, 1)[0];
        }

        private function hasShowQuest(id:int):Boolean
        {
            for (var i:int = 0; i < _showQuest.length; i++)
            {
                if (_showQuest[i].id == id)
                    return true;
            }
            return false;
        }

        private function randomGetShowQuest():Object
        {
            var takeQuest:Array = [];
            for (var i:int = 0; i < _showQuest.length; i++)
            {
                if (!checkUsed(_showQuest[i].id) && _showQuest[i].id != nowQuest.id)
                    takeQuest.push(_showQuest[i]);
            }

            if (takeQuest.length > 0)
            {
                var selectIndex:int;
                selectIndex = int(String(takeQuest.length * Math.random()).split(".")[0]);
                return takeQuest.splice(selectIndex, 1)[0];
            }
            else
            {
                return randomGetQuest();
            }
        }

        private function clearUsedQuest():void
        {
            for (var i:* in _usedQuestDict)
            {
                _usedQuestDict[i] = null;
                delete  _usedQuestDict[i];
            }
        }

        private function saveUsed(id:int):void
        {
            _usedQuestDict[id] = true;
        }

        private function checkUsed(id:int):Boolean
        {
            if (_usedQuestDict[id] != null)
                return true;
            return false;
        }

        private function usedQuestNum():int
        {
            var count:int = 0;
            for (var i:* in _usedQuestDict)
            {
                count++;
            }
            return count;
        }

//        public static function selectQuest():void
//        {
//            var selectIndex:int;
//            var i:int;
//            var max:int;
//            max = 5 - _nowQuests.length;
//            if (_quests.length < max)
//            {
//                _quests = Question.GetQuests(true);
//                for (i = 0; i < _nowQuests.length; i++)
//                {
//                    _quests.splice(_nowQuests[i].id, 1);
//                }
//            }
//            if (nowQuest != null)
//            {
//                for (i = 0; i < _showQuest.length; i++)
//                {
//                    if (_showQuest[i].id == nowQuest.id)
//                    {
//                        _showQuest.splice(i, 1);
//                    }
//                }
//                nowQuest = null;
//            }
//
//            if (_showQuest.length == 0)
//            {
//                max = 5 - _nowQuests.length;
//                for (i = 0; i < max; i++)
//                {
//                    selectIndex = int(String(_quests.length * Math.random()).split(".")[0]);
//                    _nowQuests.push(_quests.splice(selectIndex, 1)[0]);
//                }
//                selectIndex = int(String(_nowQuests.length * Math.random()).split(".")[0]);
//                nowQuest = _nowQuests[selectIndex];
//            }
//            else
//            {
//
//                selectIndex = int(String(_showQuest.length * Math.random()).split(".")[0]);
//                nowQuest = _showQuest[selectIndex];
//            }
//
//            util.playSound(nowQuest.sound);
//            trace("nowQuest", nowQuest.key);
//        }

        public function backQuest(quest:Object):void
        {
            removeShowQuest(quest);

            if (quest.id != nextQuest.id && quest.id != nowQuest.id)
            {
                var check:Boolean = false;
                for (var i:int = 0; i < _quests.length; i++)
                {
                    if (_quests[i].id == quest.id)
                    {
                        check = true;
                        break;
                    }
                }
                if (!check)
                    _quests.push(quest);
            }

        }

        public function removeShowQuest(quest:Object):void
        {
            for (var i:int = 0; i < _showQuest.length; i++)
            {
                if (_showQuest[i].id == quest.id)
                {
                    _showQuest.splice(i, 1);
                    break;
                }
            }
        }

        public function getShowNum():int
        {
            return _showQuest.length;
        }

        public function repeatQuest():void
        {
            util.playSound(nowQuest.sound);
        }

    }
}
