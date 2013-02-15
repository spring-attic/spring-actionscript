package org.springextensions.actionscript.test.context.objects {
import org.springextensions.actionscript.context.IApplicationContext;
import org.springextensions.actionscript.test.context.IContextLoader;

public class MockContextLoader implements IContextLoader {
	public function MockContextLoader() {
	}
	
	public function get contextLoaded():Boolean {
		return false;
	}
	
	public function get couldNotLoadContext():Boolean {
		return false;
	}
	
	public function loadContext(locations:Array):IApplicationContext {
		return null;
	}
	
	public function processLocations(clazz:Class, locations:Array):Array {
		return null;
	}
}
}