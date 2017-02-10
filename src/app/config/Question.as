/**
 * Created by zear19st on 2017/2/8.
 */
package app.config
{
    import lyndcomp.Lynd;

    public class Question
    {
        public function Question()
        {
        }

        private static const _folder:String = "question\\";
        private static var _quests:Array = [];

        public static function addQuestion(lynd:Lynd):Boolean
        {

            if (lynd.extra.canBeUsed())
            {
                var classFolder:String = lynd.extra.getCMDParams(1);
                if (classFolder != "")
                    classFolder += "\\";
                var realPath:String = lynd.extra.getPath() + _folder + classFolder;

                var check:Boolean = lynd.extra.folderExists(realPath);
                if (check)
                {
                    var files:Array = lynd.extra.getFileList(realPath, "*.mp3");
                    _quests = [];
                    for (var i:int = 0; i < files.length; i++)
                    {
                        _quests.push({id: i, key: files[i].replace(".mp3", ""), sound: realPath + files[i]});
                    }
                    return true;
                }
            }
            else
            {
                _quests = [];
                _quests.push({id: 0, key: "net", sound: "question\\class3\\net.mp3"});
                _quests.push({id: 1, key: "nose", sound: "question\\class3\\nose.mp3"});
                _quests.push({id: 2, key: "nut", sound: "question\\class3\\nut.mp3"});
                _quests.push({id: 3, key: "pencil", sound: "question\\class3\\pencil.mp3"});
                _quests.push({id: 4, key: "pig", sound: "question\\class3\\pig.mp3"});
                _quests.push({id: 5, key: "pizza", sound: "question\\class3\\pizza.mp3"});
                _quests.push({id: 6, key: "toy", sound: "question\\class3\\toy.mp3"});
                _quests.push({id: 7, key: "turtle", sound: "question\\class3\\turtle.mp3"});
//                _quests.push({id: 8, key: "under", sound: "question\\class3\\under.mp3"});
//                _quests.push({id: 9, key: "up", sound: "question\\class3\\up.mp3"});
//                _quests.push({id: 10, key: "van", sound: "question\\class3\\van.mp3"});
//                _quests.push({id: 11, key: "vase", sound: "question\\class3\\vase.mp3"});
//                _quests.push({id: 12, key: "yogurt", sound: "question\\class3\\yogurt.mp3"});
//                _quests.push({id: 13, key: "yo-yo", sound: "question\\class3\\yo-yo.mp3"});
//                _quests.push({id: 14, key: "zero", sound: "question\\class3\\zero.mp3"});
//                _quests.push({id: 15, key: "zoo", sound: "question\\class3\\zoo.mp3"});
            }
            return true;
        }

        public static function getQuestsNum():int
        {
            return _quests.length;
        }

        public static function getQuests(isQuest:Boolean):Array
        {
            var res:Array = [];
            for (var i:int = 0; i < _quests.length; i++)
            {
                res.push({id: _quests[i].id, key: _quests[i].key, sound: _quests[i].sound, flag: isQuest});
            }
            return res;
        }
    }
}
