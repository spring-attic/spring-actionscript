/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.test.context {
import org.as3commons.lang.Assert;
import org.as3commons.lang.builder.ToStringBuilder;
import org.springextensions.actionscript.collections.Map;
import org.springextensions.actionscript.context.IApplicationContext;

/**
 * Cache for Spring ApplicationContexts in a test environment.
 *
 * <p>Maintains a cache of contexts by string key.</p>
 *
 * @author Andrew Lewisohn
 */
public class ContextCache {

	//--------------------------------------------------------------------------
	//
	//  Variable
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Map of context keys to Spring IApplicationContext instances.
	 */
	private var contextKeyToContextMap:Map = new Map();
	
	private var hitCount:int;
	
	private var missCount:int;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ContextCache() {
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Clears all contexts from the cache.
	 */
	internal function clear():void {
		contextKeyToContextMap.clear();
	}
	
	/**
	 * Clears hit and miss count statistics for the cache (i.e., resets counters
	 * to zero).
	 */
	internal function clearStatistics():void {
		hitCount = 0;
		missCount = 0;
	}
	
	/**
	 * Return whether there is a cached context for the given key.
	 * 
	 * @param key the context key (never <code>null</code>)
	 */
	internal function contains(key:String):Boolean {
		Assert.notNull(key, "Key must not be null.");
		return contextKeyToContextMap.contains(key);
	}
	
	/**
	 * Obtain a cached IApplicationContext for the given key.
	 * 
	 * <p>The hit and miss counts will be updated accordingly.</p>
	 * 
	 * @param key the context key (never <code>null</code>)
	 * @return the corresponding IApplicationContext instance,
	 * or <code>null</code> if not found in the cache.
	 * @see #remove()
	 */
	internal function get(key:String):IApplicationContext {
		Assert.notNull(key, "Key must not be null.");
		var context:IApplicationContext = contextKeyToContextMap.get(key);
		
		if(context == null) {
			incrementMissCount();
		} else {
			incrementHitCount();
		}
		
		return context;
	}
	
	/**
	 * Get the overall hit count for this cache. A <em>hit</em> is an access
	 * to the cache, which returned a non-null context for a queried key.
	 */
	internal function getHitCount():int {
		return hitCount;
	}
	
	/**
	 * Get the overall miss count for this cache. A <em>miss</em> is an
	 * access to the cache, which returned a <code>null</code> context for a
	 * queried key.
	 */
	internal function getMissCount():int {
		return missCount;
	}
	
	/**
	 * Increment the hit count by one. A <em>hit</em> is an access to the
	 * cache, which returned a non-null context for a queried key.
	 */
	private function incrementHitCount():void {
		hitCount++;
	}
	
	/**
	 * Increment the miss count by one. A <em>miss</em> is an access to the
	 * cache, which returned a <code>null</code> context for a queried key.
	 */
	private function incrementMissCount():void {
		missCount++;	
	}
	
	/**
	 * Explicitly add an IApplicationContext instance to the cache under the given key.
	 * 
	 * @param key the context key (never <code>null</code>)
	 * @param context the IApplicationContext instance (never <code>null</code>)
	 */
	internal function put(key:String, context:IApplicationContext):void {
		Assert.notNull(key, "Key must not be null.");
		Assert.notNull(context, "IApplicationContext must not be null.");
		contextKeyToContextMap.put(key, context);
	}
	
	/**
	 * Remove the context with the given key.
	 * 
	 * @param key the context key (never <code>null</code>)
	 * @return the corresponding IApplicationContext instance,
	 * or <code>null</code> if not found in the cache.
	 * @see #setDirty
	 */
	internal function remove(key:String):IApplicationContext {
		return contextKeyToContextMap.remove(key);
	}
	
	/**
	 * Mark the context with the given key as dirty, effectively
	 * removing the context from the cache.
	 * 
	 * <p>
	 * Generally speaking, you would only call this method if you change
	 * the state of a singleton bean, potentially affecting future interaction
	 * with the context.
	 * </p>
	 * 
	 * @param key the context key (never <code>null</code>)
	 * @see #remove
	 */
	internal function setDirty(key:String):void {
		Assert.notNull(key, "Key must not be null.");
		remove(key);
	}
	
	/**
	 * Determine the number of contexts currently stored in the cache. If the
	 * cache contains more than <tt>Number.MAX_VALUE</tt> elements, returns
	 * <tt>Number.MAX_VALUE</tt>.
	 */
	internal function size():int {
		return contextKeyToContextMap.size;
	}
	
	/**
	 * Generates a text string, which contains the size as well
	 * as the hit and miss counts.
	 */
	public function toString():String {
		return new ToStringBuilder(this)
			.append(size(), "size")
			.append(getHitCount(), "hitCount")
			.append(getMissCount(), "missCount")
			.toString();
	}
}
}