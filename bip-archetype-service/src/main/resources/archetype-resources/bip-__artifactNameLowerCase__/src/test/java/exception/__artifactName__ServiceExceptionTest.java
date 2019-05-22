#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gov.va.bip.${artifactNameLowerCase}.exception;

import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

import gov.va.bip.framework.messages.MessageKeys;
import gov.va.bip.framework.messages.MessageSeverity;

/**
 *
 * @author rthota
 */
public class ${artifactName}ServiceExceptionTest {
	${artifactName}ServiceException instance;

	private static final String NAME = "NO_KEY";
	private static final String MESSAGE = "NO_KEY";

	@Before
	public void setUp() {
		instance = new ${artifactName}ServiceException(MessageKeys.NO_KEY, MessageSeverity.ERROR, null);
	}

	/**
	 * Test of getSeverity method, of class ${artifactName}ServiceException.
	 *
	 * @throws Exception
	 */
	@Test
	public void testGetSeverity() throws Exception {
		System.out.println("getSeverity");
		MessageSeverity expResult = MessageSeverity.ERROR;
		MessageSeverity result = instance.getSeverity();
		assertEquals(expResult, result);
	}

	/**
	 * Test of getKey method, of class ${artifactName}ServiceException.
	 */
	@Test
	public void testGetKey() {
		System.out.println("getKey");
		String expResult = NAME;
		String result = instance.getKey();
		assertEquals(expResult, result);
	}

	/**
	 * Test of setKey method, of class ${artifactName}ServiceException.
	 */

	/**
	 * Test of getMessage method, of class ${artifactName}ServiceException.
	 */
	@Test
	public void testGetMessage() {
		System.out.println("getMessage");
		String expResult = MESSAGE;
		String result = instance.getMessage();
		assertEquals(expResult, result);

	}
}
