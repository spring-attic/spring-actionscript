package org.springextensions.actionscript.test.context.flexunit4 {
import org.flexunit.Assert;
import org.springextensions.actionscript.test.context.objects.MockContextLoader;
import org.springextensions.actionscript.test.context.objects.MockObject;
import org.springextensions.actionscript.test.context.objects.MockObject2;

[RunWith("org.springextensions.actionscript.test.context.flexunit4.SpringFlexUnit4ClassRunner")]
[ContextConfiguration]
public class TestExecutionListenerTest extends AbstractFlexUnit4SpringContextTests {
	public function TestExecutionListenerTest() {
	}
	
	private var _contextLoader:MockContextLoader;
	
	[Autowired]
	public function set contextLoader(value:MockContextLoader):void {
		_contextLoader = value;	
	}
	
	[Autowired]
	public var object:MockObject2;
	
	[Autowired(mode="byName")]
	public var namedObject:MockObject;
	
	[Test(order="1")]
	[DirtiesContext]
	public function testAutowiredProperties():void {
		Assert.assertNotNull(_contextLoader);
		Assert.assertNotNull(object);
		Assert.assertNotNull(namedObject);
		Assert.assertEquals("MockObjectFromContext", namedObject.name);
		
		namedObject.name = "MockObjectEdited";
		Assert.assertEquals("MockObjectEdited", namedObject.name);
	}
	
	[Test(order="2")]
	public function testAfterDirtiesContext():void {
		Assert.assertNotNull(_contextLoader);
		Assert.assertNotNull(object);
		Assert.assertNotNull(namedObject);
		Assert.assertEquals("MockObjectFromContext", namedObject.name);
	}
}
}