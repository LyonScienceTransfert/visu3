
package com.lyon2.utils;


public class ObselStringParams {

    private String traceParam;

    private String refParam;

	public ObselStringParams(String traceParam, String refParam){
		this.traceParam = traceParam;
		this.refParam = refParam;
		//this.traceParam = "%-2>%";
		//this.refParam = "%:hasSession \"4\"%";

		//"%-" + tempTrace + ">%", "%:hasSession " + "\""+tempRdf+"\"%"
	}
	
    public String getTraceParam() {
        return this.traceParam;
    }

    public String getRefParam() {
        return this.refParam;
    }
    
    /**
     * toString will return String object representing the state of this 
     * valueObject. This is useful during application development, and 
     * possibly when application is writing object states in textlog.
     */
    public String toString() {
        StringBuffer out = new StringBuffer("\nclass ObselStringParams ");
        out.append("traceParam = " + this.traceParam + ", ");
        out.append("refParam = " + this.refParam + "|");
		return out.toString();
    }

}
