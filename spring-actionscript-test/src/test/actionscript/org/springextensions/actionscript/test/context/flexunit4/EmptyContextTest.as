package org.springextensions.actionscript.test.context.flexunit4 {
import org.flexunit.Assert;

[RunWith("org.springextensions.actionscript.test.context.flexunit4.SpringFlexUnit4ClassRunner")]
[ContextConfiguration(locations="empty-context.xml")]
public class EmptyContextTest {
	public function EmptyContextTest() {
	}
	
	[Test]
	public function testEmpty():void {
		Assert.assertNull(null);
	}
}
}