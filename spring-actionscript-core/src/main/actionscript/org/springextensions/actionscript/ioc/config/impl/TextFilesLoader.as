/*
 * Copyright 2007-2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.ioc.config.impl {
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.async.operation.impl.LoadURLOperation;
	import org.as3commons.async.operation.impl.OperationQueue;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.ITextFilesLoader;
	import org.springextensions.actionscript.ioc.config.property.TextFileURI;

	/**
	 * Loads 1 or more text files.
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 * @author Christophe Herreman
	 */
	public class TextFilesLoader extends OperationQueue implements ITextFilesLoader {
		private static const AMPERSAND:String = "&";

		private static const QUESTION_MARK:String = '?';

		private static const logger:ILogger = getClassLogger(TextFilesLoader);

		/**
		 * Adds a random number to the url, checks if a '?' character is already part of the string
		 * than suffixes a '&amp;' character
		 * @param url The url that will be processed
		 * @param preventCache
		 * @return The formatted URL
		 */
		private static function formatURL(url:String, preventCache:Boolean):String {
			if (preventCache) {
				var parameterAppendChar:String = (url.indexOf(QUESTION_MARK) < 0) ? QUESTION_MARK : AMPERSAND;
				url += (parameterAppendChar + Math.round(Math.random() * 1000000));
			}
			return url;
		}

		/**
		 * Creates a new <code>TextFilesLoader</code> instance.
		 * @param name An optional name for the current <code>TextFilesLoader</code>.
		 */
		public function TextFilesLoader(name:String="") {
			super(name);
			_results = new Vector.<String>();
			_requiredOperations = new Vector.<LoadURLOperation>();
		}

		private var _failedOperation:IOperation;

		private var _requiredOperations:Vector.<LoadURLOperation>;
		private var _results:Vector.<String>;

		/**
		 * @inheritDoc
		 */
		public function addURI(uri:String, preventCache:Boolean=true, isRequired:Boolean=true):void {
			var loadOperation:LoadURLOperation = new LoadURLOperation(formatURL(uri, preventCache));
			if (isRequired) {
				_requiredOperations.push(loadOperation);
			}
			loadOperation.addCompleteListener(textFileLoaderComplete);
			loadOperation.addErrorListener(textFileLoaderError);
			addOperation(loadOperation);
			logger.debug("Added URI '{0}', with preventCache:{1} and isRequired:{2}", [uri, preventCache, isRequired]);
		}

		/**
		 * @inheritDoc
		 */
		public function addURIs(uris:Vector.<TextFileURI>):void {
			for each (var propertyURI:TextFileURI in uris) {
				addURI(propertyURI.textFileURI, propertyURI.preventCache, propertyURI.isRequired);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function dispatchCompleteEvent(result:*=null):Boolean {
			logger.debug("Completed loading of {0} text file(s)", [(_results) ? _results.length : 0]);
			return super.dispatchCompleteEvent(_results);
		}

		override public function dispatchErrorEvent(error:*=null):Boolean {
			if (isRequired(_failedOperation)) {
				return super.dispatchErrorEvent(error);
			}
			return false;
		}

		/**
		 *
		 * @param operation
		 */
		private function cleanUpLoadURLOperation(operation:IOperation):void {
			operation.removeCompleteListener(textFileLoaderComplete);
			operation.removeErrorListener(textFileLoaderError);
		}

		private function isRequired(operation:IOperation):Boolean {
			return (_requiredOperations.indexOf(operation) > -1);
		}

		private function textFileLoaderComplete(event:OperationEvent):void {
			cleanUpLoadURLOperation(event.operation);
			_results.push(String(event.result));
			logger.debug("Completed operation {0}", [event.operation]);
		}

		private function textFileLoaderError(event:OperationEvent):void {
			_failedOperation = event.operation;
			cleanUpLoadURLOperation(event.operation);
			logger.warn("Failed to load {0}, error: {1}", [LoadURLOperation(event.operation).url, event.error]);
		}
	}
}
