package com.eyos.apps;

import java.io.IOException;

import org.springframework.context.ApplicationContext;

import com.eyos.apps.core.Reflect;
import com.eyos.base.AppException;
import com.eyos.base.BaseUtils;
import com.eyos.base.Convention;
import com.eyos.base.PlugIn;
import com.eyos.framework.spring.BeansUtils;

public class AppMain  extends Convention {
	// Sub-class(enum)
	// Constant
	// Static
	// Factory
	// Instance,init
	// Property,setter,getter
	// Public  Method
	// Private Method
	// Override

	// Main
	public static void main(String[] args) throws IOException {
		setting();
		mkdir(getHome("log"));
		//
		try{
			String entryPoint = argsDef(args, 0);
			args = slice(args,1,-1);

			@SuppressWarnings("unused")
			Object rtn;
			if ( Reflect.exist(entryPoint) ){
				Reflect ref = new Reflect(entryPoint);
				rtn = (Object) ref.mainMehtod(args);
			} else {
				errexit(new AppException("Entry point({}) not found",entryPoint),entryPoint);
			}
		} catch (Exception e) {
			errexit(e, "");
		}

	}
	public static void main2(String[] args) throws IOException {
		setting();
		AppConst.GlobalProp.status();
		mkdir(getHome("log"));
		mkdir(getHome("work"));
		//
		try{
			ApplicationContext context = BeansUtils.getApplicationContext();

			PlugIn hk = (PlugIn)context.getBean("HouseKeeping");
			hk.initialize(null, null);
			hk.execute();
		} catch (Exception e) {
			errexit(e, "");
		}
	}
}
