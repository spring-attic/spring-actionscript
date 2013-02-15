/*
 * Copyright 2007-2008 the original author or authors.
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
package org.springextensions.actionscript.utils {

  import flexunit.framework.TestCase;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class ParseTest extends TestCase {

    public function ParseTest(methodName:String = null) {
      super(methodName);
    }

    private const CLEAN_HTML:String = "" +
        "<table>" +
        "<tr>" +
          "<td width=\"123\">text</td>" +
          "<td width=\"456\">text</td>" +
        "</tr>" +
        "<tr>" +
          "<td>text</td>" +
          "<td>text</td>" +
        "</tr>" +
        "</table>";

    private const DIRTY_HTML:String = "" +
        "junk" +
        "<TABLE junk>junk" +
        "<TR junk>junk" +
          "<TD junk width = 123 junk>text</td junk>junk" +
          "<TD junk width = '456\" junk>text</td junk>junk" +
        "</tR junk>junk" +
        "<tr junk>junk" +
          "<td junk>text</td junk>junk" +
          "<td junk>text</td junk>junk" +
        "</tr junk>junk" +
        "</table junk>" +
        "junk";

    public function testStackOverFlow():void {
      var input:String = "<table><tr><td></td></tr></table";
      var output:Parse = new Parse(input, null);
      assertNotNull(output);
    }

    public function testWidth():void {
      assertEquals(123, new Parse(CLEAN_HTML, null).at(0, 0, 0).width());
      assertEquals(456, new Parse(CLEAN_HTML, null).at(0, 0, 1).width());
      assertEquals(123, new Parse(DIRTY_HTML, null).at(0, 0, 0).width());
      assertEquals(456, new Parse(DIRTY_HTML, null).at(0, 0, 1).width());
    }

    public function testLast():void {
      assertEquals("<table", new Parse(CLEAN_HTML, null).last().tag.substr(0, 6).toLowerCase());
      assertEquals("<tr", new Parse(CLEAN_HTML, null).parts.last().tag.substr(0, 3).toLowerCase());
      assertEquals("<td", new Parse(CLEAN_HTML, null).parts.parts.last().tag.substr(0, 3).toLowerCase());
      assertEquals("<table", new Parse(DIRTY_HTML, null).last().tag.substr(0, 6).toLowerCase());
      assertEquals("<tr", new Parse(DIRTY_HTML, null).parts.last().tag.substr(0, 3).toLowerCase());
      assertEquals("<td", new Parse(DIRTY_HTML, null).parts.parts.last().tag.substr(0, 3).toLowerCase());
    }

    public function testSize():void {
      assertEquals(1, new Parse(CLEAN_HTML, null).at(0).size());
      assertEquals(2, new Parse(CLEAN_HTML, null).at(0, 0).size());
      assertEquals(2, new Parse(CLEAN_HTML, null).at(0, 0, 0).size());
      assertEquals(1, new Parse(DIRTY_HTML, null).at(0).size());
      assertEquals(2, new Parse(DIRTY_HTML, null).at(0, 0).size());
      assertEquals(2, new Parse(DIRTY_HTML, null).at(0, 0, 0).size());
    }

    public function testLeaf():void {
      assertEquals("<td width=\"123\">", new Parse(CLEAN_HTML, null).at(0).leaf().tag);
      assertEquals("<td width=\"123\">", new Parse(CLEAN_HTML, null).at(0, 0).leaf().tag);
      assertEquals("<td width=\"123\">", new Parse(CLEAN_HTML, null).at(0, 0, 0).leaf().tag);
      assertEquals("<td>", new Parse(CLEAN_HTML, null).at(0, 1).leaf().tag);
      assertEquals("<TD junk width = 123 junk>", new Parse(DIRTY_HTML, null).at(0).leaf().tag);
      assertEquals("<TD junk width = 123 junk>", new Parse(DIRTY_HTML, null).at(0, 0).leaf().tag);
      assertEquals("<TD junk width = 123 junk>", new Parse(DIRTY_HTML, null).at(0, 0, 0).leaf().tag);
      assertEquals("<td junk>", new Parse(DIRTY_HTML, null).at(0, 1).leaf().tag);
      assertEquals("<td junk>", new Parse(DIRTY_HTML, null).at(0, 1, 0).leaf().tag);
    }

    public function testAt():void {
      assertEquals("<table>", new Parse(CLEAN_HTML, null).at(0).tag);
      assertEquals("<tr>", new Parse(CLEAN_HTML, null).at(0, 0).tag);
      assertEquals("<td width=\"123\">", new Parse(CLEAN_HTML, null).at(0, 0, 0).tag);
      assertEquals("<td width=\"456\">", new Parse(CLEAN_HTML, null).at(0, 0, 1).tag);
      assertEquals("<tr>", new Parse(CLEAN_HTML, null).at(0, 1).tag);
      assertEquals("<td>", new Parse(CLEAN_HTML, null).at(0, 1, 0).tag);
      assertEquals("<td>", new Parse(CLEAN_HTML, null).at(0, 1, 1).tag);
      assertEquals("<TABLE junk>", new Parse(DIRTY_HTML, null).at(0).tag);
      assertEquals("<TR junk>", new Parse(DIRTY_HTML, null).at(0, 0).tag);
      assertEquals("<TD junk width = 123 junk>", new Parse(DIRTY_HTML, null).at(0, 0, 0).tag);
      assertEquals("<TD junk width = '456\" junk>", new Parse(DIRTY_HTML, null).at(0, 0, 1).tag);
      assertEquals("<tr junk>", new Parse(DIRTY_HTML, null).at(0, 1).tag);
      assertEquals("<td junk>", new Parse(DIRTY_HTML, null).at(0, 1, 0).tag);
      assertEquals("<td junk>", new Parse(DIRTY_HTML, null).at(0, 1, 1).tag);
    }

    public function testGetAttribute():void {
      assertEquals("123", new Parse(CLEAN_HTML, null).at(0, 0, 0).getAttribute("width"));
      assertEquals("456", new Parse(CLEAN_HTML, null).at(0, 0, 1).getAttribute("width"));
      assertEquals("123", new Parse(DIRTY_HTML, null).at(0, 0, 0).getAttribute("width"));
      assertEquals("456", new Parse(DIRTY_HTML, null).at(0, 0, 1).getAttribute("width"));
    }

    //=====================================================================
    // parseText(s:String):String
    //=====================================================================
    public function testParseText1():void {
      var input:String = "before<table><tr><td width=40 x>e</td><td width=10>f</td></tr><tr><td>g</td><td>h</td></tr></table>after";
      var expected:String = "beforeefghafter";
      var result:String = Parse.parseText(input);
      assertEquals(expected, result);
    }

    public function testParseText2():void {
      var input:String = "a<b>b</b>c&lt;d&gt;e&amp;f&nbsp;g";
      var expected:String = "abc<d>e&f g";
      var result:String = Parse.parseText(input);
      assertEquals(expected, result);
    }
  }
}
