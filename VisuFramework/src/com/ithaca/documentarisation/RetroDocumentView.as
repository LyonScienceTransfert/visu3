package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.RetroDocument;
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.documentarisation.renderer.SegmentCommentAudioRenderer;
import com.ithaca.documentarisation.renderer.SegmentTitleRenderer;
import com.ithaca.documentarisation.renderer.SegmentVideoRenderer;
import com.ithaca.timeline.ObselSkin;
import com.ithaca.traces.Obsel;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.utils.ShareUserTitleWindow;
import com.ithaca.utils.components.IconButton;
import com.ithaca.visu.events.UserEvent;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.model.User;
import com.ithaca.visu.model.vo.RetroDocumentVO;
import com.ithaca.visu.traces.TracageEventDispatcherFactory;
import com.ithaca.visu.traces.events.TracageEvent;
import com.ithaca.visu.ui.utils.IconEnum;
import com.ithaca.visu.ui.utils.RoleEnum;
import com.ithaca.visu.view.video.VisuVisioAdvanced;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.ByteArray;
import flash.utils.Timer;

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

import mx.collections.ArrayCollection;
import mx.collections.IList;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Menu;
import mx.controls.PopUpButton;
import mx.core.ClassFactory;
import mx.core.DragSource;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.events.MenuEvent;
import mx.graphics.ImageSnapshot;
import mx.managers.DragManager;
import mx.managers.PopUpManager;

import spark.components.BorderContainer;
import spark.components.Label;
import spark.components.List;
import spark.components.TextInput;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.TextOperationEvent;

public class RetroDocumentView extends SkinnableComponent
{
    [SkinState("normal")]
    [SkinState("edited")]
    [SkinState("dropped")]
    
    
    [SkinPart("true")]
    public var titleDocument:Label;
    
    [SkinPart("true")]
    public var titleDocumentTextInput:TextInput;
    
    [SkinPart("true")]
    public var buttonSwitch:Button;
    
    [SkinPart("true")]
    public var buttonShare:IconButton;
    
    [SkinPart("true")]
    public var removeButton:Button;
    
    [SkinPart("true")]
    public var buttonMenuAddSegment:IconButton;
    
    [SkinPart("true")]
    public var groupSegment:List;
    
    [SkinPart("true")]
    public var dropContainer:BorderContainer;
    
    private var _labelRetroDocument:String;
    private var normal:Boolean = true;
    private var dropped:Boolean = false;
    private var retroDocumentChange:Boolean = false; 
    private var titleChange:Boolean = false; 
    private var _retroDocument:RetroDocument;
    private var _startDateSession:Number;
    private var _durationSession:Number;
    private var timer:Timer;
    private var needUpdateRetroDocument:Boolean = false;
    private var _profiles:Array;
    private var _listUser:Array;
    private var _listUsersPresentOnTimeLine:Array;
    private var _buttonEnabled:Boolean = true;
    private var idRetroDocumentChange:Boolean;
    private var _updatedIdRetroDocument:int = 0;
    
    private var removingSegment:Segment;
    private var removingSegementView:RetroDocumentSegment;
    private var TIME_UPDATE_RETRODOCUMENT:Number = 1000;
    private var DELTA_X_MENU_ADD_SEGMENT:Number = -150;
    private var DELTA_Y_MENU_ADD_SEGMENT:Number = 22;
    // default duration segmen/block video in ms.
    private var DEFAULT_DURATION_SEGMENT_VIDEO:Number = 10*1000;
    // min. duration segment/block video
    private var MIN_DURATION_SEGMENT_VIDEO:Number = 1*1000;
    
    private var _currentTime:Number;
    
    private var _dragOwnerObject:Object;
    
    // tracege interval in ms
    private var TRACAGE_INTERVAL:Number = 10*1000;
    // timer the trasage
    private var _tracageTimer:Timer;   
    // init title retro document
    private var _tracedTitle:String;
    
    [Bindable]
    private var fxgt:_FxGettext;
    
    public function RetroDocumentView()
    {
        super();
        _listUser = new Array();
        fxgt = FxGettext;

        this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
      //  this.addEventListener(FocusEvent.FOCUS_OUT, onRemoveFromStage);
    }
    public function updateIdRetroDocument(value:int):void
    {
        // change id retro document, id was 0
        _updatedIdRetroDocument = value;
        _buttonEnabled = true;
        idRetroDocumentChange = true;
        invalidateProperties();
    }
    
    public function get retroDocument():RetroDocument
    {
        return _retroDocument;
    }
    public function set retroDocument(value:RetroDocument):void
    {
        _retroDocument = value;
        retroDocumentChange = true;
        invalidateProperties();
    }
    public function get titleDocumentText():String
    {
        return _labelRetroDocument;
    };
    public function set startDateSession(value:Number):void{_startDateSession = value;};
    public function get startDateSession():Number{return _startDateSession;};
    public function set durationSession(value:Number):void{_durationSession = value;};
    public function get durationSession():Number{return _durationSession;};
    public function set listShareUser(value:Array):void{_listUser = value;};
    public function get listShareUser():Array{return _listUser;};
    public function set profiles(value:Array):void
    {
        this._profiles = value;
    }
    public function get listUsersPresentOnTimeLine():Array{return _listUser;};
    public function set listUsersPresentOnTimeLine(value:Array):void
    {
        this._listUsersPresentOnTimeLine = value;
    }
    public function set allUsers(value:Array):void
    {
        var listUserShow:Array = this.getListUserShow(value);
        var shareUser:ShareUserTitleWindow = ShareUserTitleWindow(PopUpManager.createPopUp( 
            this, ShareUserTitleWindow , true) as spark.components.TitleWindow);
        shareUser.addEventListener(UserEvent.SELECTED_USER, onSelectUser);
        shareUser.x = (this.parentApplication.width - shareUser.width)/2;
        shareUser.y = (this.parentApplication.height - shareUser.height)/2;		
        shareUser.shareUserManagement.listShareUser = listShareUser;
        shareUser.shareUserManagement.users = listUserShow;
        shareUser.shareUserManagement.profiles = _profiles;
        // exemple of the link : http://visu-tutorat.org/visudev/visuclient.html?module=bilan&bilanId=135
        var urlBilan:String = Model.getInstance().urlServeur+"/visuclient.html?module=bilan&bilanId="+this.retroDocument.id.toString();
        shareUser.shareUserManagement.urlBilan = urlBilan;
    }
    public function set currentTime(value:Number):void
    {
        _currentTime = value;
    };
    public function set dragOwnerObject(value:Object):void
    {
        _dragOwnerObject = value;
    }
    public function get dragOwnerObject():Object
    {
        return _dragOwnerObject;
    }
    
    //_____________________________________________________________________
    //
    // Overriden Methods
    //
    //_____________________________________________________________________
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        if(instance == buttonSwitch)
        {
            buttonSwitch.addEventListener(MouseEvent.CLICK, onClickButtonSwitch);	
            buttonSwitch.toolTip = fxgt.gettext("Visualiser ce bilan");
            buttonSwitch.enabled =  this._buttonEnabled;
        }
        if (instance == buttonShare)
        {
            buttonShare.addEventListener(MouseEvent.CLICK, onClickButtonShare);
            buttonShare.icon =  IconEnum.getIconByName('retroDocumentShared');
            buttonShare.toolTip = "Partager ce bilan";
            buttonShare.enabled =  this._buttonEnabled;
        }
        if(instance == removeButton)
        {
            removeButton.addEventListener(MouseEvent.CLICK, onRemoveDocument);	
            removeButton.toolTip = fxgt.gettext("Supprimer ce bilan");
            removeButton.includeInLayout = removeButton.visible = false;
            removeButton.enabled =  this._buttonEnabled;
        }
        if(instance == buttonMenuAddSegment)
        {
            buttonMenuAddSegment.addEventListener(MouseEvent.CLICK, onClickButtonMenuAddSegment);
            buttonMenuAddSegment.toolTip = fxgt.gettext("Ajouter un nouveau bloc");
            buttonMenuAddSegment.enabled =  this._buttonEnabled;
        }
        
        if(instance == titleDocument)
        {
            titleDocument.text = _labelRetroDocument;
        }
        
        if(instance == titleDocumentTextInput)
        {
            titleDocumentTextInput.text = _labelRetroDocument;
            titleDocumentTextInput.addEventListener(TextOperationEvent.CHANGE, titleDocumentTextInput_changeHandler);
            titleDocumentTextInput.addEventListener(FlexEvent.CREATION_COMPLETE, onCreatioCompleteTextInput);
        }	
        if(instance == groupSegment)
        {
            //groupSegment.dataProvider = listSegment;
            groupSegment.dataProvider = this._retroDocument.listSegment;
            groupSegment.itemRendererFunction = function(item:Object):ClassFactory
            {
                var className:Class = SegmentTitleRenderer;
                
                if(item.typeSource == RetroDocumentConst.COMMENT_AUDIO_SEGMENT)
                {
                    className = SegmentCommentAudioRenderer;
                }else
                    if(item.typeSource == RetroDocumentConst.VIDEO_SEGMENT)
                    {
                        className = SegmentVideoRenderer;
                    }
                return new ClassFactory( className);
            };
            
            groupSegment.addEventListener(RetroDocumentEvent.CHANGE_RETRO_SEGMENT, onChangeRetroSegment, true);
            groupSegment.addEventListener(RetroDocumentEvent.PRE_REMOVE_SEGMENT, onRmoveSegment, true);
            
            groupSegment.addEventListener(RetroDocumentEvent.READY_TO_DRAG_DROP_SEGMENT, onReadyToDragSegment, true);
            groupSegment.addEventListener(DragEvent.DRAG_COMPLETE, onDragCompleteSegment);
            // set listener on Tutorat Module
            dragOwnerObject.addEventListener(RetroDocumentEvent.READY_TO_DRAG_DROP_OBSEL, onReadyToDragObsel);
            dragOwnerObject.addEventListener(RetroDocumentEvent.STOP_TO_DRAG_DROP_OBSEL, onStopToDragObsel);
        }
        
        if(instance == dropContainer)
        {
            dropContainer.addEventListener(DragEvent.DRAG_DROP, onDropObsel);
            dropContainer.addEventListener(DragEvent.DRAG_ENTER, onDragEnterObsel);
        }
    }
    
    public function setEditabled(value:Boolean):void
    {
        normal = !value;
        this.invalidateSkinState();
        startTimer();
    }
    
    private function startTimer():void
    {
        if(!timer)
        {
            timer = new Timer(TIME_UPDATE_RETRODOCUMENT,0);
            timer.addEventListener(TimerEvent.TIMER, checkUpdateSegment);
        }
        timer.start();
    }
    private function checkUpdateSegment(event:TimerEvent):void
    {
        if(needUpdateRetroDocument)
        {
            needUpdateRetroDocument = false;
            updateRetroDocument();
        }
    }
    override protected function getCurrentSkinState():String
    {
        var result:String = "";
        if(normal)
        {
            result = "normal";
            // stop tracage timer
            stopTracageTimer();
        }else if(dropped)
        {
            result ="dropped";
        }else
        {
            result = "edited";
            // start tracage timer
            startTracageTimer();
        }
        return result;
    }
    
    override protected function commitProperties():void
    {
        super.commitProperties();
        if(retroDocumentChange)
        {
            retroDocumentChange = false;
            // init raced Title
            _tracedTitle = this._retroDocument.title;
            // set label retro document
            _labelRetroDocument = this._retroDocument.title;
            // set list segments
            groupSegment.dataProvider = this._retroDocument.listSegment;
            
            if(titleDocument != null)
            {
                this.titleDocument.text  = this._labelRetroDocument;
            }
            if(titleDocumentTextInput != null)
            {
                this.titleDocumentTextInput.text  = this._labelRetroDocument;
            }
            // set buttons disabled for new retro document
            if(this._retroDocument.id == 0)
            {
                this._buttonEnabled = false;
                if(_updatedIdRetroDocument > 0)
                {
                    this._retroDocument.id = _updatedIdRetroDocument;
                    this._buttonEnabled = true;
                    _updatedIdRetroDocument = 0;
                }
            }else
            {
                _updatedIdRetroDocument = 0;
            }
        }
        
        if(idRetroDocumentChange)
        {
            idRetroDocumentChange = false;
            if(buttonSwitch)
            {
                buttonSwitch.enabled = this._buttonEnabled;
            }
            if(buttonShare)
            {
                buttonShare.enabled = this._buttonEnabled;
            }
            if(removeButton)
            {
                removeButton.enabled = this._buttonEnabled;
            }
            if(buttonMenuAddSegment)
            {
                buttonMenuAddSegment.enabled = this._buttonEnabled;
            }   
            if(_retroDocument.id == 0)
            {
                _retroDocument.id = _updatedIdRetroDocument;
                this._buttonEnabled = true;
            }
        }
    }
    
    //_____________________________________________________________________
    //
    // Listeners
    //
    //_____________________________________________________________________	
  
    private function onRemoveFromStage(event:Event = null):void
    {
        checkTracage();
        // stop tracage timer
        stopTracageTimer();
    }
    
    /**
     * check tracage modification the retro document
     */
    private function checkTracage(event:* = null):void
    {
        trace("check tracage retro document => "+this.retroDocument.id);
        
        // check modifications the comment
        if(retroDocument.title != _tracedTitle)
        {
            // tracage modifications the audio block
            var retroDocumentTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT);
            retroDocumentTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_EDIT_TITLE;
            retroDocumentTracageEvent.retroDocumentId = retroDocument.id;
            retroDocumentTracageEvent.title= retroDocument.title;
            TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(retroDocumentTracageEvent);
            
            _tracedTitle = retroDocument.title;
        }
    }
    
    private function onClickButtonSwitch(event:MouseEvent):void
    {	
        checkTracage();
        
        var clickButtonSwitchEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CLICK_BUTTON_SWITCH);
        clickButtonSwitchEvent.idRetroDocument = retroDocument.id;
        clickButtonSwitchEvent.sessionId = retroDocument.sessionId;
        dispatchEvent(clickButtonSwitchEvent);
        
        // tracage view retrodocument
        var retroDocumentViewTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT);
        retroDocumentViewTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_VIEW;
        retroDocumentViewTracageEvent.retroDocumentId = _retroDocument.id;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(retroDocumentViewTracageEvent);
    }
    
    private function onClickButtonShare(event:MouseEvent):void
    {
        var loadListUsers:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.LOAD_LIST_USERS);
        this.dispatchEvent(loadListUsers);
    }
    
    private function onRemoveDocument(event:MouseEvent):void
    {
        checkTracage();
        
        Alert.yesLabel = fxgt.gettext("Oui");
        Alert.noLabel = fxgt.gettext("Non");
        Alert.show(fxgt.gettext("Êtes-vous sûr de vouloir supprimer le bilan intitulé "+'"'+this.retroDocument.title+'"'+" ?"),
            fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, removeRetroDocumentConformed); 
    }
    
    private function onClickButtonMenuAddSegment(event:MouseEvent):void
    {
        checkTracage();
        
        var dp:Object = [{label: fxgt.gettext(" Bloc titre "), typeSegment: "TitleSegment",  iconName : "iconLettre_T_16x16"}, 
            {label: fxgt.gettext("Bloc texte"), typeSegment: "TexteSegment" , iconName : "iconLettre_t_16x16"}, 
            {label: fxgt.gettext("Bloc vidéo + texte"), typeSegment: "VideoSegment", iconName : "iconVideo_16x16"},        
            {label: fxgt.gettext("Bloc commentaire audio"), typeSegment: "AudioSegment", iconName: "iconAudio_16x16"}];  
        var str:String = '<root><menuitem label="Bloc titre" iconName="iconLettre_T_16x16" typeSegment="TitleSegment"/><menuitem label="Bloc texte" iconName="iconLettre_t_16x16" typeSegment="TexteSegment"/><menuitem label="Bloc vidéo + texte" iconName="iconVideo_16x16" typeSegment="VideoSegment"/><menuitem label="Bloc commentaire audio" iconName="iconAudio_16x16" typeSegment="AudioSegment"/></root>'
        var xml:XML = new XML(str);
        
        var menuAddSegment:Menu = Menu.createMenu(null, xml, false);
        menuAddSegment.iconFunction = setIconMenuAddSegmentFunction;
        menuAddSegment.labelFunction= setLabelMenuAddSegmentFunction;
        menuAddSegment.addEventListener(MenuEvent.ITEM_CLICK, onClickMenuAddSegment);
        var iconButton:IconButton = event.target as IconButton;
        var pt:Point = new Point(iconButton.x, iconButton.y);
        pt = iconButton.localToGlobal(pt);
        var pointShowMenu:Point = new Point(pt.x - iconButton.x, pt.y - iconButton.y);
        menuAddSegment.show(pointShowMenu.x + DELTA_X_MENU_ADD_SEGMENT, pointShowMenu.y + DELTA_Y_MENU_ADD_SEGMENT);
    }
    
    private function setIconMenuAddSegmentFunction(item:Object):Class
    {
        var iconName:String = item.@iconName;
        return IconEnum.getIconByName(iconName);
    }
    private function setLabelMenuAddSegmentFunction(item:Object):String
    {
        var label:String = "        "+ item.@label;
        return label;
    }
    /**
     *  listener the PopUp button
     */
    private function onClickMenuAddSegment(event:MenuEvent):void
    {
        var segment:Segment;
        var typeSegment:String = event.item.@typeSegment;
        var sourceType:String;
        switch (typeSegment)
        {
        case "TitleSegment" :
            segment = new Segment(this._retroDocument);
            segment.order = 2;
            segment.comment = "";
            segment.typeSource = RetroDocumentConst.TITLE_SEGMENT;
            sourceType = RetroTraceModel.TITLE;
            break;
        case "TexteSegment" :
            segment = new Segment(this._retroDocument);
            segment.order = 2;
            segment.comment = "";
            segment.typeSource = RetroDocumentConst.TEXT_SEGMENT;
            sourceType = RetroTraceModel.TEXT;
            break;
        case "AudioSegment" :
            segment = new Segment(this._retroDocument);
            segment.order = 1;
            segment.typeSource = RetroDocumentConst.COMMENT_AUDIO_SEGMENT;
            sourceType = RetroTraceModel.AUDIO;
            segment.comment = "";
            segment.durationCommentAudio = 0;
            break;
        case "VideoSegment" :
            segment = new Segment(this._retroDocument);
            segment.order = 3;
            sourceType = RetroTraceModel.VIDEO;
            segment.typeSource = RetroDocumentConst.VIDEO_SEGMENT;
            segment.comment = "";
            
            segment.beginTimeVideo = this._startDateSession + _currentTime;
            segment.endTimeVideo = this._startDateSession + _currentTime + DEFAULT_DURATION_SEGMENT_VIDEO;
            // screen-shot the video
            // FIXME : have to add bean on server side => lost key-frame in flv, look at https://github.com/ithaca/visu/issues/163
            // segment.byteArray = screenShotVisuVideo();
            
            break;
        }
        // add segment
        addSegment(segment , RetroTraceModel.MENU, null, sourceType);
    }
    
    // by default add text segment
    private function onClickButtonAddSegment(event:MouseEvent):void
    {
        var segment:Segment = new Segment(this._retroDocument);
        segment.order = 2;
        segment.comment = "";
        segment.typeSource = RetroDocumentConst.TEXT_SEGMENT;
        // add segment
        addSegment(segment, null, null, null);
    }
    
    private function addSegment(value:Segment, createType:String, obsel:Obsel, sourceType:String):void
    {
        // set updated listSegment
        _retroDocument.listSegment.addItem(value);
        groupSegment.dataProvider = _retroDocument.listSegment;
        
        // update retroDocument
        updateRetroDocument();
        
        // notify change list segment 
        notifyChangeListSegment();
        
        // tracage add block
        var retroDocumentAddBlockTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        retroDocumentAddBlockTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_CREATE;
        retroDocumentAddBlockTracageEvent.id = value.segmentId;
        retroDocumentAddBlockTracageEvent.createType = createType;
        retroDocumentAddBlockTracageEvent.sourceType = sourceType;
        retroDocumentAddBlockTracageEvent.obsel = obsel;
        
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(retroDocumentAddBlockTracageEvent);
    }
    
    private function notifyChangeListSegment():void
    {
        var xml:String = _retroDocument.getRetroDocumentXMLtoSTRING();
        var updateListSegmentRetroDocument:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CHANGE_LIST_RETRO_SEGMENT);
        updateListSegmentRetroDocument.xmlRetrodocument = xml;
        dispatchEvent(updateListSegmentRetroDocument);
    }
    
    private function onUpdateGroupeSegmentComplete(event:FlexEvent):void
    {
        // get index added segment
        var indexAddedSegment:int = this._retroDocument.listSegment.length - 1;
        groupSegment.selectedIndex = indexAddedSegment;
    }
    private function onRmoveSegment(event:RetroDocumentEvent):void
    {
        removingSegment = event.segment;
        
        Alert.yesLabel = fxgt.gettext("Oui");
        Alert.noLabel = fxgt.gettext("Non");
        Alert.show(fxgt.gettext("Êtes-vous sûr de vouloir supprimer ce segment ?"),
            fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, removeSegmentConformed); 
    }
    private function removeSegmentConformed(event:CloseEvent):void
    {
        if( event.detail == Alert.YES)
        {
            var indexSegment:int = -1;
            var listSegment:ArrayCollection = this.retroDocument.listSegment as ArrayCollection;
            var nbrSegment:int = listSegment.length;
            for(var nSegment:int = 0 ; nSegment < nbrSegment ; nSegment++)
            {
                var segment:Segment = listSegment.getItemAt(nSegment) as Segment;
                if(segment == removingSegment)
                {
                    indexSegment = nSegment;
                }
            }
            if(indexSegment < 0)
            {
                Alert.show("you havn't segment for delete","bug message...");
            }else
            {
                listSegment.removeItemAt(indexSegment);
                // update the retroDocument
                this.updateRetroDocument();
                // notify change list segment
                notifyChangeListSegment();
            }
            
            // tracage removing segment
            var retroDocumentDeleteTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
            retroDocumentDeleteTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_DELETE;
            retroDocumentDeleteTracageEvent.id = removingSegment.segmentId;
            retroDocumentDeleteTracageEvent.serialisation = removingSegment.getSegmentXML();
            TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(retroDocumentDeleteTracageEvent);
            
        }
    }
    protected function titleDocumentTextInput_changeHandler(event:TextOperationEvent):void
    {
        this._labelRetroDocument = titleDocumentTextInput.text;
        _retroDocument.title = this._labelRetroDocument;
        this.needUpdateRetroDocument = true;
        // update title retroRocument
        var updateTitleRetroDocument:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.UPDATE_TITLE_RETRO_DOCUMENT);
        updateTitleRetroDocument.idRetroDocument = _retroDocument.id;
        updateTitleRetroDocument.titleRetrodocument = _retroDocument.title;
        this.dispatchEvent(updateTitleRetroDocument);
    }
    private function onCreatioCompleteTextInput(event:FlexEvent):void
    {
        // set focus and select title retroDocument
        this.titleDocumentTextInput.selectAll();
        this.stage.focus = this.titleDocumentTextInput;
    }
    
    private function onChangeRetroSegment(event:RetroDocumentEvent):void
    {
        this.needUpdateRetroDocument = true;
    }
    
    ////////////////
    ///// Listeners for drag-drop the segments/bloks
    ///////////////
    private function onReadyToDragSegment(event:RetroDocumentEvent):void
    {
        setDragDropEnabled(true);
    }
    private function onDragCompleteSegment(event:DragEvent):void
    {
        setDragDropEnabled(false);
        needUpdateRetroDocument = true;
        
        // tracage order the blocks
        var retroDocumentOrderTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT);
        retroDocumentOrderTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_EDIT_BLOCK_ORDER;
        retroDocumentOrderTracageEvent.retroDocumentId = retroDocument.id;
        
        var arr:Array = new Array();
        var listSegment:IList = retroDocument.listSegment;
        var nbrSegment:int = listSegment.length;
        for(var nSegment:int = 0 ; nSegment < nbrSegment; nSegment++)
        {
            var segment:Segment = listSegment.getItemAt(nSegment) as Segment;
            arr[nSegment] = segment.segmentId;
        }
        
        retroDocumentOrderTracageEvent.newOrder = arr;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(retroDocumentOrderTracageEvent);
        
    }
    
    ////////////////
    ///// Listeners for Obsel the TimeLine
    ///////////////
    private function onReadyToDragObsel(event:RetroDocumentEvent):void
    {
        if(event.value is ObselSkin)
        {
            var dragInitiator:ObselSkin = ObselSkin(event.value);
            var ds:DragSource = new DragSource();
            ds.addData(dragInitiator, "obselSkin");               
            
            var objectProxy:Label = new Label(); 
            objectProxy.maxDisplayedLines = 6;
            objectProxy.width = 100; 
            objectProxy.text ="Vous pouver deplacer l'obsel vers la " +
                "bilan pour ajouter dans la liste des segments block vidéo"
            
            //objectProxy.obselSkin = dragInitiator;
            DragManager.doDrag(dragInitiator, ds, event.event as MouseEvent, 
                objectProxy);
            // set dropped skin
            dropped  = true;
            invalidateSkinState();
        }
    }
    
    private function onDragEnterObsel(event:DragEvent):void
    {
        if (event.dragSource.hasFormat("obselSkin"))
        {
            DragManager.acceptDragDrop(BorderContainer(event.currentTarget));
        }
    }
    
    private function onDropObsel(event:DragEvent):void
    {
        var segment:Segment = new Segment(this._retroDocument);
        segment.order = 3;
        segment.typeSource = RetroDocumentConst.VIDEO_SEGMENT;
        var obselSkin:ObselSkin = event.dragInitiator as ObselSkin;
        var obsel:Obsel = obselSkin.obsel;
        // set text obselSkin, toolTips
        var textObsel:String = obselSkin.toolTip;
        segment.comment = textObsel;
        segment.beginTimeVideo = obsel.begin;
        // check if duration > 0
        var duration:Number = obsel.end - obsel.begin;
        if(duration < MIN_DURATION_SEGMENT_VIDEO)
        {
            duration = DEFAULT_DURATION_SEGMENT_VIDEO; 
        }
        segment.endTimeVideo = segment.beginTimeVideo + duration;
        // screen-shot VideoPanel
        // FIXME : have to add bean on server side => lost key-frame in flv, look at https://github.com/ithaca/visu/issues/163
        // segment.byteArray = screenShotVisuVideo()
        // add segment
        addSegment(segment, RetroTraceModel.DRAG_DROP, obsel, RetroTraceModel.VIDEO);
    }
    
    /**
     * stop dragging
     */
    private function onStopToDragObsel(event:RetroDocumentEvent):void
    {
        // set dropped skin
        dropped  = false;
        invalidateSkinState();
    }
    //_____________________________________________________________________
    //
    //  Dispatchers
    //
    //_____________________________________________________________________	
    // update retroDocument
    private function updateRetroDocument(event:*=null):void
    {
        var retroDocumentVO:RetroDocumentVO = new RetroDocumentVO();
        retroDocumentVO.documentId = _retroDocument.id;
        retroDocumentVO.title = _retroDocument.title;
        retroDocumentVO.description = _retroDocument.description;
        retroDocumentVO.ownerId = _retroDocument.ownerId;
        var xml:String = _retroDocument.getRetroDocumentXMLtoSTRING();
        retroDocumentVO.xml = xml;
        retroDocumentVO.sessionId = _retroDocument.sessionId;
        var updateRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PRE_UPDATE_RETRO_DOCUMENT);
        updateRetroDocumentEvent.retroDocumentVO = retroDocumentVO;
        updateRetroDocumentEvent.listUser = this._listUser;
        this.dispatchEvent(updateRetroDocumentEvent);
    }
    // remove retroDocument
    private function removeRetroDocumentConformed(event:CloseEvent):void
    {
        if( event.detail == Alert.YES)
        {
            var removeRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.DELETE_RETRO_DOCUMENT);
            removeRetroDocumentEvent.idRetroDocument = this._retroDocument.id;
            removeRetroDocumentEvent.sessionId = this._retroDocument.sessionId;
            this.dispatchEvent(removeRetroDocumentEvent);
            
            
        }
    }
    
    //_____________________________________________________________________
    //
    //  Utils
    //
    //_____________________________________________________________________	
    
    private function startTracageTimer():void
    {
        if(!_tracageTimer)
        {
            _tracageTimer = new Timer(this.TRACAGE_INTERVAL,0);
            _tracageTimer.addEventListener(TimerEvent.TIMER, checkTracage);
        }
        _tracageTimer.start();
    }
    private function stopTracageTimer():void
    {
        if(_tracageTimer && _tracageTimer.running)
        {
            // check tracage if user deselected segment
            checkTracage();
            _tracageTimer.stop();
        }
    }
    private function getListUserShow(value:Array):Array
    {
        var result:Array = new Array();
        var nbrUser:int = value.length;
        for(var nUser:int= 0; nUser < nbrUser ; nUser++)
        {
            var user:User = value[nUser];
            if(user.id_user != _retroDocument.ownerId)
            {
                // add all admins
                if(user.role > RoleEnum.RESPONSABLE-1)
                {
                    result.push(user);
                }else
                {
                    // add only users was recording
                    var hasUser:Boolean = hasUserInSession(user.id_user, this._listUsersPresentOnTimeLine)
                    if(hasUser)
                    {
                        result.push(user);
                    }		
                }
            }
        }
        return result;
        
        function hasUserInSession(id:int, list:Array):Boolean
        {
            var nbrUser:int = list.length;
            for(var nUser:int = 0 ; nUser < nbrUser; nUser++)
            {
                var userId:int = list[nUser];
                if (id == userId)
                {
                    return true;
                }
            }
            return false;
        }
    }
    private function onSelectUser(event:UserEvent):void
    {
        this._listUser = event.listUser;
        // tracage list shared users
        var retroDocumentSharedTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT);
        retroDocumentSharedTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_EDIT_SHARE;
        retroDocumentSharedTracageEvent.retroDocumentId = retroDocument.id;
        
        var arr:Array = new Array();
        var nbrUser:int = _listUser.length;
        for(var nUser:int = 0 ; nUser < nbrUser; nUser++)
        {
            var user:Object = _listUser[nUser];
            arr.push(user.toString());
        }
        
        retroDocumentSharedTracageEvent.userList = arr;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(retroDocumentSharedTracageEvent);
        
        // update retroDocument
        updateRetroDocument();
    }
    
    private function setDragDropEnabled(value:Boolean):void
    {
        groupSegment.dragEnabled = value;
        groupSegment.dragMoveEnabled = value;
        groupSegment.dropEnabled = value;
    }
    
    /**
     * screen-shot the VisuVideo
     */
    private function screenShotVisuVideo():ByteArray
    {
        var visuVisioAdvansed:VisuVisioAdvanced = dragOwnerObject.visio as VisuVisioAdvanced;
        var imageSnap:ImageSnapshot = ImageSnapshot.captureImage(visuVisioAdvansed);
        var imageByteArray:ByteArray = imageSnap.data as ByteArray;
        return imageByteArray;
    }
    
}
}