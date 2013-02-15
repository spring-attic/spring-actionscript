/*
    Adobe Systems Incorporated(r) Source Code License Agreement
    Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
    
    Please read this Source Code License Agreement carefully before using
    the source code.
    
    Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
    no-charge, royalty-free, irrevocable copyright license, to reproduce,
    prepare derivative works of, publicly display, publicly perform, and
    distribute this source code and such derivative works in source or 
    object code form without any attribution requirements.  
    
    The name "Adobe Systems Incorporated" must not be used to endorse or promote products
    derived from the source code without prior written permission.
    
    You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
    against any loss, damage, claims or lawsuits, including attorney's 
    fees that arise or result from your use or distribution of the source 
    code.
    
    THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
    ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
    BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
    NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL ADOBE 
    OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
    EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
    OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
    WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
    OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
    ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.adobe.air.alert
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.NativeWindow;
    import flash.display.NativeWindowInitOptions;
    import flash.display.NativeWindowSystemChrome;
    import flash.display.NativeWindowType;
    import flash.display.Screen;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import flash.events.NativeWindowBoundsEvent;
    import flash.filters.BlurFilter;
    import flash.geom.Rectangle;
    import flash.desktop.NativeApplication;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.ui.ContextMenu;
    import flash.utils.Dictionary;    
    
	[Event(name=AlertEvent.ALERT_CLOSED_EVENT, type="com.adobe.air.alert.AlertEvent")]

	public class NativeAlert
		extends NativeWindow
	{
	    public static const YES:uint = 0x0001;
	    public static const NO:uint = 0x0002;
	    public static const OK:uint = 0x0004;
	    public static const CANCEL:uint= 0x0008;

		private var sprite: Sprite;
		private var text: String;
		private var alertTitle: String;
		private var parentWindow:NativeWindow;
		private var modal:Boolean;
		private var textField: TextField;
		private var titleText: TextField;
		private const btn_space: uint = 10;
		private var closeHandler: Function =  null;
	    private var buttonFlags:uint = OK;
		private var buttons:Array = [];
		private var msgIcon: Bitmap;
		private var curtains:Dictionary;

        public function NativeAlert()
        {
            super(this.getWinOptions());
			this.createBackGround()
            this.visible = false;
			this.alwaysInFront = true;
	    }

		private function addCurtains():void
		{
			this.curtains = new Dictionary();
			for each (var openWin:NativeWindow in NativeApplication.nativeApplication.openedWindows)
			{
				if (openWin is NativeAlert) continue;
				var curtain:Sprite = new Sprite();
				curtain.alpha = .1;
				curtain.x = 0;
				curtain.y = 0;
				curtain.graphics.clear();
	            curtain.graphics.beginFill(0x000000);
	            curtain.graphics.drawRect(0, 0, openWin.width, openWin.height);
	            curtain.graphics.endFill();
				this.curtains[openWin] = {"curtain":curtain};
				openWin.addEventListener(NativeWindowBoundsEvent.RESIZING, resizeCurtain);
				openWin.stage.addChild(curtain);
				if (openWin.stage.numChildren > 0 && openWin.stage.getChildAt(0) != null)
				{
					this.curtains[openWin].filters = openWin.stage.getChildAt(0).filters;
					openWin.stage.getChildAt(0).filters = [new BlurFilter()];
				}
			}
		}

		private function removeCurtains():void
		{
			for each (var openWin:NativeWindow in NativeApplication.nativeApplication.openedWindows)
			{
				if (openWin is NativeAlert) continue;
				if (this.curtains[openWin] != null)
				{
					openWin.stage.removeChild(this.curtains[openWin].curtain as Sprite);
					openWin.removeEventListener(NativeWindowBoundsEvent.RESIZING, resizeCurtain);
					if (openWin.stage.numChildren > 0 && openWin.stage.getChildAt(0) != null)
					{
						openWin.stage.getChildAt(0).filters = this.curtains[openWin].filters;
					}
				}
			}
			this.curtains = null;
		}

		private function resizeCurtain(e:NativeWindowBoundsEvent):void
		{
			var openWin:NativeWindow = e.target as NativeWindow;
			if (this.curtains[openWin] == null) return;
			var curtain:Sprite = this.curtains[openWin].curtain as Sprite;
			curtain.width = openWin.width;
			curtain.height = openWin.height;
		}

		protected function getWinOptions(): NativeWindowInitOptions
		{
            var result:NativeWindowInitOptions = new NativeWindowInitOptions();
            result.maximizable = false;
            result.minimizable = false;
            result.resizable = false;
            result.transparent = true;
            result.systemChrome = NativeWindowSystemChrome.NONE;
            result.type = NativeWindowType.LIGHTWEIGHT;
			return result;
		}

	    protected function createBackGround(): void
	    {
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();

			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.sprite = new Sprite();
			this.sprite.alpha = 1;
	    	this.sprite.contextMenu = cm;
			this.stage.addChild(this.sprite);
			this.sprite.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
	    }

	    private function onMouseDown(e:MouseEvent): void
	    {
	    	if (e.target is CustomSimpleButton) return;
	    	this.startMove();
	    }

		private function drawBackGround(): void
		{
			this.sprite.graphics.clear();
            this.sprite.graphics.beginFill(0x292929);
            this.sprite.graphics.drawRoundRect(0, 0, this.width, this.height, 10, 10);
            this.sprite.graphics.endFill();
		}

		public override function set height(newHeight: Number): void
		{
			super.height = newHeight;
			this.drawBackGround();
		}

		public override function set width(newWidth: Number): void
		{
			super.width = newWidth;
			this.drawBackGround();
		}

	    private function createTexts(): void
	    {
			if (!this.titleText)
			{
	            this.titleText = new TextField();
	            this.titleText.autoSize = TextFieldAutoSize.LEFT;
	            var titleFormat:TextFormat = this.titleText.defaultTextFormat;
	            titleFormat.font = "Verdana";
	            titleFormat.bold = true;
	            titleFormat.color = 0xFFFFFF;
	            titleFormat.size = 12;
				titleFormat.align = TextFormatAlign.LEFT;
	            this.titleText.defaultTextFormat = titleFormat;
	            this.titleText.multiline = false;
	            this.titleText.selectable = false;
	            this.titleText.wordWrap = false;
	            this.titleText.text = this.alertTitle;
	            this.sprite.addChild(this.titleText);
			}

	        if (!this.textField)
	        {
				this.textField = new TextField();
				this.textField.autoSize = TextFieldAutoSize.LEFT;
		        var textFormat: TextFormat = this.textField.defaultTextFormat;
		        textFormat.font = "Verdana";
		        textFormat.bold = false;
		        textFormat.color = 0xFFFFFF;
		        textFormat.size = 10;
				textFormat.align = TextFormatAlign.LEFT;
		        this.textField.defaultTextFormat = textFormat;
				this.textField.text = this.text;
				this.textField.multiline = true;
				this.textField.wordWrap = true;
				this.textField.text = this.text;
				this.textField.width = 200;
                this.sprite.addChild(this.textField);
	        }
	    }

		private function createButton(label: String, name: String): CustomSimpleButton
		{
			var button: CustomSimpleButton = new CustomSimpleButton(label);
			button.name = name;
			button.addEventListener(MouseEvent.CLICK, clickHandler);
			this.sprite.addChild(button);
			this.buttons.push(button);
			return button;
		}

		private function removeAlert(buttonPressed:String):void
		{	
			this.visible = false;
	
			var closeEvent: AlertEvent = new AlertEvent();
			if (buttonPressed == "YES")
				closeEvent.detail = NativeAlert.YES;
			else if (buttonPressed == "NO")
				closeEvent.detail = NativeAlert.NO;
			else if (buttonPressed == "OK")
				closeEvent.detail = NativeAlert.OK;
			else if (buttonPressed == "CANCEL")
				closeEvent.detail = NativeAlert.CANCEL;
			this.dispatchEvent(closeEvent);
			
			this.close();
		}

		public override function close():void
		{
			if (this.modal)
			{
				this.removeCurtains();
			}
			super.close();
		}

		private function clickHandler(event: MouseEvent): void
		{
			var name:String = CustomSimpleButton(event.currentTarget).name;
			removeAlert(name);
		}

		private function createChildren():void
		{	
			// Create the icon object, if any.
			if (this.msgIcon != null)
			{
				this.sprite.addChild(this.msgIcon);
			}
				
			// Create the UITextField to display the message.
			this.createTexts();

			var button: CustomSimpleButton;
	
			if (this.buttonFlags & NativeAlert.OK)
			{
				button = this.createButton("OK", "OK");
			}
	
			if (this.buttonFlags & NativeAlert.YES)
			{
				button = this.createButton("YES", "YES");
			}
	
			if (this.buttonFlags & NativeAlert.NO)
			{
				button = this.createButton("NO", "NO");
			}
	
			if (this.buttonFlags & NativeAlert.CANCEL)
			{
				button = this.createButton("CANCEL", "CANCEL");
			}

			this.height = this.titleText.height + Math.max(this.textField.height, this.msgIcon != null ? 50 : 0) + 5 + (this.btn_space * 3) + button.height;
			this.width = Math.max(this.titleText.width, (this.textField.width + (this.msgIcon != null ? 50 : 0)));
			this.width = Math.max(this.width, (this.buttons.length * button.width) + ((this.buttons.length - 1) * this.btn_space));
			this.width = this.width + (this.btn_space * 2);
			
			this.titleText.x = (this.width / 2) - (this.titleText.width / 2);
			this.titleText.y = 5;

			if (this.msgIcon != null)
			{
				var posX: int = 2;
				var posY: int = 2;
				var scaleX: Number = 1;
				var scaleY: Number = 1;
	            var bitmapData:BitmapData = this.msgIcon.bitmapData;
	            if (bitmapData.width > 50 || bitmapData.height > Math.max(this.textField.height, 50))
	            {
	            	var __x: int = bitmapData.width - 50;
	            	var __y: int = bitmapData.height - Math.max(this.textField.height, 50);
            		scaleX = (__x > __y) ? 50 / bitmapData.width : Math.max(this.textField.height, 50) / bitmapData.height;
	            	scaleY = scaleX;
	            	posX = 27 - ((bitmapData.width * scaleX) / 2);
	            	posY = 5 + this.titleText.height + this.btn_space + ((Math.max(this.textField.height, 50) / 2) + 2) - ((bitmapData.height * scaleY) / 2);
	            }
	            else
	            {
		            posX = 27 - (bitmapData.width / 2);
		            posY = 5 + this.titleText.height + this.btn_space + ((Math.max(this.textField.height, 50) / 2) + 2) - (bitmapData.height / 2);					
	            }
	            this.msgIcon.scaleX = scaleX;
	            this.msgIcon.scaleY = scaleY;
	            this.msgIcon.x = posX + 5;
	            this.msgIcon.y = (titleText.height + 5 + this.btn_space);
	            
			}
			this.textField.x = (this.msgIcon != null ? 50 : 0) + (((this.width - (this.msgIcon != null ? 50 : 0)) / 2) - (this.textField.width / 2));
			
			this.textField.y = 5 + this.titleText.height + this.btn_space;

			var btnTop: uint = this.height - (button.height + this.btn_space);
			var btnLeft: uint = (this.width / 2) - (((button.width * this.buttons.length) + (this.btn_space * (this.buttons.length - 1))) / 2);
			for (var x: int = 0; x < this.buttons.length; x++)
			{
				(this.buttons[x] as CustomSimpleButton).y = btnTop;
				(this.buttons[x] as CustomSimpleButton).x = btnLeft;
				btnLeft = btnLeft + button.width + this.btn_space;
			}
		}

	    public static function show(text:String = "",
	    							title:String = "",
	                                flags:uint = 0x4 /* Alert.OK */,
	                                modal:Boolean = true,
	                                parentWindow:NativeWindow = null,
	                                closeHandler:Function = null,
	                                icon: Bitmap = null): NativeAlert
	    {
	        var alert:NativeAlert = new NativeAlert();

	        if (flags & NativeAlert.OK ||
	            flags & NativeAlert.CANCEL ||
	            flags & NativeAlert.YES ||
	            flags & NativeAlert.NO)
	        {
	            alert.buttonFlags = flags;
	        }

	        alert.closeHandler = closeHandler;
	        alert.text = text;
	        alert.alertTitle = title;
	        alert.parentWindow = parentWindow;
	        alert.modal = modal;

	        if (icon != null)
	        {
				alert.msgIcon = new Bitmap(icon.bitmapData);
		    	alert.msgIcon.smoothing = true;
	        }
	        
	        alert.createChildren();

	        if (modal)
	        {
	        	alert.addCurtains();
	        }

			if (parentWindow != null)
			{
				parentWindow.activate();
				alert.bounds = new Rectangle((parentWindow.x) + ((parentWindow.width / 2) - (alert.width / 2)), (parentWindow.y) + (parentWindow.height / 4), alert.width, alert.height);
			}
			else
			{
				var s:Screen = Screen.mainScreen;
				alert.bounds = new Rectangle((s.bounds.width / 2) - (alert.width / 2), s.bounds.height / 4, alert.width, alert.height);
			}

			alert.visible = true;
			alert.activate();

	        if (closeHandler != null)
	        {
	            alert.addEventListener(AlertEvent.ALERT_CLOSED_EVENT, closeHandler);
	        }

	        return alert;
	    }
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.SimpleButton;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class CustomSimpleButton 
	extends SimpleButton
{
    private var upColorStart:uint   = 0x4E4E4E;
    private var upColorEnd:uint     = 0x3B3B3B;
    private var overColorStart:uint = 0x6C6C6C;
    private var overColorEnd:uint   = 0x4A4A4A;
    private var downColorStart:uint = 0x464646;
    private var downColorEnd:uint   = 0x343434;

    public function CustomSimpleButton(label: String)
    {
    	super();
        this.downState      = new ButtonDisplayState(downColorStart, downColorEnd, 20, 60, label);
        this.overState      = new ButtonDisplayState(overColorStart, overColorEnd, 20, 60, label);
        this.upState        = new ButtonDisplayState(upColorStart, upColorEnd, 20, 60, label);
        this.hitTestState   = new ButtonDisplayState(overColorStart, overColorEnd, 20, 60, label);
        this.useHandCursor  = true;
    }
}

class ButtonDisplayState 
	extends Sprite
{

	import flash.display.GradientType;

    private var bgColorStart:uint;
    private var bgColorEnd:uint;
	private var _height: uint;
	private var _width: uint;

    public function ButtonDisplayState(bgColorStart: uint, bgColorEnd: uint, height: uint, width: uint, caption: String)
    {
    	super();
        this.bgColorStart = bgColorStart;
        this.bgColorEnd = bgColorEnd;
        this._height  = height;
        this._width   = width;        
        var label: TextField = new TextField();
		label.autoSize = TextFieldAutoSize.LEFT;
        var titleFormat: TextFormat = label.defaultTextFormat;
        titleFormat.font = "Verdana";
        titleFormat.bold = true;
        titleFormat.color = 0xFFFFFF;
        titleFormat.size = 10;
		titleFormat.align = TextFormatAlign.LEFT;
        label.defaultTextFormat = titleFormat;
        label.multiline = false;
        label.selectable = false;
        label.wordWrap = false;
        label.text = caption;
        label.x = (this._width / 2) - (label.width / 2);
        label.y = (this._height / 2) - (label.height / 2);
        this.addChild(label);
        this.draw();
    }

    private function draw(): void
    {
        this.graphics.beginGradientFill(GradientType.LINEAR, [this.bgColorStart, this.bgColorEnd], [1, 1], [0, 255]);
        this.graphics.drawRoundRect(0, 0, this._width, this._height, 10, 10);
        this.graphics.endFill();
    }
}