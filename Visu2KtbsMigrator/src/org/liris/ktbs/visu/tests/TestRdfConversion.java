package org.liris.ktbs.visu.tests;

import java.io.IOException;
import java.io.Reader;
import java.sql.SQLException;

import org.liris.ktbs.visu.VisuToKtbsUtils;
import org.liris.ktbs.visu.vo.ObselVO;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;

public class TestRdfConversion {

	public static void main(String[] args) throws Exception {
		test(9577);
	}

	private static void test(int i) throws Exception {
		ObselVO obsel = getObsel(i);
		
		String raw = obsel.getRdf();
		String fixed = VisuToKtbsUtils.fixRdfString(
				raw, 
				"http://testdomain/testbase/testmodel/", 
				"http://testdomain/testuserbase/");
		
		System.out.println(raw);
		System.out.println("------------------------------------");
		System.out.println(fixed);
		System.out.println("------------------------------------");
		obsel.parseRdf("http://testdomain/testbase/testmodel/", "http://testdomain/testuserbase/");
	}

	private static ObselVO getObsel(int i) {
		Reader reader;
		try {
			reader = Resources.getResourceAsReader("ibatis/sqlMapConfig.xml");
			SqlMapClient sqlMap = SqlMapClientBuilder.buildSqlMapClient(reader);
			return (ObselVO)sqlMap.queryForObject("obsel.getObsel", i);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		System.exit(1);
		return null;
	}
}