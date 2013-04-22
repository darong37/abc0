package com.eyos.apps.core;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

public class Utils {
  // Constant
	final static private String JSON_CLASS  = "net.arnx.jsonic.JSON";
	final static private SwLog logger      = SwLog.getLogger();

	// Static
	static synchronized public boolean notBlank(String str) {
		return !isBlank(str);
	}
	static synchronized public boolean isBlank(String str) {
		if (str == null || (str.length()) == 0) return true;
		if (str.matches("\\s*")) return true;
		return false;
	}
	static synchronized public boolean notBlank(String... array) {
		return !isBlank(array);
	}
	static synchronized public boolean isBlank(String... array) {
		if (isEmpty(array)) return true;
		for(String str:array){
			if (!isBlank(str)) return false;
		}
		return true;
	}

	static synchronized public boolean notEmpty(Object array[]) {
		return !isEmpty(array);
	}
	static synchronized public boolean isEmpty(Object array[]) {
		return array == null || array.length == 0;
	}
	@SuppressWarnings("rawtypes")
	static synchronized public boolean notEmpty(List lst) {
		return !isEmpty(lst);
	}
	@SuppressWarnings("rawtypes")
	static synchronized public boolean isEmpty(List lst) {
		return lst == null || lst.size() == 0;
	}

	static synchronized public String isNull(boolean allowEmpty,String... candidates){
		for(String candidate:candidates){
			if (!isBlank(candidate)){
				return candidate;
			}
		}
		if (allowEmpty) return "";
		throw new RuntimeException("All candidates is empty");
	}
	static synchronized public String format(String fmt,String...args){
		return format((Object)fmt,(Object[])args);
	}
	static synchronized public String format(Object ofmt,Object...args){
		return format(false,ofmt,args);
	}
	static synchronized public String format(boolean pretty,Object ofmt,Object...args){
		String fmt;
		if (ofmt==null){
			fmt = "";
		} else if (ofmt instanceof String){
			fmt = (String) ofmt;
		} else {
			fmt = toJson(ofmt,pretty);
		}
		//
		if (fmt.contains("{...}")){
			String rtn = fmt.replaceAll("\\{\\.\\.\\.\\}", "%s");
			String str;
			if ( args.length ==1 ) {
				str = toJson(args[0],pretty);
			} else {
				str = toJson(args,pretty);
			}
			return String.format(rtn, str);
		} else {
			String rtn = fmt.replaceAll("\\{\\{\\}\\}","{0}");

			int count = 0;
			while( rtn.contains("{}") ){
				rtn = rtn.replaceFirst("\\{\\}", "%s");
				count += 1;
			}

			String[] strs = new String[count];
			for(int idx = 0;idx<count;idx++){
				Object arg = null;
				if (args.length>idx) arg = args[idx];
				String str;
				if (arg instanceof String){
					str = (String) arg;
				} else {
					str = toJson(arg,pretty);
				}
				strs[idx]  = str;
			}
			rtn = rtn.replaceAll("\\{0\\}","{}");
			return String.format(rtn, (Object[])strs);
		}
	}
	//
	//		Array
	//
	static synchronized public <T> List<T> toList(T[] array){
		if (isEmpty(array)){
			warn("toList : Parameter is empty");
			return null;
		}
		List<T> list = Arrays.asList(array);
		list = new LinkedList<T>(list);
		return list;
	}
	static synchronized public <T> T shift(List<T> list){
		if (isEmpty(list)){
			warn("shift : Parameter is empty");
			return null;
		}
		if (list instanceof ArrayList) {
			list = new LinkedList<T>(list);
		}
		return list.remove(0);
	}
	static synchronized public <T> T unshift(List<T> list){
		if (isEmpty(list)){
			warn("shift : Parameter is empty");
			return null;
		}
		if (list instanceof ArrayList) {
			list = new LinkedList<T>(list);
		}
		return list.remove(list.size()-1);
	}
	
	static synchronized public String[] slice(String[] args,int begin,int end){
		return slice(args,begin,end,new String[0]);
	}
	
	static synchronized public <T> T[] slice(T[] args,int begin,int end,T[] newArgs){
		if (begin < 0) begin = args.length + begin;
		if (begin>=args.length) return newArgs;
		if (end   < 0) end   = args.length + end;
		if (end  >=args.length) return newArgs;
		List<T> alst = Arrays.asList(args);
		if (begin > end){
			alst = alst.subList(end, begin+1);
			Collections.reverse(alst);
		} else {
			alst = alst.subList(begin,end+1);
		}
		return alst.toArray(newArgs);
	}
	
	public synchronized static String[] align(String... strs) {
		List<String> rtn = new ArrayList<String>();
		for(String str : strs){
			if(!isBlank(str)) {
				rtn.add(str);
			}
		}
		return rtn.toArray(new String[0]);
	}

	public static String join(Object array[], String separator) {
		if (array == null)
			return null;
		else
			return join(array, separator, 0, array.length);
	}

	public static String join(Object array[], String separator, int startIndex,
			int endIndex) {
		if (array == null)
			return null;
		if (separator == null)
			separator = "";
		int bufSize = endIndex - startIndex;
		if (bufSize <= 0)
			return "";
		bufSize *= (array[startIndex] != null ? array[startIndex].toString()
				.length() : 16) + separator.length();
		StringBuffer buf = new StringBuffer(bufSize);
		for (int i = startIndex; i < endIndex; i++) {
			if (i > startIndex)
				buf.append(separator);
			if (array[i] != null)
				buf.append(array[i]);
		}

		return buf.toString();
	}
	//
	static synchronized public String toJson(Object obj, boolean pretty) {
		if (obj==null) return "null";

		Class<?> cls = obj.getClass();
		String clsnam  = cls.getName();
		if (clsnam.equals("java.lang.String")) {
			return "'" + obj.toString() + "'";
		} else if (clsnam.equals("java.lang.Integer")) {
			return obj.toString();
		}
		//
		String rtn = null;
		if ( Reflect.exist(JSON_CLASS) ){
			Reflect ref = new Reflect(JSON_CLASS);
			rtn = (String) ref.staticMethod("encode", new Class<?>[]{Object.class,boolean.class},obj,pretty);
		} else {
			rtn = obj.toString();
		}
		return rtn;
	}
	static synchronized public Object toObject(String jstr,Class<?> cls){
		Object rtn = null;
		if ( Reflect.exist(JSON_CLASS) ){
			Reflect ref = new Reflect(JSON_CLASS);
			rtn = ref.staticMethod("decode", jstr,cls);
		} else {
			throw new RuntimeException("No JSON");
		}
		return rtn;
	}
	static synchronized public Object toObject(String jstr,Type typ){
		Object rtn = null;
		if ( Reflect.exist(JSON_CLASS) ){
			Reflect ref = new Reflect(JSON_CLASS);
			rtn = ref.staticMethod("decode", jstr,typ);
		} else {
			throw new RuntimeException("No JSON");
		}
		return rtn;
	}
	//
	// Argument
	//
	static synchronized public String argsDef(String[] args, int idx) {
		if (args.length > idx) {
			if (isBlank(args[idx])) {
				return null;
			} else {
				return args[idx];
			}
		} else {
			return null;
		}
	}
	static synchronized public String argsDef(String[] args, int idx, String dflt) {
		if (args.length > idx) {
			if (isBlank(args[idx])) {
				return dflt;
			} else {
				return args[idx];
			}
		} else {
			return dflt;
		}
	}
	static synchronized public String argsDef(String[] args, int idx, RuntimeException e) {
		if (args.length > idx) {
			if (isBlank(args[idx])) {
				throw e;
			} else {
				return args[idx];
			}
		} else {
			throw e;
		}
	}
	

	//
	// Logging
	//
	static synchronized public void trace(String fmt,Object...args){
		logger.trace(format(fmt,args));
	}
	static synchronized public void trace(Object obj){
		String str;
		if (obj instanceof String){
			str = (String) obj;
		} else {
			str = toJson(obj,false);
		}
		logger.trace(str);
	}

	static synchronized public void info(String fmt,Object...args){
		logger.info(format(fmt,args));
	}
	static synchronized public void info(Object obj){
		String str;
		if (obj instanceof String){
			str = (String) obj;
		} else {
			str = toJson(obj,false);
		}
		logger.info(str);
	}

	static synchronized public void warn(String fmt,Object...args){
		warn(format(fmt,args));
	}
	static synchronized public void warn(Object obj){
		String str;
		if (obj instanceof String){
			str = (String) obj;
		} else if (obj instanceof NullPointerException){
			Throwable e = (Throwable) obj;
			str = getStackTrace(e);
		} else if (obj instanceof Throwable){
			Throwable e = (Throwable) obj;
			str = e.getMessage();
		} else {
			str = toJson(obj,false);
		}
		logger.warn(str);
	}

	static synchronized protected String getStackTrace(Throwable exc){
		String rtn;
		StringWriter sw = new StringWriter();
		PrintWriter  pw = new PrintWriter(sw); 
		exc.printStackTrace(pw);
		rtn = sw.toString();
		try {
			pw.close();
			sw.close();
		} catch (IOException e) {
		}
		return rtn;
	}
	
	//
	static synchronized public void pretty(int idx, Object obj) {
		pretty(String.valueOf(idx), obj);
	}
	static synchronized public void pretty(Object obj) {
		pretty(null, obj);
	}
	static synchronized public void pretty(String head, Object obj) {
		String header = "";
		if (isBlank(head)) {
			header = "";
		} else {
			header = head + " = \n";
		}

		if (obj == null) {
			info(header + "NULL");
		} else {
			String clz = obj.getClass().getName();
			if (clz.equals("java.lang.String") || clz.equals("java.lang.Integer")) {
				if (!isBlank(head)) {
					header = head + " = ";
				}
			}
			try {
				info(header + toJson(obj, true));
			} catch (Exception e) {
				info(header + obj.getClass().getName() + " := " + obj.toString());
			}
		}
	}

	static public RuntimeException unsupported(){
		return new UnsupportedOperationException();
	}

	static synchronized public void errexit(Throwable e,Object obj){
		int rtn = 0;
		String str;
		if (obj instanceof String){
			str = (String) obj;
		} else {
			try{
				str = toJson(obj,true);
			} catch(Exception ex){
				str = format("Unknown Object Structure({}) ",obj.getClass().getName());
			}
		}
		//
		if (e==null){
			logger.info("Normal - "+str);
		} else if (e instanceof NullPointerException){
			e.printStackTrace();
			logger.error(format("Return Error Status({})",rtn),e);
		} else {
			rtn = 1;
			e.printStackTrace();
			logger.error(format("Return Error Status({})",rtn),e);
			logger.error(str);
		}
		//
		System.exit(rtn);
	}
	// Factory
	// Instance,init
	// Property,setter,getter
	// Override
	// Method

	// Main
}
