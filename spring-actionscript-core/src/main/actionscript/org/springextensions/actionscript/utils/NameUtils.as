package org.springextensions.actionscript.utils {
import org.as3commons.lang.Assert;
import org.as3commons.lang.ClassUtils;

/**
 * Utility methods for naming conventions.
 * 
 * @author Andrew Lewisohn
 * @since 1.1
 */
public class NameUtils {
	
	/**
	 * Return an attribute name qualified by the supplied enclosing Class. For example,
	 * the attribute name '<code>foo</code>' qualified by 'com.myapp.SomeClass'
	 * would be '<code>com.myapp.SomeClass.foo</code>'.
	 */
	public static function getQualifiedAttributeName(enclosingClass:Class, attributeName:String):String {
		Assert.notNull(enclosingClass, "'enclosingClass' cannot be null.");
		Assert.notNull(attributeName, "'attributeName' cannot be null.");
		return ClassUtils.getFullyQualifiedName(enclosingClass, true) + "." + attributeName;
	} 
}
}