package com.eyos.base.core;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.ArrayList;

public class Reflect {
  static public boolean exist(String className){
		try {
			Class.forName(className);
			return true;
		} catch (ClassNotFoundException e) {
			return false;
		}
	}
	//
	private String clsnam = null;
	private Class<?> cls = null;
	public Reflect(String className){
		this.clsnam = className;
		try {
			this.cls = Class.forName(className);
		} catch (ClassNotFoundException e) {
			throw new RuntimeException(e);
		}
	}
	//
//	public boolean exist(){
//		return cls != null;
//	}
	private Object instance = null;
	public void setInstance(Object instance){
		this.instance = instance;
	}
	public Reflect newSelf(Object...args){
		newInstance(args);
		return this;
	}
	//
	public boolean typDef     = false;
	public Class<?>[] typDefs = null;
	public void setTypes(Class<?>[] types){
		this.typDef = true;
		this.typDefs = types;
	}
	public Class<?>[] types(Object...args){
		if(typDef){
			return typDefs;
		}
		ArrayList<Class<?>> typelist = new ArrayList<Class<?>>();
		for(Object arg : args){
			Class<?> clz = arg.getClass();
			typelist.add(clz);
		}
		Class<?>[] rtn = typelist.toArray(new Class<?>[0]);
		return rtn;
	}
	//
	public Object newInstance(Object...args){
		if (cls==null) throw new RuntimeException(String.format("Class(%s) is not exist",clsnam));
		try {
			if ( args == null || args.length==0 ){
				instance = cls.newInstance();
			} else {
				Class<?>[] types = types(args);
				Constructor<?> cunstructor = cls.getConstructor(types);
				instance = cunstructor.newInstance(args);
			}
		} catch (Exception e) {
			throw new RuntimeException("newInstance failed",e);
		}
		return instance;
	}
	public Object staticMethod(String methodname,Object...args){
		Class<?>[] types = types(args);
		return staticMethod(methodname,types,args);
	}
	public Object staticMethod(String methodname,Class<?>[] types,Object...args){
		if (cls==null) throw new RuntimeException(String.format("Class(%s) is not exist",clsnam));
		Method method;
		try {
			if (args == null || args.length==0) {
				method = cls.getMethod(methodname);
			} else {
				method = cls.getMethod(methodname,types);
			}
		} catch (Exception e) {
			throw new RuntimeException(String.format("Static method(%s,%s) get failed",clsnam,methodname),e);
		}
		//
		Object rtn;
		try {
			rtn = method.invoke(cls,args);
		} catch (Exception e) {
			throw new RuntimeException(String.format("Static method(%s,%s) run failed",clsnam,methodname),e);
		}

		return rtn;
	}
	public Object method(String methodname,Object...args){
		if (cls==null) throw new RuntimeException(String.format("Class(%s) is not exist",clsnam));
		if (instance==null) throw new RuntimeException(String.format("Instance(%s) is null",clsnam));
		Method method;
		try {
			if (args == null || args.length==0) {
				method = cls.getMethod(methodname);
			} else {
				Class<?>[] types = types(args);
				method = cls.getMethod(methodname,types);
			}
		} catch (Exception e) {
			throw new RuntimeException(String.format("Method(%s,%s) get failed",clsnam,methodname),e);
		}
		//
		Object rtn;
		try {
			rtn = method.invoke(instance,args);
		} catch (Exception e) {
			throw new RuntimeException(String.format("Method(%s,%s) run failed",clsnam,methodname),e);
		}

		return rtn;
	}
	public Object method(String methodname,Class<?>[] types,Object...args){
		if (cls==null) throw new RuntimeException(String.format("Class(%s) is not exist",clsnam));
		if (instance==null) throw new RuntimeException(String.format("Instance(%s) is null",clsnam));
		Method method;
		try {
			if (args == null || args.length==0) {
				method = cls.getMethod(methodname);
			} else {
				method = cls.getMethod(methodname,types);
			}
		} catch (Exception e) {
			throw new RuntimeException(String.format("Method(%s,%s) get failed",clsnam,methodname),e);
		}
		//
		Object rtn;
		try {
			rtn = method.invoke(instance,args);
		} catch (Exception e) {
			throw new RuntimeException(String.format("Method(%s,%s) run failed",clsnam,methodname),e);
		}

		return rtn;
	}

}
