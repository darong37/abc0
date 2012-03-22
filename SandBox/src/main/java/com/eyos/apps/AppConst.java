package com.eyos.apps;

import com.eyos.apps.core.SwLog;
import com.eyos.apps.core.Transferable;

public class AppConst {
  static public final String    ApplicationName       = "AppSand2";
	static public final String    BasisRelativePath     = "conf";
	static public final String    ConfRelativePath      = "conf";
	static public final String    DefaultPropertiesName = "application.properties";
	static public final String    ExternalPath          = "N/A";
	
	static public final SwLog.Key    FundamentalSwLog   = SwLog.Key.log4j;
	static public final Transferable GlobalProp         = new Transferable();
	
	//
	static public String get(String key){
		String rtn;
		try{
			rtn = GlobalProp.getProperty(key);
		} catch (RuntimeException e) {
			rtn = System.getProperty(key,null);
			if (rtn==null) {
				throw e;
			}
		}
		return rtn;
	}
}
