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
   * A port from the Fit framework.
   *
   * <p>
   * <b>Author:</b> Kristof Neirynck<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   *
   * @url http://fit.c2.com/Release/Source/fit/FrameworkTest.java
   */
  public class FitFrameworkTest extends TestCase {

    public function FitFrameworkTest(methodName:String = null){
      super(methodName);
    }

    public function testParsing ():void {
      var p:Parse = new Parse("leader<Table foo=2>body</table>trailer", ["table"]);
      assertEquals("leader", p.leader);
      assertEquals("<Table foo=2>", p.tag);
      assertEquals("body", p.body);
      assertEquals("trailer", p.trailer);
    }

    public function testRecursing ():void {
      var p:Parse = new Parse("leader<table><TR><Td>body</tD></TR></table>trailer", null);
      assertEquals(null, p.body);
      assertEquals(null, p.parts.body);
      assertEquals("body", p.parts.parts.body);
    }

    public function testIterating ():void {
      var p:Parse = new Parse("leader<table><tr><td>one</td><td>two</td><td>three</td></tr></table>trailer", null);
      assertEquals("one", p.parts.parts.body);
      assertEquals("two", p.parts.parts.more.body);
      assertEquals("three", p.parts.parts.more.more.body);
    }

    public function testIndexing ():void {
      var p:Parse = new Parse("leader<table><tr><td>one</td><td>two</td><td>three</td></tr><tr><td>four</td></tr></table>trailer", null);
      assertEquals("one", p.at(0,0,0).body);
      assertEquals("two", p.at(0,0,1).body);
      assertEquals("three", p.at(0,0,2).body);
      assertEquals("three", p.at(0,0,3).body);
      assertEquals("three", p.at(0,0,4).body);
      assertEquals("four", p.at(0,1,0).body);
      assertEquals("four", p.at(0,1,1).body);
      assertEquals("four", p.at(0,2,0).body);
      assertEquals(1, p.size());
      assertEquals(2, p.parts.size());
      assertEquals(3, p.parts.parts.size());
      assertEquals("one", p.leaf().body);
      assertEquals("four", p.parts.last().leaf().body);
    }

    public function testParseException ():void {
      try {
        var p:Parse = new Parse("leader<table><tr><th>one</th><th>two</th><th>three</th></tr><tr><td>four</td></tr></table>trailer", null);
      }
      catch (e:ParseError) {
        assertEquals(17, e.getErrorOffset());
        assertEquals("Can't find tag: td", e.getMessage());
        return;
      }
      fail("exptected exception not thrown");
    }

    public function testText ():void {
      var tags:Array = ["td"];
      var p:Parse = new Parse("<td>a&lt;b</td>", tags);
      assertEquals("a&lt;b", p.body);
      assertEquals("a<b", p.text());
      p = new Parse("<td>\ta&gt;b&nbsp;&amp;&nbsp;b>c &&&nbsp;</td>", tags);
      assertEquals("a>b & b>c &&", p.text());
      p = new Parse("<td>\ta&gt;b&nbsp;&amp;&nbsp;b>c &&nbsp;</td>", tags);
      assertEquals("a>b & b>c &", p.text());
      p = new Parse("<TD><P><FONT FACE=\"Arial\" SIZE=2>GroupTestFixture</FONT></TD>", tags);
      assertEquals("GroupTestFixture",p.text());
    }

    public function testUnescape ():void {
      assertEquals("a<b", Parse.unescape("a&lt;b"));
      assertEquals("a>b & b>c &&", Parse.unescape("a&gt;b&nbsp;&amp;&nbsp;b>c &&"));
      assertEquals("&amp;&amp;", Parse.unescape("&amp;amp;&amp;amp;"));
      assertEquals("a>b & b>c &&", Parse.unescape("a&gt;b&nbsp;&amp;&nbsp;b>c &&"));
    }

    public function testUnformat ():void {
      assertEquals("ab",Parse.unformat("<font size=+1>a</font>b"));
      assertEquals("ab",Parse.unformat("a<font size=+1>b</font>"));
      assertEquals("a<b",Parse.unformat("a<b"));
    }

    //TODO
    /*
    public function testTypeAdapter ():void {
          TestFixture f = new TestFixture ();
          TypeAdapter a = TypeAdapter.on(f, f.getClass().getField("sampleInt"));
          a.set(a.parse("123456"));
          assertEquals(123456, f.sampleInt);
          assertEquals("-234567", a.parse("-234567").toString());
          a = TypeAdapter.on(f, f.getClass().getField("sampleInteger"));
          a.set(a.parse("54321"));
          assertEquals("54321", f.sampleInteger.toString());
          a = TypeAdapter.on(f, f.getClass().getMethod("pi", new Class[] {}));
          assertEquals(3.14159, ((Double)a.invoke()).doubleValue(), 0.00001);
          assertEquals(new Double(3.14159862), a.invoke());
          a = TypeAdapter.on(f, f.getClass().getField("ch"));
          a.set(a.parse("abc"));
          assertEquals('a', f.ch);
          a = TypeAdapter.on(f, f.getClass().getField("name"));
          a.set(a.parse("xyzzy"));
          assertEquals("xyzzy", f.name);
          a = TypeAdapter.on(f, f.getClass().getField("sampleFloat"));
          a.set(a.parse("6.02e23"));
          assertEquals(6.02e23, f.sampleFloat, 1e17);
          a = TypeAdapter.on(f, f.getClass().getField("sampleArray"));
          a.set(a.parse("1,2,3"));
          assertEquals(1, f.sampleArray[0]);
          assertEquals(2, f.sampleArray[1]);
          assertEquals(3, f.sampleArray[2]);
          assertEquals("1, 2, 3", a.toString(f.sampleArray));
          assertTrue(a.equals(new int [] {1,2,3}, f.sampleArray));
          a = TypeAdapter.on(f, f.getClass().getField("sampleDate"));
          Date date = new Date(49,4,26);
          a.set(a.parse(DateFormat.getDateInstance().format(date)));
          assertEquals(date, f.sampleDate);
          a = TypeAdapter.on(f, f.getClass().getField("sampleByte"));
          a.set(a.parse("123"));
          assertEquals(123, f.sampleByte);
          a = TypeAdapter.on(f, f.getClass().getField("sampleShort"));
          a.set(a.parse("12345"));
          assertEquals(12345, f.sampleShort);
      }

      class TestFixture extends ColumnFixture { // used in testTypeAdapter
          public byte sampleByte;
          public short sampleShort;
          public int sampleInt;
          public Integer sampleInteger;
          public float sampleFloat;
          public double pi () {return 3.14159862;}
          public char ch;
          public String name;
          public int[] sampleArray;
          public Date sampleDate;

      }

      public function testScientificDouble():void {
          Double pi = new Double(3.141592865);
          assertEquals(ScientificDouble.valueOf("3.14"), pi);
          assertEquals(ScientificDouble.valueOf("3.142"), pi);
          assertEquals(ScientificDouble.valueOf("3.1416"), pi);
          assertEquals(ScientificDouble.valueOf("3.14159"), pi);
          assertEquals(ScientificDouble.valueOf("3.141592865"), pi);
          assertTrue(!ScientificDouble.valueOf("3.140").equals(pi));
          assertTrue(!ScientificDouble.valueOf("3.144").equals(pi));
          assertTrue(!ScientificDouble.valueOf("3.1414").equals(pi));
          assertTrue(!ScientificDouble.valueOf("3.141592863").equals(pi));
          assertEquals(ScientificDouble.valueOf("6.02e23"), new Double(6.02e23));
          assertEquals(ScientificDouble.valueOf("6.02E23"), new Double(6.024E23));
          assertEquals(ScientificDouble.valueOf("6.02e23"), new Double(6.016e23));
          assertTrue(!ScientificDouble.valueOf("6.02e23").equals(new Double(6.026e23)));
          assertTrue(!ScientificDouble.valueOf("6.02e23").equals(new Double(6.014e23)));
      }

      public function testEscape():void {
          String junk = "!@#$%^*()_-+={}|[]\\:\";',./?`";
          assertEquals(junk, Fixture.escape(junk));
          assertEquals("", Fixture.escape(""));
          assertEquals("&lt;", Fixture.escape("<"));
          assertEquals("&lt;&lt;", Fixture.escape("<<"));
          assertEquals("x&lt;", Fixture.escape("x<"));
          assertEquals("&amp;", Fixture.escape("&"));
          assertEquals("&lt;&amp;&lt;", Fixture.escape("<&<"));
          assertEquals("&amp;&lt;&amp;", Fixture.escape("&<&"));
          assertEquals("a &lt; b &amp;&amp; c &lt; d", Fixture.escape("a < b && c < d"));
      }

      public function testRuns():void {
          run("arithmetic", 37, 10, 0, 2);
          run("CalculatorExample", 75, 9, 0, 0);
          run("MusicExample", 95, 0, 0, 0);
      }

      protected function run(String file, int right, int wrong, int ignores, int exceptions):void {

          String input = read(new File("Documents/"+file+".html"));
          Fixture fixture = new Fixture();
          Parse tables;
          if (input.indexOf("<wiki>") >= 0) {
              tables = new Parse(input, new String[]{"wiki", "table", "tr", "td"});
              fixture.doTables(tables.parts);
          } else {
              tables = new Parse(input, new String[]{"table", "tr", "td"});
              fixture.doTables(tables);
          }
          PrintWriter output = new PrintWriter(new BufferedWriter(new FileWriter("Reports/"+file+".html")));
          tables.print(output);
          output.close();
          assertEquals(file+" right", right, fixture.counts.right);
          assertEquals(file+" wrong", wrong, fixture.counts.wrong);
          assertEquals(file+" ignores", ignores, fixture.counts.ignores);
          assertEquals(file+" excpetions", exceptions, fixture.counts.exceptions);
      }


      protected String read(File input) throws IOException {
          char chars[] = new char[(int)(input.length())];
          FileReader in = new FileReader(input);
          in.read(chars);
          in.close();
          return new String(chars);
      }
    */
  }
}
