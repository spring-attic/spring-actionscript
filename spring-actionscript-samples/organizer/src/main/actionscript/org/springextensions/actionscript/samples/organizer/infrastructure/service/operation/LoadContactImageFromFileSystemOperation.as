package org.springextensions.actionscript.samples.organizer.infrastructure.service.operation {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import flash.utils.setTimeout;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.springextensions.actionscript.core.operation.AbstractOperation;
import org.springextensions.actionscript.samples.organizer.domain.Contact;

public class LoadContactImageFromFileSystemOperation extends AbstractOperation {

	private static var logger:ILogger = LoggerFactory.getClassLogger(LoadContactImageFromFileSystemOperation);

	private static var _cache:Object = {};

	public function LoadContactImageFromFileSystemOperation(contact:Contact) {
		var image:ByteArray = _cache[contact.id];
		var request:URLRequest;

		var loadComplete:Function = function():void {
			logger.debug("Loaded image for contact '{0}'", contact);
			dispatchCompleteEvent(image);
		};

		if (image) {
			setTimeout(loadComplete, 1);
		} else {
			image = new ByteArray();
			request = new URLRequest("pics/" + contact.id + ".jpg");
			_cache[contact.id] = image;

			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;

			var completeHandler:Function = function(event:Event):void {
				logger.debug("Loaded image from '{0}' for contact '{1}'", request.url, contact);
				image.writeBytes(event.target.data);
				loadComplete();
			};

			var errorHandler:Function = function(event:IOErrorEvent):void {
				logger.warn("Could not load image from '{0}' for contact '{1}'. Loading default image.", request.url, contact);
				request = new URLRequest("pics/nopic.png");
				loader.load(request);
			};

			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(request);
		}
	}
}
}