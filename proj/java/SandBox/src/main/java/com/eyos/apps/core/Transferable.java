package com.eyos.apps.core;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Map;
import java.util.Properties;

@SuppressWarnings("serial")
public class Transferable extends Properties{
  // Sub-class(enum)
	// Constant
	// Static
	@SuppressWarnings("rawtypes")
	static synchronized public String translate(String txt, char mark,Map map, boolean complete) {
		if (txt.indexOf(mark) == -1)
			return txt;
		StringBuffer rtn = new StringBuffer();
		int depth = 0;
		char prev = ' ';
		char ch = ' ';
		StringBuffer keybuf = null;
		for (int idx = 0; idx < txt.length(); idx++) {
			prev = ch;
			ch = txt.charAt(idx);
			// markup
			if (depth == 0) {
				if (prev == mark) {
					if (ch == '{') {
						depth += 1;
						keybuf = new StringBuffer();
						continue;
					} else {
						rtn.append(mark);
					}
				}
				if (ch == mark)
					continue;
			} else {
				if (prev == mark) {
					if (ch == '{') {
						depth += 1;
					}
				}
				if (ch == '}') {
					depth -= 1;
					//
					if (depth == 0) {
						String key = keybuf.toString();
						if (map.containsKey(key)) {
							String val = (String) map.get(key);
							val = translate(val, mark, map, complete);
							rtn.append(val);
						} else {
							if (complete) {
								throw new RuntimeException(String.format("Key('%s') not found", key));
							} else {
								rtn.append(mark);
								rtn.append('{');
								rtn.append(key);
								rtn.append('}');
							}
						}
						continue;
					}
				}
			}
			//
			if (depth != 0) {
				keybuf.append(ch);
			} else {
				rtn.append(ch);
			}
		}
		if (depth != 0) {
			String key = keybuf.toString();
			if (map.containsKey(key)) {
				String val = (String) map.get(key);
				rtn.append(val);
			} else {
				rtn.append(mark);
				rtn.append('{');
				rtn.append(key);
				rtn.append('}');
			}
		}
		return rtn.toString();
	}
	// Factory
	// Instance,init
	// Property,setter,getter
	// Public  Method
	public void load(File properties){
		try {
			InputStream inStream = new FileInputStream(properties);
			load(inStream);
		} catch (Exception e) {
			throw new RuntimeException(String.format("Can not load File '%s'",properties.getName()),e);
		}
	}
	public void load(String propertiesPath){
		try {
			InputStream inStream = new FileInputStream(new File(propertiesPath));
			load(inStream);
		} catch (Exception e) {
			throw new RuntimeException(String.format("Can not load FilePath '%s'",propertiesPath),e);
		}
	}
	public String transfer(String raw){
		return translate(raw,'$',this,true);
	}
	public void status(){
		String[] keys = keySet().toArray(new String[0]);
		Arrays.sort(keys);

		Utils.info("Status");
		for(String key:keys){
			String value  = super.getProperty(key);

			String txt;
			String sysval = System.getProperty(key,null);
			if (sysval==null){
				txt = String.format("%-40s  =  '%s'", key, value);
			} else {
				if (sysval.equals(value)){
					txt = String.format("%-40s :=  '%s'", key, value);
				} else {
					txt = String.format("%-40s  =  '%s'", key, value);
					Utils.info(txt);
					txt = String.format("%-40s :   '%s'", " ", sysval);
				}
			}
			Utils.info(txt);

			if (value.contains("${")){
				String tval = translate(value,'$',this,false);
				txt = String.format("%-40s  -> '%s'", " (transfer) ", tval);
				Utils.info(txt);
			}
		}
		Utils.info("");
	}
	// Private Method
	// Override
	@Override
	public synchronized Object get(Object key) {
//		if (key.equals("test.*")){
//			Properties rtn = new Properties();
//			rtn.setProperty("name"  , "Meina");
//			rtn.setProperty("family", "Liu");
//			return rtn;
//		}
//		
		String rtn = (String) super.get(key);
		if (Utils.isBlank(rtn)) throw new RuntimeException(String.format("Key '%s' is invalid(Blank)",key));
		return transfer(rtn);
	}
	@Override
	public Object setProperty(String key,String value) {
		Object rtn;
		if (!value.equals("N/A")) {
			rtn = super.setProperty(key, value);
		} else {
			rtn = null;
		}
		return rtn;
	}

	@Override
	public String getProperty(String key) {
		String rtn = (String) super.get(key);
		if (Utils.isBlank(rtn)) throw new RuntimeException(String.format("Key '%s' is invalid(NULL)",key));
		return transfer(rtn);
	}

	@Override
	public String getProperty(String key, String defaultValue) {
		String rtn = (String) super.get(key);
		if (Utils.isBlank(rtn)) rtn = defaultValue;
		if (Utils.isBlank(rtn)) throw new RuntimeException(String.format("Key '%s' is invalid(NULL)",key));
		return transfer(rtn);
	}
	// Main
}
