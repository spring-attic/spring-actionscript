/**
 * Created by IntelliJ IDEA.
 * User: christophe
 * Date: Sep 24, 2010
 * Time: 10:48:34 AM
 * To change this template use File | Settings | File Templates.
 */
package org.springextensions.actionscript.context.support {
	import flexunit.framework.TestCase;

	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.collections.Properties;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.config.PropertyPlaceholderConfigurer;
	import org.springextensions.actionscript.ioc.testclasses.Person;

	/**
	 * @author Christophe Herreman
	 */
	public class AbstractApplicationContextTest extends TestCase {

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private static const NAME_REPLACED:String = "John 'Joe' Doe";
		private static const NAME_NOT_REPLACED:String = "John '${nickname}' Doe";

		private var _parentContext:AbstractApplicationContext;
		private var _childContext:AbstractApplicationContext;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AbstractApplicationContextTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		public function testNew():void {
			var context:AbstractApplicationContext = new AbstractApplicationContext();
			assertFalse(context.useParentObjectFactoryPostProcessors);
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		public function testGetObject_shouldReplacePropertiesDefinedInParentObjectFactoryInChildObjectFactoryObject():void {
			preparePropertyReplacementTest(true);

			var person:Person = _parentContext.getObject("person");
			assertNotNull(person);
			assertEquals(NAME_REPLACED, person.name);

			var person2:Person = _childContext.getObject("person2");
			assertNotNull(person2);
			assertEquals(NAME_REPLACED, person2.name);
		}

		public function testGetObject_shouldNotReplacePropertiesDefinedInParentObjectFactoryInChildObjectFactoryObject():void {
			preparePropertyReplacementTest();

			var person:Person = _parentContext.getObject("person");
			assertNotNull(person);
			assertEquals(NAME_REPLACED, person.name);

			var person2:Person = _childContext.getObject("person2");
			assertNotNull(person2);
			assertEquals(NAME_NOT_REPLACED, person2.name);
		}

		private function preparePropertyReplacementTest(useParentObjectFactoryPostProcessors:Boolean = false):void {
			_parentContext = new AbstractApplicationContext();
			_childContext = new AbstractApplicationContext();
			_childContext.useParentObjectFactoryPostProcessors = useParentObjectFactoryPostProcessors;
			_childContext.parent = _parentContext;

			// property placeholder configurer
			var propertyPlaceholderConfigurer:PropertyPlaceholderConfigurer = new PropertyPlaceholderConfigurer()
			propertyPlaceholderConfigurer.properties = new Properties();
			propertyPlaceholderConfigurer.properties.setProperty("nickname", "Joe");
			_parentContext.addObjectFactoryPostProcessor(propertyPlaceholderConfigurer);

			// object with propertyplaceholder in parent context
			var objectDefinitionInParentContext:IObjectDefinition = new ObjectDefinition(ClassUtils.getFullyQualifiedName(Person));
			objectDefinitionInParentContext.properties["name"] = NAME_NOT_REPLACED;
			_parentContext.objectDefinitions["person"] = objectDefinitionInParentContext;

			// object with propertyplaceholder in child context
			var objectDefinitionInChildContext:IObjectDefinition = new ObjectDefinition(ClassUtils.getFullyQualifiedName(Person));
			objectDefinitionInChildContext.properties["name"] = NAME_NOT_REPLACED;
			_childContext.objectDefinitions["person2"] = objectDefinitionInChildContext;

			_parentContext.load();
			_childContext.load();
		}

	}
}