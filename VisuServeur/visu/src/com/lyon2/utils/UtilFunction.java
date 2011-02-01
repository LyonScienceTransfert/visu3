package com.lyon2.utils;

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
}
