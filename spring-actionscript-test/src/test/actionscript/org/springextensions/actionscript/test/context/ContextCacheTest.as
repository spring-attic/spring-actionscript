package org.springextensions.actionscript.test.context {
import org.flexunit.Assert;
import org.springextensions.actionscript.context.IApplicationContext;
import org.springextensions.actionscript.context.support.XMLApplicationContext;

public class ContextCacheTest {
	// Reference declaration for class to test
	private var classToTestRef : org.springextensions.actionscript.test.context.ContextCache;
	
	private var contextCache:ContextCache;
	
	public function ContextCacheTest() {
	}
	
	[Before]
	public function setUp():void {
		contextCache = new ContextCache();	
	}
	
	[After]
	public function tearDown():void {
		contextCache = null;	
	}
	
	[Test]
	public function testClear():void {
		contextCache.put("key", new XMLApplicationContext());
		
		Assert.assertEquals(1, contextCache.size());
		
		contextCache.clear();
		
		Assert.assertEquals(0, contextCache.size());
	}
	
	[Test]
	public function testClearStatistics():void {
		contextCache.put("key", new XMLApplicationContext());
		contextCache.get("key");
		Assert.assertEquals(1, contextCache.getHitCount());
		
		contextCache.put("key", new XMLApplicationContext());
		contextCache.get("key2");
		Assert.assertEquals(1, contextCache.getMissCount());
		
		contextCache.clearStatistics();
		Assert.assertEquals(0, contextCache.getHitCount());
		Assert.assertEquals(0, contextCache.getMissCount());
	}
	
	[Test]
	public function testContains():void {
		contextCache.put("key", new XMLApplicationContext());
		
		Assert.assertEquals(1, contextCache.size());
		Assert.assertTrue(contextCache.contains("key"));
	}
	
	[Test]
	public function testGet():void {
		var context:XMLApplicationContext = new XMLApplicationContext();
		contextCache.put("key", context);
		Assert.assertEquals(1, contextCache.size());
		
		var context2:IApplicationContext = contextCache.get("key");
		Assert.assertEquals(1, contextCache.size());
		Assert.assertEquals(context, context2);
	}
	
	[Test]
	public function testGetHitCount():void {
		contextCache.put("key", new XMLApplicationContext());
		contextCache.get("key");
		Assert.assertEquals(1, contextCache.getHitCount());
	}
	
	[Test]
	public function testGetMissCount():void {
		contextCache.put("key", new XMLApplicationContext());
		contextCache.get("key2");
		Assert.assertEquals(1, contextCache.getMissCount());
	}
	
	[Test]
	public function testPut():void {
		var context:XMLApplicationContext = new XMLApplicationContext();
		contextCache.put("key", context);
		Assert.assertEquals(1, contextCache.size());
	}
	
	[Test]
	public function testRemove():void {
		var context:XMLApplicationContext = new XMLApplicationContext();
		contextCache.put("key", context);
		Assert.assertEquals(1, contextCache.size());
		
		var context2:IApplicationContext = contextCache.remove("key");
		Assert.assertEquals(context, context2);
		Assert.assertEquals(0, contextCache.size());
	}
	
	[Test]
	public function testSetDirty():void {
		contextCache.put("key", new XMLApplicationContext());
		
		Assert.assertEquals(1, contextCache.size());
		
		contextCache.setDirty("key");
		
		Assert.assertEquals(0, contextCache.size());
	}
	
	[Test]
	public function testSize():void {
		Assert.assertEquals(0, contextCache.size());
		
		contextCache.put("key", new XMLApplicationContext());
		Assert.assertEquals(1, contextCache.size());
		
		contextCache.put("key2", new XMLApplicationContext());
		Assert.assertEquals(2, contextCache.size());
	}
	
	[Test]
	public function testToString():void {
		var string:String = contextCache.toString();
		
		Assert.assertTrue(string.length > 0);
	}
}
}