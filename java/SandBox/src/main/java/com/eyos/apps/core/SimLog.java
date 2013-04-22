package com.eyos.apps.core;

import java.util.logging.ConsoleHandler;
import java.util.logging.Formatter;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;

import com.eyos.apps.AppConst;
public class SwLog {
  // Sub-class(enum)
	public enum Key{
		slf4j,
		log4j,
		jdk
	}

	static protected class SimFormatter extends Formatter {
		private String format = "%tT %s %s\n";
		@Override
		public String format(LogRecord record) {
			return String.format(format, 
				record.getMillis(), 
				record.getLevel().getName(), 
//				record.getSourceClassName(), 
//				record.getSourceMethodName(), 
				record.getMessage());
		}
	}

	// Constant
	// Static
	static private Logger jlogger = Logger.getLogger("JDK");
	
	static private String     LoggerFactory ;
	static private String     LoggerClass   ;
	static private Class<?>[] ArgTypes      ;
	static private Class<?>[] ArgTypes2     ;
	static {
		// Handler を作成
		Handler handler = new ConsoleHandler();
		// log ファイルを見やすくするため、SimFormatter をセット
		handler.setFormatter(new SwLog.SimFormatter());
		// Logger に Handler をセット
		jlogger.setUseParentHandlers(false);
		jlogger.addHandler(handler);
		
		switch(AppConst.FundamentalSwLog){
		case slf4j :
			LoggerFactory = "org.slf4j.LoggerFactory";
			LoggerClass   = "org.slf4j.Logger";
			ArgTypes      = new Class<?>[]{String.class};
			ArgTypes2     = new Class<?>[]{String.class,Throwable.class};
			break;
		case log4j :
			LoggerFactory = "org.apache.log4j.Logger";
			LoggerClass   = "org.apache.log4j.Logger";
			ArgTypes      = new Class<?>[]{Object.class};
			ArgTypes2     = new Class<?>[]{Object.class,Throwable.class};
			break;
		default:
			LoggerFactory = null;
			LoggerClass   = null;
			ArgTypes      = null;
			ArgTypes2     = null;
			break;
		}
	}

	// Factory
	static public SwLog getLogger(){
		return new SwLog();
	}
	
	// Instance,init
	private Reflect logger;
	private SwLog(){
	}
	private void init(){
		if (LoggerFactory!=null){
			if (Reflect.exist(LoggerFactory)){
				Reflect factory  = new Reflect(LoggerFactory);
				Object  instance = factory.staticMethod("getLogger", "Logger");

				if (Reflect.exist(LoggerClass)){
					logger = new Reflect(LoggerClass);
					logger.setInstance(instance);
					if (logger==null){
						System.err.println("WARN  - Logger %s can not create");
						LoggerFactory = null;
						LoggerClass   = null;
					}
				} else {
					System.err.println(String.format("WARN  - Logger Class %s can not load",LoggerClass));
					System.err.println(String.format("Please confirm AppConst.FundamentalSwLog"));
					LoggerFactory = null;
					LoggerClass   = null;
				}
			} else {
				System.err.println(String.format("WARN  - Logger Factory %s can not load",LoggerFactory));
				LoggerFactory = null;
				LoggerClass   = null;
			}
		}

	}
	// Property,setter,getter
	// Public  Method
	public void trace(String s) {
		if (logger==null) init();
		if (logger!=null){
			logger.method(ArgTypes,"trace",s);
		} else {
			jlogger.info(s);
		}
	}

	public void info(String s) {
		if (logger==null) init();
		if (logger!=null){
			logger.method(ArgTypes,"info",s);
		} else {
			jlogger.info(s);
		}
	}
	public void warn(String s) {
		if (logger==null) init();
		if (logger!=null){
			logger.method(ArgTypes,"warn", s);
		} else {
			jlogger.warning(s);
		}
	}
	public void error(String s) {
		if (logger==null) init();
		if (logger!=null){
			logger.method(ArgTypes,"error", s);
		} else {
			jlogger.severe(s);
		}
	}
	public void error(String s,Throwable e) {
		if (logger==null) init();
		if (logger!=null){
			logger.method(ArgTypes2,"error",s,e);
		} else {
			jlogger.log(Level.SEVERE,s,e);
		}
	}
	// Private Method
	// Override

	// Main
}
