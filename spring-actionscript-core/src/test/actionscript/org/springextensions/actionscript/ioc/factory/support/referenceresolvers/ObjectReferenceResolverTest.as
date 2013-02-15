package org.springextensions.actionscript.ioc.factory.support.referenceresolvers {

	import flexunit.framework.TestCase;

	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.support.AbstractObjectFactory;
	import org.springextensions.actionscript.ioc.testclasses.Person;

	/**
	 * @author Christophe Herreman
	 */
	public class ObjectReferenceResolverTest extends TestCase {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ObjectReferenceResolverTest() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		public function testResolve_generatedName():void {
			var objectFactory:IObjectFactory = new AbstractObjectFactory();
			var resolver:IReferenceResolver = new ObjectReferenceResolver(objectFactory);

			var o:IObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.Person");
			var oReference:RuntimeObjectReference = new RuntimeObjectReference("generatedName#1");
			objectFactory.objectDefinitions["oReference"] = oReference;
			objectFactory.objectDefinitions["generatedName#1"] = o;
			var resolvedObject:Object = resolver.resolve(oReference);

			assertNotNull(resolvedObject);
			assertTrue(resolvedObject is Person);
		}

		public function testResolve_generatedCompoundName():void {
			var objectFactory:IObjectFactory = new AbstractObjectFactory();
			var resolver:IReferenceResolver = new ObjectReferenceResolver(objectFactory);

			var o:IObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.Person");
			var oReference:RuntimeObjectReference = new RuntimeObjectReference("com.company.generatedName#1");
			objectFactory.objectDefinitions["oReference"] = oReference;
			objectFactory.objectDefinitions["com.company.generatedName#1"] = o;
			var resolvedObject:Object = resolver.resolve(oReference);

			assertNotNull(resolvedObject);
			assertTrue(resolvedObject is Person);
		}
	}
}