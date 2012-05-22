package com.lyon2.utils;

import java.util.HashMap;
import java.util.Map;

public class UtilFunction {

	public static String changeFirstCharUpper(String value) 
	{
		// set big letters
		String upperParam = value.toUpperCase();
		// get first big letter
		String ch = Character.toString(upperParam.charAt(0));
		// replace first by big letter
		String result = value.replaceFirst("[a-z]", ch);
		return result;
	}
	
	public static Map<String, Object> createParams(Object... params) {
		Map<String, Object> map = new HashMap<String, Object>();
		for(int k=0;k<params.length/2;k++) 
			map.put((String) params[2*k],params[2*k+1]);
		return map;
	}
}
