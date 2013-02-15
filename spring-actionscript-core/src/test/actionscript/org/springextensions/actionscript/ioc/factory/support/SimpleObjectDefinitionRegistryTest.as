package org.springextensions.actionscript.ioc.factory.support {

	import flexunit.framework.TestCase;

	import org.as3commons.lang.IllegalArgumentError;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionError;

	/**
	 * @author Christophe Herreman
	 */
	public class SimpleObjectDefinitionRegistryTest extends TestCase {

		private var _registry:IObjectDefinitionRegistry;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SimpleObjectDefinitionRegistryTest() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Setup
		//
		// --------------------------------------------------------------------

		override public function setUp():void {
			_registry = new SimpleObjectDefinitionRegistry();
		}

		// --------------------------------------------------------------------
		//
		// Tests: registerObjectDefinition()
		//
		// --------------------------------------------------------------------

		public function testRegisterObjectDefinition():void {
			try {
				_registry.registerObjectDefinition("object", new ObjectDefinition());
			} catch (e:Error) {
				fail("registerObjectDefinition() with valid parameters should not throw error");
			}
		}

		public function testRegisterObjectDefinition_allowReregistration():void {
			var definition1:ObjectDefinition = new ObjectDefinition();
			var definition2:ObjectDefinition = new ObjectDefinition();
			_registry.registerObjectDefinition("object", definition1);

			try {
				_registry.registerObjectDefinition("object", definition2);
			} catch (e:Error) {
				fail("registerObjectDefinition() with existing objectName should not throw error");
			}
		}

		public function testRegisterObjectDefinition_shouldThrowIllegalArgumentErrorIfObjectNameIsNull():void {
			try {
				_registry.registerObjectDefinition(null, new ObjectDefinition());
				fail("registerObjectDefinition() should fail when objectName is null");
			} catch (e:IllegalArgumentError) {}
		}

		public function testRegisterObjectDefinition_shouldThrowIllegalArgumentErrorIfObjectNameIsEmpty():void {
			try {
				_registry.registerObjectDefinition("", new ObjectDefinition());
				fail("registerObjectDefinition() should fail when objectName is empty");
			} catch (e:IllegalArgumentError) {}
		}

		public function testRegisterObjectDefinition_shouldThrowIllegalArgumentErrorIfObjectNameIsSpaces():void {
			try {
				_registry.registerObjectDefinition("   ", new ObjectDefinition());
				fail("registerObjectDefinition() should fail when objectName is spaces");
			} catch (e:IllegalArgumentError) {}
		}

		public function testRegisterObjectDefinition_shouldThrowIllegalArgumentErrorIfObjectDefinitionIsNull():void {
			try {
				_registry.registerObjectDefinition("object", null);
				fail("registerObjectDefinition() should fail when objectDefinition is null");
			} catch (e:IllegalArgumentError) {}
		}

		// --------------------------------------------------------------------
		//
		// Tests: getObjectDefinition
		//
		// --------------------------------------------------------------------

		public function testGetObjectDefinition_shouldReturnRegisteredObjectDefinition():void {
			var definition:ObjectDefinition = new ObjectDefinition();
			_registry.registerObjectDefinition("object", definition);

			assertNotNull(_registry.getObjectDefinition("object"));
			assertStrictlyEquals(definition, _registry.getObjectDefinition("object"));
		}

		public function testGetObjectDefinition_shouldReturnLatestRegisteredObjectDefinition():void {
			var definition1:ObjectDefinition = new ObjectDefinition();
			var definition2:ObjectDefinition = new ObjectDefinition();
			_registry.registerObjectDefinition("object", definition1);
			_registry.registerObjectDefinition("object", definition2);
			
			assertStrictlyEquals(definition2, _registry.getObjectDefinition("object"));
		}

		public function testGetObjectDefinition_shouldThrowNoSuchObjectDefinitionErrorWhenObjectDefinitionWasNotRegistered():void {
			try {
				_registry.getObjectDefinition("nonRegisteredObject");
				fail("getObjectDefinition() should fail when object definition was not registered");
			} catch (e:NoSuchObjectDefinitionError) {}
		}

		public function testGetObjectDefinition_shouldThrowNoSuchObjectDefinitionErrorWhenObjectNameIsNull():void {
			try {
				_registry.getObjectDefinition(null);
				fail("getObjectDefinition() should fail when objectName is null");
			} catch (e:NoSuchObjectDefinitionError) {}
		}

		// --------------------------------------------------------------------
		//
		// Tests: removeObjectDefinition
		//
		// --------------------------------------------------------------------

		public function testRemoveObjectDefinition():void {
			_registry.registerObjectDefinition("object", new ObjectDefinition());
			assertTrue(_registry.containsObjectDefinition("object"));
			_registry.removeObjectDefinition("object");
			assertFalse(_registry.containsObjectDefinition("object"));
		}

		public function testRemoveObjectDefinition_shouldNotThrowErrorWhenRemovingNonRegisteredObject():void {
			try {
				_registry.removeObjectDefinition("nonRegisteredObject");
			} catch (e:Error) {
				fail("removeObjectDefinition() with non registered objectName should not fail");
			}
		}

		public function testRemoveObjectDefinition_shouldNotThrowErrorForNullObjectName():void {
			try {
				_registry.removeObjectDefinition(null);
			} catch (e:Error) {
				fail("removeObjectDefinition() with null objectName should not fail");
			}
		}

		// --------------------------------------------------------------------
		//
		// Tests: containsObjectDefinition
		//
		// --------------------------------------------------------------------

		public function testContainsObjectDefinition():void {
			_registry.registerObjectDefinition("object", new ObjectDefinition());
			assertTrue(_registry.containsObjectDefinition("object"));
		}

		public function testContainsObjectDefinition_shouldFalseWhenObjectDefinitionWasRemoved():void {
			_registry.registerObjectDefinition("object", new ObjectDefinition());
			_registry.removeObjectDefinition("object");
			assertFalse(_registry.containsObjectDefinition("object"));
		}

		public function testContainsObjectDefinition_shouldReturnFalseForEmptyRegistry():void {
			assertFalse(_registry.containsObjectDefinition("nonRegisteredObject"));
		}

		public function testContainsObjectDefinition_shouldReturnFalseForNonRegisteredObjectName():void {
			_registry.registerObjectDefinition("object", new ObjectDefinition());
			assertFalse(_registry.containsObjectDefinition("nonRegisteredObject"));
		}

		public function testContainsObjectDefinition_shouldReturnFalseForNullObjectName():void {
			_registry.registerObjectDefinition("object", new ObjectDefinition());
			assertFalse(_registry.containsObjectDefinition(null));
		}
	}
}