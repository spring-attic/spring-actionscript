package org.springextensions.actionscript.ioc.factory.config {

	import flash.events.Event;

	import flexunit.framework.TestCase;

	import org.as3commons.reflect.IMetaDataContainer;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayEventParameterAndWithNameEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayParameterAndWithNameEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithEventParameterAndWithNameEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEventPlusHandler;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.AnnotatedEventHandlers;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.ArrayEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.IAnnotatedEventHandler;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.NonExistingEventHandler;
	import org.springextensions.actionscript.ioc.factory.support.DefaultListableObjectFactory;

	public class EventHandlerMetaDataProcessorTest extends TestCase {

		private var _processor:EventHandlerMetadataProcessor;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function EventHandlerMetaDataProcessorTest() {
			super();
		}

		override public function setUp():void {
			_processor = new EventHandlerMetadataProcessor();
			_processor.objectFactory = new DefaultListableObjectFactory();
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		public function testPostProcess():void {
			var annotated:AnnotatedEventHandlers = new AnnotatedEventHandlers();
			var methods:Array = Type.forInstance(annotated).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(annotated, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new Event(AnnotatedEventHandlers.EVENT_ONE));
			assertEquals(1, annotated.numMethodOneInvocations);
			assertEquals(1, annotated.numMethodOneHandlerInvocations);
			assertEquals(1, annotated.numMethodTwoInvocations);
			assertEquals(1, annotated.numMethodThreeInvocations);
		}

		/**
		 * [EventHandler]
		 * public function reverseArray():void
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler]
		 * public function reverseArrayHandler():void
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEventPlusHandler():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEventPlusHandler();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler]
		 * public function reverseArray(event:ArrayEvent):void
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayEventParameterAndWithNameEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayEventParameterAndWithNameEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler]
		 * public function reverseArray(array:Array):void
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayParameterAndWithNameEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayParameterAndWithNameEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler]
		 * public function reverseArray(event:Event):void
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithEventParameterAndWithNameEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithEventParameterAndWithNameEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler]
		 * public function thisEventDoesNotExist():void
		 */
		public function testPostProcess_NonExistingEventHandler():void {
			var object:IAnnotatedEventHandler = new NonExistingEventHandler();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 0);
		}

		/**
		 * [EventHandler(name="reverseArray")]
		 * public function someMethod():void;
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler(name="reverseArray")]
		 * public function someMethod(event:ArrayEvent):void;
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler(name="reverseArray")]
		 * public function someMethod(event:Event):void;
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler(name="reverseArray")]
		 * public function someMethod(array:Array):void;
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler("reverseArray")]
		 * public function someMethod():void;
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler("reverseArray")]
		 * public function someMethod(event:ArrayEvent):void;
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler("reverseArray")]
		 * public function someMethod(event:Event):void;
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		/**
		 * [EventHandler("reverseArray")]
		 * public function someMethod(array:Array):void;
		 */
		public function testPostProcess_AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent():void {
			var object:IAnnotatedEventHandler = new AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent();
			var methods:Array = Type.forInstance(object).getMetaDataContainers(String(_processor.metadataNames[0]));
			for each (var c:IMetaDataContainer in methods) {
				_processor.process(object, c, "EventHandler", "");
			}
			EventBus.dispatchEvent(new ArrayEvent(ArrayEvent.REVERSE, []));
			assertNumInvocations(object, 1);
		}

		// --------------------------------------------------------------------
		//
		// Assertions
		//
		// --------------------------------------------------------------------

		private function assertNumInvocations(handler:IAnnotatedEventHandler, expected:uint):void {
			assertEquals(expected, handler.numInvocations);
		}
	}
}