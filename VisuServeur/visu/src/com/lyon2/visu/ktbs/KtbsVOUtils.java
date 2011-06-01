package com.lyon2.visu.ktbs;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.ithaca.domain.model.KtbsObsel;

public class KtbsVOUtils {

	public static final Comparator<KtbsObsel> beginDateComparator = new Comparator<KtbsObsel>() {

		public int compare(KtbsObsel a, KtbsObsel b) {
			return a.getBegin().compareTo(b.getBegin());
		}
		
	};
	
	public static final void sortObselList(List<KtbsObsel> list) {
		Collections.sort(list, beginDateComparator);
	}
}
