package com.ithaca.domain.model;

import java.util.Set;

public class KtbsObsel {

	private String uri;
	private String obselType;
	
	private String beginDT;
	private String endDT;
	
	private Long beginDTMS;
	public Long getBeginDTMS() {
		return beginDTMS;
	}
	public void setBeginDTMS(Long beginDTMS) {
		this.beginDTMS = beginDTMS;
	}
	public Long getEndDTMS() {
		return endDTMS;
	}
	public void setEndDTMS(Long endDTMS) {
		this.endDTMS = endDTMS;
	}
	private Long endDTMS;
	
	private Long begin;
	private Long end;

	private String subject;
	private Set<KtbsAttributePair> attributes;
	
	private String hasTrace;
	
	public String getHasTrace() {
		return hasTrace;
	}
	public void setHasTrace(String hasTrace) {
		this.hasTrace = hasTrace;
	}
	public String getUri() {
		return uri;
	}
	public void setUri(String uri) {
		this.uri = uri;
	}
	public String getObselType() {
		return obselType;
	}
	public void setObselType(String obselType) {
		this.obselType = obselType;
	}
	public String getBeginDT() {
		return beginDT;
	}
	public void setBeginDT(String beginDT) {
		this.beginDT = beginDT;
	}
	public String getEndDT() {
		return endDT;
	}
	public void setEndDT(String endDT) {
		this.endDT = endDT;
	}
	public Long getBegin() {
		return begin;
	}
	public void setBegin(Long begin) {
		this.begin = begin;
	}
	public Long getEnd() {
		return end;
	}
	public void setEnd(Long end) {
		this.end = end;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public Set<KtbsAttributePair> getAttributes() {
		return attributes;
	}
	public void setAttributes(Set<KtbsAttributePair> attributes) {
		this.attributes = attributes;
	}
	
}
