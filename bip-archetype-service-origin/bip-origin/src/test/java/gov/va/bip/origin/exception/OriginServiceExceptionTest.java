/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gov.va.bip.origin.exception;

import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

import gov.va.bip.framework.messages.MessageKeys;
import gov.va.bip.framework.messages.MessageSeverity;

/**
 *
 * @author rthota
 */
public class OriginServiceExceptionTest {
	OriginServiceException instance;

	private static final String NAME = "NO_KEY";
	private static final String MESSAGE = "NO_KEY";

	@Before
	public void setUp() {
		instance = new OriginServiceException(MessageKeys.NO_KEY, MessageSeverity.ERROR, null);
	}

	/**
	 * Test of getSeverity method, of class OriginServiceException.
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
	 * Test of getKey method, of class OriginServiceException.
	 */
	@Test
	public void testGetKey() {
		System.out.println("getKey");
		String expResult = NAME;
		String result = instance.getKey();
		assertEquals(expResult, result);
	}

	/**
	 * Test of setKey method, of class OriginServiceException.
	 */

	/**
	 * Test of getMessage method, of class OriginServiceException.
	 */
	@Test
	public void testGetMessage() {
		System.out.println("getMessage");
		String expResult = MESSAGE;
		String result = instance.getMessage();
		assertEquals(expResult, result);

	}
}
